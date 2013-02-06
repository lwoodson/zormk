ExternalActiveRecord = ActiveRecord

require "zormk/lambdas"
require "zormk/commands"

module Zormk
  module Utf
    def to_char(code)
      [code].pack("U*")
    end

    def solid_line
      to_char(0x2500)*2
    end

    def dashed_line
      to_char(0x002D)*2
    end

    def dash
      to_char(0x2500)
    end

    def inheritance_arrowhead
      to_char(0x25C3)
    end

    def many_endpoint_left
      to_char(0x220B)
    end

    def many_endpoint_right
      to_char(0x2208)
    end

    def one_endpoint
      to_char(0x25CF)
    end

    def no_ref
      to_char(0x25CB)
    end

  end

  module ActiveRecord
    class Renderer
      extend Zormk::Utf

      def initialize
        @class_renderer = ClassRenderer.new
      end

      def render_location(location)
        if location.object.class == Class
          @class_renderer.render_location(location)
        else
          raise "Can't handle #{location.object.class}"
        end
      end

      def render_moved_location(viewer, old_loc, new_loc)
        if old_loc.object.class == Class
          @class_renderer.render_moved_location(viewer, old_loc, new_loc)
        else
          raise "Can't handle #{old_loc.object.class}"
        end
      end

    end

    class ClassRenderer
      include Zormk::Utf
      include Zormk::Lambdas

      def render_location(location)
        model_class = location.object
        column_descs = gather_column_descs(model_class)
        association_descs = gather_association_descs(model_class)
        loc_desc = build_loc_desc(header_for(model_class), column_descs, association_descs)  
        "#{loc_desc}\nPaths: #{build_paths_desc(location)}"
      end

      def render_moved_location(viewer, old_loc, new_loc)
        dest_class = new_loc.object
        "Moving to #{dest_class.name}..."
      end

      private
      def build_loc_desc(header, column_descs, association_descs)
        hr = hr_for(header, column_descs, association_descs)
        result = "#{hr}\n#{header.join("\n")}\n#{hr}\n"
        result << "#{column_descs.join("\n")}\n"
        result << "#{association_descs.join("\n")}\n"
        result << "#{hr}\n"
        result
      end

      def build_paths_desc(location)
        location.paths.map(&to_name).join(", ")
      end

      def describe_col
        lambda {|col| "    -  #{col.name}: #{col.type}"}
      end

      def describe_association
        lambda {|ref| ReflectionRenderer.new(ref).render } 
      end

      def directly_included_modules(model_class)
        model_class.included_modules - ExternalActiveRecord::Base.included_modules
      end

      def header_for(model_class)
        result = ["#{model_class.name} [#{model_class.table_name.upcase}]"]
        result << "  #{inheritance_arrowhead}#{solid_line}  #{model_class.superclass.name}"
        directly_included_modules(model_class).select(&with_name).each do |inc_module|
          result << "  #{inheritance_arrowhead}#{dashed_line}  #{inc_module.name}"
        end
        result
      end

      def with_name
        lambda {|ele| ele.respond_to?(:name) and not ele.name.nil?}
      end

      def gather_column_descs(model_class)
        model_class.columns.sort(&alphabetical_by_name).map(&describe_col)
      end

      def gather_association_descs(model_class)
        model_class.reflections.values.sort(&alphabetical_by_name).map(&describe_association)
      end

      def hr_for(header, column_descs, assoc_descs)
        size = 0
        header.each{|line| size = line.size > size ? line.size : size}
        column_descs.each{|col_desc| size = col_desc.size > size ? col_desc.size : size}
        assoc_descs.each{|ass_desc| size = ass_desc.size > size ? ass_desc.size : size}
        dash * size
      end
    end

    class ReflectionRenderer
      extend Zormk::Utf
      include Zormk::Utf

      TO_ASSOCIATIONS = {
        :belongs_to => one_endpoint,
        :has_many => many_endpoint_right,
        :has_one => one_endpoint,
        :has_and_belongs_to_many => many_endpoint_right
      }

      FROM_ASSOCIATIONS = {
        :belongs_to => one_endpoint,
        :has_many => many_endpoint_left,
        :has_one => one_endpoint,
        :has_and_belongs_to_many => many_endpoint_left
      }

      def self.render_association(to, from)
        "#{FROM_ASSOCIATIONS[from] || no_ref}#{dash}#{TO_ASSOCIATIONS[to] || no_ref}"
      end

      def initialize(reflection)
        @reflection = reflection
      end

      def render
        begin
          other_type = @reflection.class_name.constantize
          inverse_reflection = other_type.reflections.values.detect(
                                 &by_foreign_key(@reflection.foreign_key))
          association = ReflectionRenderer.render_association(
                          @reflection.macro, inverse_macro(inverse_reflection))
          "  #{association}  #{@reflection.name}: #{render_class_name}#{render_through_assoc}"
        rescue NameError
          "  #{dash}#{dash}#{one_endpoint}  #{@reflection.name}: #{@reflection.class_name}"
        end
      end

      private
      def by_foreign_key(foreign_key)
        lambda {|ref| ref.foreign_key == foreign_key or 
                      ref.association_foreign_key == foreign_key}
      end

      def inverse_macro(inverse_reflection)
        inverse_reflection ? inverse_reflection.macro : nil
      end

      def render_class_name
        if @reflection.collection?
          "[#{@reflection.class_name}]"
        else
          "#{@reflection.class_name}"
        end
      end

      def render_through_assoc
        result = ""
        if @reflection.through_reflection
          result = " through #{@reflection.through_reflection.name}"
        end
        result
      end
    end
  end
end

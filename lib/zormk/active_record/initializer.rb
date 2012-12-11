require 'zormk/lambdas'
require 'obj_mud/model'

module Zormk
  module ActiveRecord
    module Initializer
      extend Zormk::Lambdas

      def self.init_location(location)
        location.object.reflections.values.sort(&alphabetical_by_name).each do |ref|
          begin
            location.paths << ObjMud::Model::Path.new(ref.name, ref.class_name.constantize)
          rescue Exception => e
            # TODO log warning.
          end
        end
      end
    end
  end
end

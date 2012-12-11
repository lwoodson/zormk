require 'obj_mud'

something_loaded = false
begin
  Dir.entries(File.join(File.dirname(__FILE__), '/zormk/active_record')).grep(/\.rb$/).each do |src|
    name, ext = src.split('.')
    require "zormk/active_record/#{name}"
  end
  require "zormk/commands"

  ObjMud.configure do |config|
    config.location_initializer = lambda {|loc| Zormk::ActiveRecord::Initializer.init_location(loc)}
    config.renderer = Zormk::ActiveRecord::Renderer.new
  end

  module ActiveRecord
    class Base
      def self.zormk
        ObjMud.start(self)
      end
    end
  end
  something_loaded = true
rescue NameError
end

if not something_loaded
  STDERR.write("WARNING:  Did not successfully load for any known ORMs.")
end

require 'obj_mud/controller/commands'

module Zormk
  module Commands
    class KeyCommand < ObjMud::Controller::Commands::Base
      @key_info = []

      class << self
        attr_reader :key_info
      end

      def self.for_command_inputs
        [:key, :legend]
      end

      def initialize
        @title = "LEGEND"
      end

      def perform(*tokens)
        controller.display_output "\n#{@title}\n#{hr}\n#{rendered_key_info}"
      end

      private
      def rendered_key_info
        KeyCommand.key_info.join("\n")
      end

      def hr
        "=" * width
      end

      def width
        width = @title.size
        KeyCommand.key_info.each{|key_ele| width = key_ele.size > width ? key_ele.size : width}
        width
      end

      ObjMud::Controller::Commands.register(self)
    end
  end
end

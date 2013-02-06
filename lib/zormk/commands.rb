# encoding: utf-8
require 'obj_mud/controller/commands'
require 'unicrowed'

module Zormk
  module Commands
    class KeyCommand < ObjMud::Controller::Commands::Base
      class << self
        attr_reader :key_info
      end

      def self.for_command_inputs
        [:key, :legend]
      end

      def perform(*tokens)
        preamble = <<-EOT
  ◃── Superclass
  ◃-- Mixin
    - Table column
       EOT
        controller.display_output Unicrowed.legend_with(preamble)
      end

      ObjMud::Controller::Commands.register(self)
    end
  end
end

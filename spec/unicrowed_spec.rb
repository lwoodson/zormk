# encoding: utf-8
require 'spec_helper'
require 'unicrowed'

describe Unicrowed do
  it 'makes a legend with a preamble' do
  expected = <<-END
LEGEND
─────────────────────────────────────────
Extra stuff
  ○─● One-to-one (unidirectional to other)
  ●─○ One-to-one (unidirectional to this)
  ●─● One to one (bidirectional)
  ○─∈ One to many (unidirectional)
  ●─∈ One to many (bidirectional)
  ∋─○ Many to one (unidirectional)
  ∋─● Many to one (bidirectional)
  ∋─∈ Many to many (bidirectional)
  END

  preamble = <<-EOT
Extra stuff
  EOT
  Unicrowed.legend_with(preamble).should == expected
  end
end

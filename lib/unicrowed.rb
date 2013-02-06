# encoding: utf-8
class Unicrowed
  def self.legend_with extra
    <<-END
LEGEND
─────────────────────────────────────────
#{extra.chomp}
  ○─● One-to-one (unidirectional to other)
  ●─○ One-to-one (unidirectional to this)
  ●─● One to one (bidirectional)
  ○─∈ One to many (unidirectional)
  ●─∈ One to many (bidirectional)
  ∋─○ Many to one (unidirectional)
  ∋─● Many to one (bidirectional)
  ∋─∈ Many to many (bidirectional)
  END
  end
end

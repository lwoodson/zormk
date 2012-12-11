module Zormk
  module Lambdas
    def alphabetical_by_name
      lambda {|a,b| a.name <=> b.name}
    end

    def to_name
      lambda {|ele| ele.name}
    end
  end
end

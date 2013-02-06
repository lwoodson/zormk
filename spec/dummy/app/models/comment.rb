class Comment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :post
  has_one :visitor
end

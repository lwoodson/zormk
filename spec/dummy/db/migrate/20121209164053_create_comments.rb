class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.string :commentator
      t.integer :post_id
      t.timestamps
    end
  end
end

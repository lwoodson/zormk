class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag_name
      t.timestamps
    end

    create_table :posts_tags do |t|
      t.integer :post_id
      t.integer :tag_id
    end
  end
end

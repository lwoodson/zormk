class CreateVisitor < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end

class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :roundname
      t.integer :user_id
      t.integer :deck_id
      t.timestamps
    end
  end
end

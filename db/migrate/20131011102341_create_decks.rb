class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :deckname
      t.timestamps
    end
  end
end

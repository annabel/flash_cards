class Deck < ActiveRecord::Base
  has_many :cards, :dependent => :destroy
  has_many :rounds, :dependent => :destroy
  validates :deckname, presence: true
  # validates :deckname, length: { maximum: 20 }
  validates_uniqueness_of :deckname
end

# <% if @deck && @deck.deckname != ''; %>disabled="disabled" <% end %>/>

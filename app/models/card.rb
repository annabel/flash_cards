class Card < ActiveRecord::Base
  belongs_to :deck
  validates :question, presence: true
  validates :answer, presence: true
  validates_uniqueness_of :question, scope: :deck_id
end

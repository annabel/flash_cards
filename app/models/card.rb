class Card < ActiveRecord::Base
  belongs_to :deck
  validates_presence_of :question
  validates_presence_of :answer
end

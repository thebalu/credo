class Schedule < ApplicationRecord
  belongs_to :card
  belongs_to :student

  enum queue: [:unseen, :learn, :review] # Don't change order, only add to end

  validates :reps, presence: :true, numericality: [greater_than_or_equal_to: 0]
  validates :interval, presence: :true, numericality: [greater_than_or_equal_to: 0]

  def deck
    card.deck
  end

  def konfig
    arr=card.deck.konfigs.where(student:student)
    raise "Only 1 konfig should belong to a Deck+Student pair" if arr.size>1
    arr.first
  end

end

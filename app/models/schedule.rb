class Schedule < ApplicationRecord

  # Associations
  # #
  belongs_to :card
  belongs_to :student

  enum queue: [:unseen, :learn, :review] # Don't change order, only add to end

  # Validations
  # #
  validates :reps, presence: :true, numericality: [greater_than_or_equal_to: 0]
  validates :interval, presence: :true, numericality: [greater_than_or_equal_to: 0]

  before_create :before_create_actions

  def before_create_actions


  end

  # Simple definitions
  # #
  def deck
    card.deck
  end

  def konfig
    arr=card.deck.konfigs.where(student:student)
    raise "Only 1 konfig should belong to a Deck+Student pair" if arr.size>1
    arr.first
  end

  def grad_steps
    konfig[:grad_steps].split.map(&:to_i)
  end



end

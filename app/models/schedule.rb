class Schedule < ApplicationRecord

  # Associations
  # #
  belongs_to :card
  belongs_to :student

  enum queue: [:unseen, :learn, :review] # Don't change order, only add to end
  # attr_accessor :due, :ef,

  # Validations
  # #
  validates :reps, presence: :true, numericality: [greater_than_or_equal_to: 0]
  validates :interval, presence: :true, numericality: [greater_than_or_equal_to: 0]


  # Simple definitions
  # #
  def deck
    card.deck
  end

  def konfig
    arr = card.deck.konfigs.where(student: student)
    raise "Only 1 konfig should belong to a Deck+Student pair" if arr.size > 1
    arr.first
  end

  def grad_steps
    konfig[:grad_steps].split.map(&:to_i)
  end

  # The big stuff
  # #

  # Called when any card gets answered. Calls the correct answer_*_card method after preparations
  def answer_card(grade)
    self.reps += 1
    if queue == :unseen
      # Place unseen cards into learn queue and do the necessary setup
      self.queue = :learn
      self.grad_steps = konfig[:starting_step]
    end

    if queue == :learn
      answer_learn_card(grade)
    elsif queue == :review
      answer_review_card(grade)
    else
      raise "Unknown queue #{queue}"
    end
  end

  def answer_learn_card(grade)
    # code here
  end

  def answer_review_card(grade)
    # code here
  end
end

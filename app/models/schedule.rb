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

  # Cards in learning phase have 3 options: { 0: again, 1: ok, 2: easy}
  def answer_learn_card(grade)
    if grade == 3 # Instantly graduate
      reschedule_as_review(true)
    elsif grade == 2 && learning_step >= grad_steps.count # All learning steps complete, graduate
      reschedule_as_review(false)
    else
    # No graduation yet
      if grade == 2 # 1 step closer to grad
        self.learning_step += 1
      else # Fail, back to step 1
        # possibly adjust interval if card is lapsed
        self.learning_step = 1
      end
      # todo reschedule for today
      delay = (grad_steps[learning_step-1]*60)*Random.rand(1.00,1.25)
      self.due= Time.now.to_i + delay
    end
    # code here
  end

  def reschedule_as_review(early)
    # code here
  end

  def answer_review_card(grade)
    # code here
  end
end

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
    if queue == "unseen"
      # Place unseen cards into learn queue and do the necessary setup
      self.queue = :learn
      self.learning_step = konfig[:starting_step]
    end

    if queue == "learn"
      answer_learn_card(grade)
    elsif queue == "review"
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
      elsif grade == 1 # Fail, back to step 1
        # possibly adjust interval if card is lapsed
        self.learning_step = 1
      else
        raise "Learning cards must be answered on a scale of 1-3"
      end
      delay = (grad_steps[learning_step - 1] * 60) #*(Random.rand(0.25)+1) Add this fuzz later
      self.due = Time.now.to_i + delay.round
      delay.round
    end

  end

  def reschedule_as_review(early)
    self.learning_step = nil
    if lapsed
      # todo Set interval
      puts "lapsed card"
    else
      # Reschedule a new card that's graduated for the first time.
      self.interval = early ? 4 : 1 # Hardcoded for now
    end
    self.queue = :review
    self.due = (Time.now + interval.day).to_i
  end

  def answer_review_card(grade)
    if grade == 1
      reschedule_lapse
    else
      reschedule_rev(grade)
    end

  end

  def reschedule_rev(grade)
    # {2: hard, 3: ok, 4: easy}
    # update interval, ef, due
    # todo add bonus for delayed recall
    old_interval = interval
    self.interval = [1, (old_interval * ef).round].max
    self.ef = [1.3, ef + [-0.15, 0.00, 0.15][grade - 2]].max
    self.due = (Time.now + interval.day).to_i
  end

  def reschedule_lapse
    # code here
  end
end

# a=Schedule.create(card:Card.take, student:Student.take)
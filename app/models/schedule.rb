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
  validate :same_klass_for_card_and_student

  def same_klass_for_card_and_student
    errors.add(:klass, "must be the same for card and student") unless card.deck.klass == student.klass
  end

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
    self.due - Time.now.to_i
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
      self.lapsed = false
      self.interval = 1
    else
      # Reschedule a new card that's graduated for the first time.
      self.interval = early ? 4 : 1 # Hardcoded for now
    end
    self.queue = "review"
    self.due = (Time.now + interval.day).to_i
  end

  def answer_review_card(grade)
    if grade == 1
      reschedule_lapse
    else
      reschedule_rev(grade)
    end
  end

  def reschedule_rev(grade) # {2: hard, 3: ok, 4: easy}
    update_rev_interval(grade)
    self.ef = [1.3, ef + [-0.15, 0.00, 0.15][grade - 2]].max
    self.due = (Time.now + interval.day).to_i
  end

  def update_rev_interval(grade)
    # Always increase interval by at least a day. This is done to avoid issues with intervals of 1 and 2, with e.g. an EF < 1.5
    late = [(Time.now.to_i - due.to_i) / 86400, 0].max # how many days late the card was (rounded down)
    case grade
      when 2
        self.interval = [((interval + late / 4.0) * 1.2).round, interval + 1].max
      when 3
        self.interval = [((interval + late / 2.0) * ef).round, interval + 1].max
      when 4
        # possibly add easy bonus
        self.interval = [((interval + late) * ef).round, interval + 1].max
      else
        raise "unknown grade"
    end
  end

  def reschedule_lapse
    # update interval, ef, place in learning queue, set lapse, set due
    self.interval = 1
    self.ef = [1.3, ef - 0.2].max
    self.queue = "learn"
    self.lapsed = true

    self.learning_step = konfig[:starting_step] # possibly add a different relearning starting step
    self.due = (Time.now + grad_steps[learning_step - 1].minutes)
  end
end

# a=Schedule.create(card:Card.take, student:Student.take)
# TODO Testing model, writing tests, adding save to persist to db
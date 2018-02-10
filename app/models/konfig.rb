class Konfig < ApplicationRecord
  belongs_to :deck
  belongs_to :student

  validates :starting_step, numericality: [greater_than_or_equal_to: 0]

  validate :same_klass_for_deck_and_student

  def same_klass_for_deck_and_student

    errors.add(:klass, "must be the same for deck and student") unless deck.klass == student.klass
  end

  before_create do
    self.lapse_starting_step ||= starting_step
    self.day_cutoff ||= Time.now.end_of_day.to_i

  end

  before_save do
    self.new_card_frequency = (unseen_count + review_count) / unseen_count if unseen_count > 0
    self.new_card_frequency = [new_card_frequency, 2].max if review_count > 0
  end


  # Tasks to do on a new day
  def reset_day
    self.day_cutoff = Time.now.end_of_day.to_i
    self.reps = 0
    recalculate_counts
    self.save
  end

  def recalculate_counts
    self.unseen_count = set_unseen_count
    self.learn_count = set_learn_count
    self.review_count = schedules.due_review.count
  end

  def set_unseen_count
    total = schedules.unseen.count
    [total, new_limit].min
  end

  def set_learn_count
    steps = grad_steps.split.count
    schedules.learn.map {|s| steps - s.learning_step + 1}.sum
  end

  def counts
    reset_day if Time.now.to_i > day_cutoff
    {unseen: unseen_count, learn: learn_count, review: review_count}
  end

  # A konfig belongs to Deck+Student, so this model will be used to get the next due card and
  # for various counts.

  def schedules
    Schedule.of_deck(deck).where(student: student)
  end

  def get_learn_card # Returns first due learn card, or nil
    s = schedules.learn.first

    if s&.show_now?
      # self.learn_count -= 1
      s
    else
      nil
    end
  end

  def get_unseen_card # Returns an unseen card, or nil if there are none
    return nil if self.unseen_count <= 0
    s = schedules.unseen.order(:created_at).limit(self.unseen_count).first
    # self.unseen_count -= 1 if s
    return s
  end

  def get_review_card # Returns first review card that's due today, or nil
    s = schedules.review.first
    if s&.show_now?
      # self.review_count -= 1
      s
    else
      nil
    end
  end

  def get_future_learn_card # If there are any learn cards left, returns the first
    s = schedules.learn.first
    # self.learn_count -= 1 if s
    return s
  end

  def get_card # Returns the schedule information of the next card

    reset_day if Time.now.to_i > day_cutoff
    # self.reps+=1
    # dueLearn > Unseen/Review > futureLearn > Unseen
    c = get_learn_card
    return c if c

    if time_for_unseen
      c = get_unseen_card
      return c if c
    end

    c = get_review_card
    return c if c

    c = get_future_learn_card
    return c if c

    c = get_unseen_card
    return c if c

    return nil
  end


  def time_for_unseen
    return false if schedules.unseen.count == 0
    # return false if new_spread == 'NEW_CARDS_LAST'
    # return true if new_spread == 'NEW_CARDS_FIRST'
    return reps > 0 && reps % new_card_frequency == 0
  end
end

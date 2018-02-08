class Konfig < ApplicationRecord
  belongs_to :deck
  belongs_to :student

  validates :starting_step, numericality: [greater_than: 0]

  validate :same_klass_for_deck_and_student
  def same_klass_for_deck_and_student
    errors.add(:klass, "must be the same for deck and student") unless deck.klass == student.klass
  end

  before_save do
    self.lapse_starting_step ||=starting_step
  end

  # A konfig belongs to Deck+Student, so this model will be used to get the next due card and
  # for various counts.

  def schedules
    Schedule.of_deck(deck).where(student:student)
  end

  def get_learn_card # Returns first due learn card, or nil
    s=schedules.learn.first
    return (if s&.show_now? then s else nil end)
  end

  def get_unseen_card # Returns an unseen card, or nil if there are none
    # todo add limit
    s=schedules.unseen.order(:created_at).first
    return s
  end

  def get_review_card # Returns first review card that's due today, or nil
    s=schedules.review.first
    return (if s&.show_now? then s else nil end)
  end

  def get_future_learn_card # If there are any learn cards left, returns the first
    s=schedules.learn.first
    return s
  end

  def get_card # Returns the schedule information of the next card
    # dueLearn > Unseen/Review > futureLearn > Unseen
    c=get_learn_card
    return c if c

    if time_for_unseen
      c=get_unseen_card
      return c if c
    end

    c=get_review_card
    return c if c

    c=get_future_learn_card
    return c if c

    c=get_unseen_card
    return c if c

    return nil
  end

  def time_for_unseen
    return false if schedules.unseen.count==0
    # return false if new_spread == 'NEW_CARDS_LAST'
    # return true if new_spread == 'NEW_CARDS_FIRST'
    return false # TODO IMPLEMENT THIS
  end
end

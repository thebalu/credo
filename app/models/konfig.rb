class Konfig < ApplicationRecord
  belongs_to :deck
  belongs_to :student

  validates :starting_step, numericality: [greater_than: 0]

  validate :same_klass_for_deck_and_student
  def same_klass_for_deck_and_student
    errors.add(:klass, "must be the same for deck and student") unless deck.klass == student.klass
  end
end

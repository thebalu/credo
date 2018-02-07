class Card < ApplicationRecord
  belongs_to :deck
  has_many :schedules, dependent: :destroy

  validates :front, presence: :true
  validates :back, presence: :true

  def students
    deck.students
  end

  after_create do # if this fails, the original gets rolled back too
    students.each do |student|
      Schedule.find_or_create_by!(card:self, student:student)
    end
  end
  after_update do # if this fails, the original gets rolled back too
    raise "What should we do after update??"
  end
end

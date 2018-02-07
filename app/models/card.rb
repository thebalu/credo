class Card < ApplicationRecord
  belongs_to :deck
  has_many :schedules, dependent: :destroy

  validates :front, presence: :true
  validates :back, presence: :true

  def students
    deck.students
  end

  after_save do # if this fails, the original gets rolled back too
    students.each do |student|
      Schedule.create!(card:self, student:student)
    end
  end
end

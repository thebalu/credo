class Card < ApplicationRecord
  belongs_to :deck
  has_many :schedules, dependent: :destroy

  validates :front, presence: :true
  validates :back, presence: :true

end

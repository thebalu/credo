class Card < ApplicationRecord
  belongs_to :deck
  has_many :schedules, dependent: :destroy
end

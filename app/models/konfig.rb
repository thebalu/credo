class Konfig < ApplicationRecord
  belongs_to :deck
  belongs_to :student

  validates :starting_step, numericality: [greater_than: 0]
end

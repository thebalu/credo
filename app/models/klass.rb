class Klass < ApplicationRecord
  has_many :decks
  has_many :students

  validates :name, presence: :true
end

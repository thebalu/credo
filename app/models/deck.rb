class Deck < ApplicationRecord
  belongs_to :klass
  has_many :cards, dependent: :destroy
  has_many :konfigs, dependent: :destroy

  validates :name, presence: :true
end

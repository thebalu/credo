class Student < ApplicationRecord
  belongs_to :klass
  has_many :schedules, dependent: :destroy
  has_many :konfigs, dependent: :destroy

  validates :name, presence: :true

  def decks
    klass.decks
  end

  def cards
   Card.where(deck:decks)
  end

  after_create :init_schedules

  def init_schedules
    cards.each do |card|
      Schedule.find_or_create_by!(card:card, student:self)
    end
  end
end

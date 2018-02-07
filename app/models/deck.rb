class Deck < ApplicationRecord
  belongs_to :klass
  has_many :cards, dependent: :destroy
  has_many :konfigs, dependent: :destroy

  validates :name, presence: :true

  def students
    klass.students
  end

  after_create do # Create a default konfig
    students.each do |student|
      Konfig.create!(student:student, deck:self)
    end
  end
end

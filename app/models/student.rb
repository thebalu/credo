class Student < ApplicationRecord
  belongs_to :klass
  has_many :schedules, dependent: :destroy
  has_many :konfigs, dependent: :destroy
end

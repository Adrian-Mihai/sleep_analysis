require_relative '../validators/sleep_duration_validator'
require_relative '../validators/date_validator'
require_relative '../validators/unique_date_validator'

class SleepRecord < ApplicationRecord
  validates :start, :end, :quality, :snore, :movements_in_bed, presence: true
  validates :start, :end, unique_date: true
  validates :quality, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :snore, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :time_in_bed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :movements_in_bed, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates_with SleepDurationValidator
  validates_with DateValidator

  belongs_to :user
end

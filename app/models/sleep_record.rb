require_relative '../validators/sleep_duration_validator'

class SleepRecord < ApplicationRecord
  validates :night, :went_to_bed, :woke_up, :time_in_bed,
            :movements_per_hour, :snore_time, :sleep_quality, presence: true
  validates :night, uniqueness: true
  validates :went_to_bed, numericality: { greater_than_or_equal_to: 0 }
  validates :woke_up, numericality: { greater_than_or_equal_to: 0 }
  validates :time_in_bed, numericality: { greater_than_or_equal_to: 0 }
  validates :movements_per_hour, numericality: { greater_than_or_equal_to: 0 }
  validates :snore_time, numericality: { greater_than_or_equal_to: 0 }
  validates :sleep_quality, numericality: { only_integer: true,
                                            greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: 100 }

  validates_with SleepDurationValidator

  belongs_to :user
end

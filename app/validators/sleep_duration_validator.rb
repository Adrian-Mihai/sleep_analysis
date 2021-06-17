class SleepDurationValidator < ActiveModel::Validator
  MINIMUM_SLEEP_HOURS = 4
  MAXIMUM_SLEEP_HOURS = 20

  def validate(record)
    return if record.time_in_bed.nil?

    hours = Time.at(record.time_in_bed).utc.strftime('%H').to_i

    min_error_message = "At least #{MINIMUM_SLEEP_HOURS} hours are required"
    max_error_message = "Maximum of #{MAXIMUM_SLEEP_HOURS} sleep hours exceeded"

    record.errors.add :time_in_bed, min_error_message if hours <= MINIMUM_SLEEP_HOURS
    record.errors.add :time_in_bed, max_error_message if hours >= MAXIMUM_SLEEP_HOURS
  end
end

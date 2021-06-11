class SleepDurationValidator < ActiveModel::Validator
  MINIMUM_SLEEP_HOURS = 4

  def validate(record)
    return if record.time_in_bed.nil?

    hours = Time.at(record.time_in_bed).utc.strftime('%H').to_i
    return if hours >= MINIMUM_SLEEP_HOURS

    record.errors.add :time_in_bed, "At least #{MINIMUM_SLEEP_HOURS} hours are required"
  end
end

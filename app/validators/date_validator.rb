class DateValidator < ActiveModel::Validator
  def validate(record)
    return if record.went_to_bed.nil? || record.woke_up.nil?
    return if ((record.woke_up - record.went_to_bed) / 1.hour).round < 24

    record.errors.add :base, 'Difference between went to bed and woke up must not be greater than 24 hours'
  end
end

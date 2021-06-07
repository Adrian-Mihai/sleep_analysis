class DateValidator < ActiveModel::Validator
  def validate(record)
    return if record.start.nil? || record.end.nil?
    return if record.start <= record.end

    record.errors.add :base, 'Starting date must be smaller than end date'
  end
end

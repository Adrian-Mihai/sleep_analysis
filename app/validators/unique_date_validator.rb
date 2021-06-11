class UniqueDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?
    return unless SleepRecord.exists?("#{attribute}": value.all_day)

    record.errors.add attribute, (options[:message] || 'is not an unique date')
  end
end

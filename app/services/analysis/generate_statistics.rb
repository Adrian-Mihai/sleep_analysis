module Analysis
  class GenerateStatistics < Analysis::Base
    def initialize(user_id:, x_axis:, y_axis:, start_date:, end_date:)
      super(user_id: user_id, start_date: start_date, end_date: end_date)
      @x_axis = x_axis
      @y_axis = y_axis
    end

    private

    def call
      validate_axis
      return unless valid?

      @data = sleep_records.order(@x_axis).pluck(@x_axis, @y_axis).to_h
    end

    def validate_axis
      return if SleepRecord.allowed_axis.include?(@x_axis) && SleepRecord.allowed_axis.include?(@y_axis)

      @errors << "Invalid value for axis. Allowed values: #{SleepRecord.allowed_axis.join(', ')}"
    end
  end
end

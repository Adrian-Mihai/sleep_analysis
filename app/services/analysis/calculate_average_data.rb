module Analysis
  class CalculateAverageData < Analysis::Base
    def initialize(user_id:, start_date:, end_date:, day:)
      super(user_id: user_id, start_date: start_date, end_date: end_date)
      @day = Integer(day) if day.present?
    rescue ArgumentError
      @errors << 'Invalid value for day. Accepted values: [0..6]'
    end

    private

    def call
      return unless valid?

      if @day.present?
        validate_day
        return unless valid?
      end

      @count, @went_to_bed, @woke_up, @sleep_quality, @time_in_bed, @movements_per_hour, @snore_time = extract_data
      @data = map_calculated_values
    end

    def interval
      @day.present? ? dates_by_weekday[@day] : super
    end

    def extract_data
      sleep_records.pluck('COUNT(id)',
                          'SUM(went_to_bed)',
                          'SUM(woke_up)',
                          'SUM(sleep_quality)',
                          'SUM(time_in_bed)',
                          'SUM(movements_per_hour)',
                          'SUM(snore_time)').flatten
    end

    def map_calculated_values
      {
        went_to_bed: average_went_to_bed_time,
        woke_up: average_woke_up_time,
        sleep_quality: average_sleep_quality,
        time_in_bed: average_time_in_bed,
        movements_per_hour: average_movements_per_hour,
        snore_time: average_snore_time,
        recorded_nights: @count
      }
    end

    def average_went_to_bed_time
      @went_to_bed / @count.to_f
    end

    def average_woke_up_time
      @woke_up / @count
    end

    def average_sleep_quality
      @sleep_quality / @count.to_f
    end

    def average_time_in_bed
      @time_in_bed / @count.to_f
    end

    def average_movements_per_hour
      @movements_per_hour / @count.to_f
    end

    def average_snore_time
      @snore_time / @count.to_f
    end

    def dates_by_weekday
      (@start_date..@end_date).group_by(&:wday)
    end

    def validate_day
      return if @day >= 0 && @day <= 6

      @errors << 'Invalid value for day. Accepted values: [0..6]'
    end
  end
end

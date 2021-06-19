module Analysis
  class CalculateAverageData
    attr_reader :errors, :data

    def initialize(user_id:, start_date:, end_date:, day:)
      @user_id = user_id
      @start_date = start_date
      @end_date = end_date
      @day = day
      @errors = []
    end

    def perform
      valid_day? if @day.present?
      return self unless valid?

      @start_date = @start_date.present? ? Date.parse(@start_date) : first_recorded_night
      @end_date = @end_date.present? ? Date.parse(@end_date) : last_recorded_night

      if @start_date.nil? || @end_date.nil?
        @errors << 'No sleep records'
        return self
      end

      @count, @went_to_bed, @woke_up, @sleep_quality, @time_in_bed, @movements_per_hour, @snore_time = extract_data
      @data = map_calculated_values
      self
    rescue ActiveRecord::RecordNotFound => e
      @errors << "#{e.model} not found"
      self
    rescue Date::Error => e
      @errors << e.message
      self
    end

    def valid?
      @errors.empty?
    end

    private

    def user
      return @user if defined? @user

      @user = User.find(@user_id)
    end

    def sleep_records
      return @sleep_records if defined? @sleep_records

      @sleep_records = user.sleep_records.where(night: @start_date..@end_date)
      @sleep_records = @sleep_records.where(night: dates_by_weekday[@day]) if @day.present?
      @sleep_records
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

    def first_recorded_night
      user.sleep_records.order(:night).first&.night
    end

    def last_recorded_night
      user.sleep_records.order(:night).last&.night
    end

    def valid_day?
      @day = Integer(@day)
      return if @day >= 0 && @day <= 6

      @errors << 'Invalid value for day. Accepted values: [0..6]'
    rescue ArgumentError
      @errors << 'Invalid value for day. Accepted values: [0..6]'
    end
  end
end

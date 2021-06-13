module Analysis
  class CalculateAverageData
    attr_reader :errors, :data

    def initialize(user_id:, start_date:, end_date:)
      @user_id = user_id
      @start_date = start_date
      @end_date = end_date
      @errors = []
    end

    def perform
      @start_date = DateTime.parse(@start_date) if @start_date.present?
      @end_date = DateTime.parse(@end_date) if @end_date.present?
      @count, @quality, @time_in_bed, @movements_in_bed, @snore = extract_data
      @went_to_bed = sleep_records.pluck(:went_to_bed).map(&:seconds_since_midnight).sum
      @woke_up = sleep_records.pluck(:woke_up).map(&:seconds_since_midnight).sum

      @data = map_calculated_values
      self
    rescue ActiveRecord::RecordNotFound
      @errors << 'Record not found'
      self
    rescue Date::Error
      @errors << 'Invalid date'
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

      @sleep_records = if @start_date.present? && @end_date.present?
                         user.sleep_records.where(went_to_bed: @start_date..@end_date)
                       else
                         user.sleep_records
                       end
    end

    def extract_data
      sleep_records.pluck('COUNT(id)',
                          'SUM(quality)',
                          'SUM(time_in_bed)',
                          'SUM(movements_in_bed)',
                          'SUM(snore)').flatten
    end

    def map_calculated_values
      {
        went_to_bed: average_went_to_bed_time,
        woke_up: average_woke_up_time,
        sleep_quality: average_sleep_quality,
        time_in_bed: average_time_in_bed,
        movements_in_bed: average_movements_in_bed,
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
      @quality / @count.to_f
    end

    def average_time_in_bed
      @time_in_bed / @count.to_f
    end

    def average_movements_in_bed
      @movements_in_bed / @count.to_f
    end

    def average_snore_time
      @snore / @count.to_f
    end
  end
end

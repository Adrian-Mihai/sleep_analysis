module Analysis
  class Base < ::Base
    include UserHelpers

    attr_reader :data

    def initialize(user_id:, start_date:, end_date:)
      super()
      @user = find_user(user_id)
      @start_date = start_date.present? ? Date.parse(start_date) : first_recorded_night
      @end_date = end_date.present? ? Date.parse(end_date) : last_recorded_night
    rescue ActiveRecord::RecordNotFound => e
      @errors << "#{e.model} not found"
    rescue Date::Error => e
      @errors << e.message
    end

    def perform
      return self unless valid?

      validate_date_interval
      return self unless valid?

      call
      self
    end

    protected

    def call
      raise NotImplementedError, 'implement in subclass'
    end

    def sleep_records
      @sleep_records ||= @user.sleep_records.where(night: @start_date..@end_date)
    end

    def first_recorded_night
      @first_recorded_night ||= @user.sleep_records.first&.night
    end

    def last_recorded_night
      @last_recorded_night ||= @user.sleep_records.last&.night
    end

    def validate_date_interval
      return @errors << 'No nights recorded' if @start_date.nil? || @end_date.nil?
      return if valid_interval?

      @errors << "start date and end date must be in [#{first_recorded_night}..#{last_recorded_night}]"
    end

    def valid_interval?
      (first_recorded_night..last_recorded_night).include?(@start_date..@end_date)
    end
  end
end

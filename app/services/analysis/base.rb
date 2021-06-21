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

      check_recorded_nights
      return self unless valid?

      call
      self
    end

    protected

    def call
      raise NotImplementedError, 'implement in subclass'
    end

    def sleep_records
      @sleep_records ||= @user.sleep_records.where(night: interval)
    end

    def interval
      @start_date..@end_date
    end

    def first_recorded_night
      @first_recorded_night ||= @user.sleep_records.first&.night
    end

    def last_recorded_night
      @last_recorded_night ||= @user.sleep_records.last&.night
    end

    def check_recorded_nights
      return @errors << 'No recorded nights' if first_recorded_night.nil? || last_recorded_night.nil?
      return if sleep_records.exists?

      @errors << 'No recorded nights'
    end
  end
end

module Analysis
  class GenerateStatistics < Analysis::Base
    def initialize(user_id:, x_axis:, y_axis:, start_date:, end_date:)
      super()
      @user_id = user_id
      @x_axis = x_axis
      @y_axis = y_axis
      @start_date = start_date
      @end_date = end_date
    end

    def perform
      self
    end
  end
end

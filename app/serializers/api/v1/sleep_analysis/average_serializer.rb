module Api
  module V1
    module SleepAnalysis
      class AverageSerializer < ActiveModel::Serializer
        attributes :went_to_bed, :woke_up, :sleep_quality,
                   :time_in_bed, :movements_in_bed, :snore_time, :recorded_nights

        def went_to_bed
          Time.at(object.went_to_bed).utc.strftime('%H:%M:%S')
        end

        def woke_up
          Time.at(object.woke_up).utc.strftime('%H:%M:%S')
        end

        def sleep_quality
          object.sleep_quality.round
        end

        def time_in_bed
          Time.at(object.time_in_bed).utc.strftime('%H:%M:%S')
        end

        def movements_in_bed
          object.movements_in_bed.round
        end

        def snore_time
          Time.at(object.snore_time).utc.strftime('%H:%M:%S')
        end
      end
    end
  end
end

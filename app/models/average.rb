class Average < ActiveModelSerializers::Model
  attributes :went_to_bed, :woke_up, :sleep_quality, :time_in_bed, :movements_in_bed, :snore_time, :recorded_nights
end

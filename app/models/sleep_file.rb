class SleepFile < ApplicationRecord
  enum status: { uploaded: 0, processing: 1, processed: 2 }

  UPLOADED = 0
  PROCESSING = 1
  PROCESSED = 2

  CONTENT_TYPE = 'text/csv'.freeze

  has_one_attached :file
  belongs_to :user
end

require 'csv'

class ParseSleepFile
  attr_reader :errors

  def initialize(user_id:, sleep_file_id:)
    @user_id = user_id
    @sleep_file_id = sleep_file_id
    @errors = []
  end

  def perform
    validate_sleep_file_status
    validate_attached_file
    return self unless valid?

    sleep_file.update!(status: SleepFile::PROCESSING)
    parse_attached_file
    self
  rescue ActiveRecord::RecordNotFound
    @errors << 'Record not found'
    self
  rescue ActiveRecord::RecordInvalid
    @errors << 'Record is invalid'
    self
  end

  def valid?
    @errors.empty?
  end

  private

  def parse_attached_file
    rows = read_csv_file
    rows[1..].each do |row|
      next unless valid_row?(row)

      SleepRecord.create!(extract_fields(row).merge(user: user))
    rescue ActiveRecord::RecordInvalid
      next
    end
  end

  def valid_row?(row)
    return false if row[0].nil? || row[1].nil? || row[2].nil? || row[9].nil? || row[10].nil? || row[14].nil?

    true
  end

  def validate_sleep_file_status
    return if sleep_file.uploaded?

    @errors << 'File invalid status'
  end

  def validate_attached_file
    return if sleep_file.file.attached?

    @errors << 'No file attached'
  end

  def read_csv_file
    CSV.parse(sleep_file.file.download, col_sep: ';')
  end

  def extract_fields(row)
    {
      start: row[0],
      end: row[1],
      quality: row[2].to_i,
      movements_in_bed: row[9].to_f.round,
      time_in_bed: row[10].to_f.round,
      snore: row[14].to_f.round
    }
  end

  def user
    return @user if defined? @user

    @user = User.find(@user_id)
  end

  def sleep_file
    return @sleep_file if defined? @sleep_file

    @sleep_file = user.sleep_files.find(@sleep_file_id)
  end
end

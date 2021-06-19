require 'csv'

class ParseSleepFile < Base
  def initialize(user_id:, sleep_file_id:)
    super()
    @user_id = user_id
    @sleep_file_id = sleep_file_id
  end

  def perform
    validate_sleep_file_status
    validate_attached_file
    return self unless valid?

    sleep_file.update!(status: SleepFile::PROCESSING)
    parse_attached_file
    sleep_file.update!(status: SleepFile::PROCESSED)
    self
  rescue ActiveRecord::RecordNotFound => e
    @errors << "#{e.model} not found"
    self
  rescue ActiveRecord::RecordInvalid => e
    @errors += e.record.errors.full_messages
    self
  end

  private

  def parse_attached_file
    rows = read_csv_file
    rows[1..].each do |row|
      next unless valid_row?(row)

      user.sleep_records.create!(extract_fields(row))
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
      night: extract_night(row[0], row[1]),
      went_to_bed: convert_to_seconds(row[0]),
      woke_up: convert_to_seconds(row[1]),
      sleep_quality: row[2].to_i,
      movements_per_hour: row[9].to_f,
      time_in_bed: row[10].to_f,
      snore_time: row[14].to_f
    }
  end

  def extract_night(went_to_bed, woke_up)
    return if went_to_bed.nil? || woke_up.nil?

    went_to_bed_date = Date.parse(went_to_bed)
    woke_up_date = Date.parse(woke_up)
    return nil if went_to_bed_date > woke_up_date
    return nil if (woke_up_date - went_to_bed_date).to_i > 1
    return went_to_bed_date - 1.day if went_to_bed_date == woke_up_date

    went_to_bed_date
  rescue Date::Error
    nil
  end

  def convert_to_seconds(date)
    return if date.nil?

    Time.parse(date).seconds_since_midnight
  rescue TypeError, ArgumentError
    nil
  end

  def sleep_file
    return @sleep_file if defined? @sleep_file

    @sleep_file = user.sleep_files.find(@sleep_file_id)
  end
end

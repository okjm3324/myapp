module ApplicationHelper
  def convert_milliseconds_to_minutes_and_seconds(milliseconds)
    total_seconds = (milliseconds / 1000).floor
    minutes = total_seconds / 60
    seconds = total_seconds % 60

    "#{minutes}分#{seconds}秒"
  end
end

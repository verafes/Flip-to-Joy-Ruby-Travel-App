module ApplicationHelper
  def format_datetime(datetime)
    return "" if datetime.blank?
    datetime.strftime("%B %-d, %Y at %-l%P")
  end
end

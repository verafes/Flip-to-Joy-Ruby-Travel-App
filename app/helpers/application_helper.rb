module ApplicationHelper
  def format_datetime(datetime)
    return "" if datetime.blank?
    datetime.strftime("%B %-d, %Y at %-l%P")
  end

  def flash_class(key)
    case key.to_s.downcase
    when :notice, :success
      "flash-success"
    when :alert, :error
      "flash-danger"
    else
      "flash-info"
    end
  end
end

class Utils
  def Utils.days_til_now(date)
    (Date.today.to_datetime - date).to_i
  end

  def Utils.date_in_no_of_days(date, number)
    return date + number
  end
end
module DateTimeHelper
  def filter_month_date_year(date)
    date.present? ? date.strftime('%m/%d/%Y') : nil
  end
end
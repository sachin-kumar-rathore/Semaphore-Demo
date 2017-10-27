module DateParser

  private

  def convert_date(date_param)
    Date.strptime(date_param, "%m/%d/%Y")
  end

end
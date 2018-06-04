class Common

  def self.calulate_current_financial_year(fy: nil)
    if fy.present?
      fy = Date.parse(fy).year
      fy = DateTime.new(fy, 4, 1, 00, 00, 0)
    else
      fy = DateTime.new(Date.today.year, 4, 1, 00, 00, 0)
    end
    fy.to_date
  end
end

class Common

  def self.calulate_financial_year(fy: nil)
    if fy.present?
      fy = DateTime.new(fy.year) + 3.months
    else
      fy = DateTime.new(Date.today.year) + 3.months
    end
    fy
  end

  def self.generate_string
    string_characters = 8
    charset = Array('A'..'Z') + Array('a'..'z') + Array('1'..'0')
    Array.new(string_characters) { charset.sample }.join
  end

  def self.otp
    rand(0000..9999).to_s.rjust(4, "0")
  end

  def self.send_sms(object)
    requested_url = Rails.configuration.SMS[:URI]
    uri = URI.parse(requested_url)
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.post_form(uri, 'apikey' => Rails.configuration.SMS[:API_KEY], 'message' => object[:message], 'numbers' => object[:mob_num], 'test' => true)
    response = JSON.parse(res.body)
  end

  def self.prepare_finanacial_year(fy)
    fy_arr = []
    while fy.year < Date.today.year
      fy_arr << {fy: fy}
      fy = fy + 1.year
    end
    fy_arr
  end

  def self.short_url_code(actual_url)
    code = Digest::MD5.hexdigest(actual_url+ "onacc app").slice(0..6)
    ShortUrl.create({actual_url: actual_url, url_code: code})
    code
  end

end

class Common

  def self.calulate_current_financial_year(fy: nil)
    if fy.present?
      fy = Date.parse(fy).year
      fy = DateTime.new(fy, 4, 1, 00, 00, 0)
    else
      fy = DateTime.new(Date.today.year, 4, 1, 00, 00, 0)
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
    res = Net::HTTP.post_form(uri, 'apikey' => Rails.configuration.SMS[:API_KEY], 'message' => object.otp_pin, 'numbers' => object.mob_num, 'test' => true)
    response = JSON.parse(res.body)
  end
end

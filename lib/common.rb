class Common

  def self.process_errors(errors)
    errors.map { |error|  error[:message] }
  end

end

class Common

  STATUS = {
    "COMPLETED": "Completed",
    "PENDING": "Pending",
    "FAILED": "Failed"
  }

  def self.process_errors(errors)
    errors.map { |error|  error[:message] }
  end

  def self.true?(obj)
    obj.to_s == "true"
  end

end

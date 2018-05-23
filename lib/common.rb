class Common

  STATUS = {
    "COMPLETED": "Completed",
    "PENDING": "Pending",
    "FAILED": "Failed"
  }
  
  def self.process_errors(errors)
    errors.map { |error|  error[:message] }
  end

end

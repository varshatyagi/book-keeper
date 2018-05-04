class ApiResponse

  HTTP_CODE = {
    "BAD_REQUEST": 400,
    "UNAUTHORIZE": 401,
    "NOT_FOUND": 404
  }
  ERROR_MESSAGE = {
    "UNAUTHORIZE": "You are not authorized to access this resource."
  }
  ACCESS_DENIED = {errors: ERROR_MESSAGE[:UNAUTHORIZE], status: false, response: nil}

  def returnCurrentUser(user: nil)
    return {
      errors: nil,
      status: true,
      response: {user: user}
    }
  end

end

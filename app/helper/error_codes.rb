class ApiResponse

  HTTP_CODE = {
    "BAD_REQUEST": 400,
    "UNAUTHORIZE": 401,
    "NOT_FOUND": 404,
    "NOT_ACCEPTABLE": 406
  }
  ERROR_MESSAGE = {
    "UNAUTHORIZE": "You are not authorized to access this resource.",
    "NOT_ACCEPTABLE": "Authorization key is missing."
  }

  TOKEN_EXPIRATION_TIME = 86400 # In seconds 24 hrs

  ACCESS_DENIED = {errors: ERROR_MESSAGE[:UNAUTHORIZE], status: false, response: nil}
  INVALID_HEADERS = {errors: ERROR_MESSAGE[:NOT_ACCEPTABLE], status: false, response: nil}

  def returnCurrentUser(user: nil)
    return {
      errors: nil,
      status: true,
      response: {user: user}
    }
  end

end

class Helper

  HTTP_CODE = {
    "SUCCESS": 200,
    "BAD_REQUEST": 400,
    "UNAUTHORIZE": 401,
    "NOT_FOUND": 404,
    "NOT_ACCEPTABLE": 406
  }
  ERROR_MESSAGE = {
    "UNAUTHORIZE": "You are not authorized to access this resource.",
    "NOT_ACCEPTABLE": "Authorization key is missing.",
    "MISSING_ENTRIES": "Required entries are missing.",
    "ORG_ID_MISSING": "Organisation Id is missing.",
    "UNIQUE_ORG_NAME": "Organisation name has already been taken"
  }

  STATUS = {
    "COMPLETED": "Completed",
    "PENDING": "Pending",
    "FAILED": "Failed"
  }

  TOKEN_EXPIRATION_TIME = 86400 # In seconds 24 hrs

  ACCESS_DENIED = {errors: ERROR_MESSAGE[:UNAUTHORIZE], status: false, response: nil}
  INVALID_HEADERS = {errors: ERROR_MESSAGE[:NOT_ACCEPTABLE], status: false, response: nil}
  MISSING_ENTRIES = {errors: ERROR_MESSAGE[:MISSING_ENTRIES], status: false, response: nil}
  ORG_ID_MISSING = {errors: ERROR_MESSAGE[:ORG_ID_MISSING], status: false, response: nil}
  UNIQUE_ORG_NAME = {errors: ERROR_MESSAGE[:UNIQUE_ORG_NAME], status: false, response: nil}

  def returnSuccessResponse(obj: nil)
    return {
      errors: nil,
      status: true,
      response: obj
    }
  end

  def returnErrorResponse(errors: nil)
    return {
      errors: errors,
      status: false,
      response: nil
    }
  end

end

__author__ = 'vsitzmann'

class APIException(Exception):
    pass

class InvalidToken(APIException):
    pass

class NoPermission(APIException):
    pass

class NotFound(APIException):
    pass

class BadRequest(APIException):
    pass

class WrongFormat(APIException):
    pass


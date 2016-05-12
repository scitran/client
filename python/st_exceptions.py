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



class DockerException(Exception):
    pass

class MachineSetupError(DockerException):
    pass

class MachineNotInstalled(DockerException):
    pass

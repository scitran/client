__author__ = 'vsitzmann'

class APIException(Exception):
    def __init__(self, *args, **kwargs):
        self.response = kwargs.pop('response', None)
        super(APIException, self).__init__(*args, **kwargs)

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

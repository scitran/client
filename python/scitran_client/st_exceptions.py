__author__ = 'vsitzmann'


class APIException(Exception):
    def __init__(self, message, *args, **kwargs):
        self.response = kwargs.pop('response', None)
        message = '{} for {} {}: {}'.format(
            self.response.status_code,
            self.response.request.method,
            self.response.url,
            message
        )
        super(APIException, self).__init__(message, *args, **kwargs)

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

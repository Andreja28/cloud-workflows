from musicoAPI import MusicoAPI
from toil.common import Toil
from toil.job import Job

class MusicoService(Job.Service):
    def start(self, fileStore):
        return MusicoAPI()

    def check(self):
        return True

    def stop(self, fileStore):
        pass
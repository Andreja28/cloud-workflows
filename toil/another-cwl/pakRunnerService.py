from pakRunner import PakRunner

from toil.common import Toil
from toil.job import Job

class PakRunnerService(Job.Service):
    def start(self, fileStore):
        return PakRunner()

    def check(self):
        return True

    def stop(self, fileStore):
        pass
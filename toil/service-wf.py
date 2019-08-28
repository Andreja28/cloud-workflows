from toil.common import Toil
from toil.job import Job
import requests

class WeatherService(Job.Service):
    def start(self, fileStore):
        return "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22"


    def check(self):
        return True

    def stop(self, filestore):
        pass


def tool(job,weatherApiCredentials):
    res = requests.request("GET",weatherApiCredentials)
    t1 = job.fileStore.getLocalTempFile()
    f = open(t1,'w')
    f.write(res.text)
    f.close()
    job.fileStore.writeGlobalFile(t1)
    return res.text

def func(job, service):
    weatherPromise = job.addService(service)
    return job.addChildJobFn(tool,weatherPromise).rv()

s = WeatherService()
j = Job.wrapJobFn(func,s)

if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./toilWorkflowRun")
    options.logLevel = "INFO"
    options.clean = "never"

    with Toil(options) as toil:
        output = toil.start(j)
    print(output)
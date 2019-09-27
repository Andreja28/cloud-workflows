from pakRunnerService import PakRunnerService

from toil.common import Toil
from toil.job import Job
import requests


def pak(job, pakRunner):

    #create a job
    res = requests.post(pakRunner.createTaskEndpoint(), headers={"Content-Type":"application/json"}, data='{"guid":"4444-1111"}')
    if res.status_code == 200:
        #run job
        res = requests.post(pakRunner.startTaskEndpoint(), headers={"Content-Type":"application/json"}, data='{"guid":"4444-1111", "command":"./proba.sh"}')

        if res.status_code == 200:
            #get results
            res = requests.post(pakRunner.getResultsEndpoint(), headers = {'Content-Type': 'application/json'}, data='{"guid":"4444-1111", "files":["proba.sh","shorttask.log"]}')

            if res.status_code == 200:
                if res.headers.get('Content-Disposition'):
                    f = job.fileStore.getLocalTempFile()

                    with open(f, 'w') as resFile:
                        resFile.write(res.content)

                    fileID = job.fileStore.writeGlobalFile(f)

                    return fileID              

                else:
                    return "No file"
            else:
                return "Cannot get results, status code: "+ res.status_code

        else:
            return "Cannot run task, status code: "+ res.status_code

    else:
        return "Cannot create task, status code: "+ res.status_code


def rootJobFunc(job, service):
    pakService = job.addService(service)
    return job.addChildJobFn(pak, pakService).rv()
   


pakService = PakRunnerService()
rootJob = Job.wrapJobFn(rootJobFunc, pakService)

if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./toilWorkflowRun")
    options.logLevel = "INFO"
    options.clean = "never"

    with Toil(options) as toil:
        output = toil.start(rootJob)
    print(output)

from pakRunnerService import PakRunnerService

from toil.common import Toil
from toil.job import Job
import requests, os, sys


def pak(job, out_dir, pakRunner):

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
                    results = job.fileStore.readGlobalFile(fileID, userPath=os.path.join(out_dir,"results.zip"))


                    return fileID              

                else:
                    return "No file"
            else:
                return "Cannot get results, status code: "+ res.status_code

        else:
            return "Cannot run task, status code: "+ res.status_code

    else:
        return "Cannot create task, status code: "+ res.status_code


def rootJobFunc(job,out_dir, service):
    pakService = job.addService(service)
    return job.addChildJobFn(pak, out_dir, pakService).rv()
   

out_dir = os.path.dirname(os.path.abspath(__file__))


pakService = PakRunnerService()
rootJob = Job.wrapJobFn(rootJobFunc, out_dir, pakService)

if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./"+sys.argv[1])
    options.logLevel = "INFO"
    options.clean = "always"

    with Toil(options) as toil:
        output = toil.start(rootJob)
    print(output)

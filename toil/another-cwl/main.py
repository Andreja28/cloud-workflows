from pakRunnerService import PakRunnerService

from toil.common import Toil
from toil.job import Job
import requests, sys
import os
import subprocess


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
   


def runQC(job, cwl_file, cwlFilename,inputFile,output_dir):
    job.fileStore.logToMaster("runQC")
    inp = job.fileStore.readGlobalFile(inputFile)
    yml = job.fileStore.getLocalTempFile()
    with open(yml, 'w') as ymlWriter:
        ymlWriter.write("infile:\n    class: File\n    path: "+inp)

    ymlID = job.fileStore.writeGlobalFile(yml)


    tempDir = job.fileStore.getLocalTempDir()

    cwl = job.fileStore.readGlobalFile(cwl_file,userPath=os.path.join(tempDir,cwlFilename))
    #yml = job.fileStore.readGlobalFile(yml_file)

    

    subprocess.check_call(['cwltoil',cwl,yml])

    output1_filename = "proba.sh"
    output1_file = job.fileStore.writeGlobalFile(output1_filename)
    job.fileStore.readGlobalFile(output1_file,userPath=os.path.join(output_dir,output1_filename))

    output2_filename = "shorttask.log"
    output2_file = job.fileStore.writeGlobalFile(output2_filename)
    job.fileStore.readGlobalFile(output2_file,userPath=os.path.join(output_dir,output2_filename))

    return [output1_file,output2_file]
    

pakService = PakRunnerService()
rootJob = Job.wrapJobFn(rootJobFunc, pakService)

    
if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./"+sys.argv[1])
    options.logLevel = "INFO"
    options.clean = "always"

    with Toil(options) as toil:
        in_out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cwlFiles")
        print(in_out_dir)


        cwlFilename = "workflow.cwl"
        cwl_file = toil.importFile("file://"+os.path.abspath(os.path.join(in_out_dir,cwlFilename)))

        rootJob.addFollowOnJobFn(runQC, cwl_file, cwlFilename,rootJob.rv(),in_out_dir)

        toil.start(rootJob)
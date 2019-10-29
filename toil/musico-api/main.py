from musicoService import MusicoService
from zipfile import ZipFile

from toil.common import Toil
from toil.job import Job
import requests, os, json, time, sys


def musico(job, unitFilenames, units, musicoAPI):

    data = json.dumps({
        "apiUser": True,
        "calcs": unitFilenames
    })
    job.fileStore.logToMaster(data)
    #create
    res = requests.post(musicoAPI.createCalcs(), headers={"Content-Type":"application/json"}, data=data)
    job.fileStore.logToMaster(res.text)
    
    if (res.status_code== 200):
        resJson = json.loads(res.text)
        if (resJson['success']):
            calcIds = resJson['calcIds']
            #upload
            files = []
            tempDir = job.fileStore.getLocalTempDir()
             
            for unit in units:
                u = job.fileStore.readGlobalFile(unit, userPath=os.path.join(tempDir,unitFilenames[units.index(unit)]))
                
                files.append(open(u,'rb'))
            res = requests.post(musicoAPI.uploadCalcs(), files={"zipFile[]":files[0]})
            #job.fileStore.logToMaster(res.status_code)
            #job.fileStore.logToMaster(res.text)
            if (res.status_code== 200):
                resJson = json.loads(res.text)
                if (resJson['success'] and resJson['upload']=='OK'):
                    data = json.dumps({
                        "apiUser": True,
                        "calcIds": calcIds
                    })
                    res = requests.post(musicoAPI.runCalcs(), headers={"Content-Type":"application/json"}, data=data)
                    #job.fileStore.logToMaster(res.text)
                    flag = True
                    while (flag):
                        time.sleep(1)
                        flag = False
                        for calcId in calcIds:
                            if (flag):
                                break
                            data = json.dumps({
                                "apiUser": True,
                                "calcId": calcId
                            })
                            res = requests.post(musicoAPI.getUnits(), headers={"Content-Type":"application/json"}, data=data)
                            jsonRes = json.loads(res.text)
    
                            for unit in jsonRes['units']:
                                if (unit['endTime']==None):
                                    flag = True
                                    break
                    
                    for calc in calcIds:
                        data = json.dumps({
                            "apiUser": True,
                            "calcId": calcId
                        })
                        res = requests.post(musicoAPI.downloadCalc(), headers={"Content-Type":"application/json"}, data=data)
                        out = job.fileStore.getLocalTempFile()
                        open(out,'wb').write(res.content)
                        #job.fileStore.logToMaster(out)
                        output1_file = job.fileStore.writeGlobalFile(out)
                        return output1_file
                        #job.fileStore.readGlobalFile(output1_file,userPath=os.path.join(out_dir,unitFilenames[calcIds.index(calc)]))


def unzipJob(job, zipID, out_dir):
    job.fileStore.logToMaster(zipID)
    tempDir = job.fileStore.getLocalTempDir()
    zf = ZipFile(job.fileStore.readGlobalFile(zipID),'r')
    zf.extractall(out_dir)
    zf.close()

    
def rootJobFunc(job,unitFilenames, units,out_dir, service):
    musicoServ = job.addService(service)
    musicoJob = Job.wrapJobFn(musico, unitFilenames, units, musicoServ)
    unzip = Job.wrapJobFn(unzipJob, musicoJob.rv(), out_dir)
    job.addChild(musicoJob)
    musicoJob.addChild(unzip)
   

if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./"+sys.argv[1])
    options.logLevel = "INFO"
    options.clean = "always"
    with Toil(options) as toil:
        unitFilenames = ["GC11.zip"]
        units = [toil.importFile("file://"+os.path.abspath(unitFilenames[0]))]

    
        service = MusicoService()
        rootJob = Job.wrapJobFn(rootJobFunc, unitFilenames, units, sys.argv[2], service)
        
        output = toil.start(rootJob)
        print(output)

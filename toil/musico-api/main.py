from musicoService import MusicoService

from toil.common import Toil
from toil.job import Job
import requests, os, json, time


def musico(job, unitFilenames, units,out_dir, musicoAPI):
    filenames = []
    for unit in units:
        filenames.append(unit.split("/")[-1])
    data = json.dumps({
        "apiUser": True,
        "calcs": filenames
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
                u = job.fileStore.readGlobalFile(unit, userPath=os.path.join(tempDir,filenames[units.index(unit)]))
                job.fileStore.logToMaster(u)
                files.append(open(u,'rb'))
            res = requests.post(musicoAPI.uploadCalcs(), files={"zipFile[]":files[0]})
            #job.fileStore.logToMaster(res.status_code)
            job.fileStore.logToMaster(res.text)
            if (res.status_code== 200):
                resJson = json.loads(res.text)
                job.fileStore.logToMaster(res.text)
                if (resJson['success'] and resJson['upload']=='OK'):
                    data = json.dumps({
                        "apiUser": True,
                        "calcIds": calcIds
                    })
                    job.fileStore.logToMaster("RUUUUUUN")
                    job.fileStore.logToMaster(data)
                    res = requests.post(musicoAPI.runCalcs(), headers={"Content-Type":"application/json"}, data=data)
                    job.fileStore.logToMaster(res.text)
                    flag = True
                    while (flag):
                        job.fileStore.logToMaster("Provera")
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
                        job.fileStore.logToMaster(out)
                        output1_file = job.fileStore.writeGlobalFile(out)
                        job.fileStore.readGlobalFile(output1_file,userPath=os.path.join(out_dir,unitFilenames[calcIds.index(calc)]))







    
def rootJobFunc(job,unitFilenames, units,out_dir, service):
    musicoServ = job.addService(service)
    return job.addChildJobFn(musico, unitFilenames, units,out_dir, musicoServ).rv()
   



if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./toilWorkflowRun")
    options.logLevel = "INFO"
    options.clean = "never"
    with Toil(options) as toil:
        out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "results")

        #unitFilenames = ["GC1.zip", "GC2.zip"]
        #units = [toil.importFile("file://"+os.path.abspath(unitFilenames[0])), toil.importFile("file://"+os.path.abspath(unitFilenames[1]))]
        unitFilenames = ["GC11.zip"]
        units = [toil.importFile("file://"+os.path.abspath(unitFilenames[0]))]

    
        service = MusicoService()
        rootJob = Job.wrapJobFn(rootJobFunc, unitFilenames, units, out_dir, service)

    
        output = toil.start(rootJob)
        print(output)

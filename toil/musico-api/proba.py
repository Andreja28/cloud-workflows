import requests
import json
res = requests.post("http://medflow.bioirc.ac.rs:3000/api/calcs/create", headers={"Content-Type":"application/json"}, data='{"calcs":["GC1.zip","GC2.zip"], "apiUser": true}')

calcJson = json.loads(res.text)['calcIds']
calcIds = json.dumps({
    "calcIds": calcJson,
    "apuUser": True
})
print(calcIds)


res = requests.post("http://medflow.bioirc.ac.rs:3000/api/calcs/upload", files={"zipFile[]":[open("GC1.zip",'rb'),open("GC2.zip",'rb')]})

"""res = requests.post("http://medflow.bioirc.ac.rs:3000/api/calcs/run", headers={"Content-Type":"application/json"}, data='{"calcIds":["5d9b63f5136ee7afa69cf9db","5d9b63f5136ee7afa69cf9dc"], "apiUser": true}')

flag = True
while (flag):
    res = requests.post("http://medflow.bioirc.ac.rs:3000/api/calcs/get-units", headers={"Content-Type":"application/json"}, data='{"calcId":"5d9b63f5136ee7afa69cf9db", "apiUser": true}')
    jsonRes = json.loads(res.text)
    
    flag = False
    for unit in jsonRes['units']:
        if (unit['endTime']==None):
            flag = True
            break

res = requests.post("http://medflow.bioirc.ac.rs:3000/api/calcs/run-sync", headers={"Content-Type":"application/json"}, data=calcIds)

res = requests.post("http://medflow.bioirc.ac.rs:3000/api/calcs/download-calc", headers={"Content-Type":"application/json"}, data='{"calcId":"5d9b63f5136ee7afa69cf9db", "apiUser": true}')
open("res.zip", 'wb').write(res.content)
"""
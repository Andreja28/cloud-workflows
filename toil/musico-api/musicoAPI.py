class MusicoAPI(object):

    def __init__(self):
        #replace $HOST and $PORT with corresponding data
        self.API = "$HOST:$PORT/api/calcs"


    def createCalcs(self):
        return self.API+"/create"
    
    def uploadCalcs(self):
        return self.API+"/upload"
    
    def runCalcs(self):
        return self.API+"/run"

    def getUnits(self):
        return self.API+"/get-units"

    def downloadCalc(self):
        return self.API+"/download-calc"

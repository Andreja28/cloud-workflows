class MusicoAPI(object):

    def __init__(self):
        self.API = "http://medflow.bioirc.ac.rs:3000/api/calcs"


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
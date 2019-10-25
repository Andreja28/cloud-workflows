class PakRunner(object):

    def __init__(self):
        self.API = "http://147.91.200.54:8081/pakrunner/rest/api/"


    def createTaskEndpoint(self):
        return self.API+"createnew"
    
    def startTaskEndpoint(self):
        return self.API+"runshorttask"
    
    def getResultsEndpoint(self):
        return self.API+"getresults"

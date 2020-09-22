from paraview.simple import *
import sys
import os, shutil, glob

os.mkdir("ensi")
for ensi in sys.argv[1:]:
    
    shutil.copy(ensi, "./ensi")

ensiObject = EnSightReader(CaseFileName=os.path.join("./ensi", "sputnik.ensi.case"))

SaveData("sputnik.vtm", ensiObject)



from toil.job import Job
from toil.common import Toil
import subprocess
import os, sys


def runQC(job, cwl_file, cwlFilename, yml_file, ymlFilename,inputFile,input_file, output_dir):
    job.fileStore.logToMaster("runQC")

    tempDir = job.fileStore.getLocalTempDir()

    #after importing files to global jobStore, it is required to read the global files for them to become visible to the job itself!!

    cwl = job.fileStore.readGlobalFile(cwl_file,userPath=os.path.join(tempDir,cwlFilename))
    yml = job.fileStore.readGlobalFile(yml_file,userPath=os.path.join(tempDir,ymlFilename))

    inp = job.fileStore.readGlobalFile(inputFile,userPath=os.path.join(tempDir,input_file))

    subprocess.check_call(['cwltoil',cwl,yml])

    output1_filename = "snpEff_genes.txt"
    output1_file = job.fileStore.writeGlobalFile(output1_filename)
    job.fileStore.readGlobalFile(output1_file,userPath=os.path.join(output_dir,output1_filename))

    output2_filename = "snpEff_summary.html"
    output2_file = job.fileStore.writeGlobalFile(output2_filename)
    job.fileStore.readGlobalFile(output2_file,userPath=os.path.join(output_dir,output2_filename))

    return [output1_file,output2_file]
    
if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./"+sys.argv[1])
    options.logLevel = "INFO"
    options.clean = "always"

    with Toil(options) as toil:
        in_out_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "cwlFiles")
        print(in_out_dir)


        cwlFilename = "workflow.cwl"
        cwl_file = toil.importFile("file://"+os.path.abspath(os.path.join(in_out_dir,cwlFilename)))

        ymlFilename = "inputs.yml"
        yml_file = toil.importFile("file://"+os.path.abspath(os.path.join(in_out_dir, ymlFilename)))

        input_file = "chr22.truncated.nosamples.1kg.vcf.gz"

        inputFile = toil.importFile("file://"+os.path.abspath(os.path.join(in_out_dir, input_file)))

        job = Job.wrapJobFn(runQC, cwl_file, cwlFilename, yml_file, ymlFilename,inputFile, input_file,in_out_dir)

        fajl1, fajl2 = toil.start(job)
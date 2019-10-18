import subprocess
from toil.common import Toil
from toil.job import Job

def helloWorld(job,message, memory="1G", cores=1, disk="1G"):
    return "Hello, world!, here's a message: %s" % message

if __name__=="__main__":
    options = Job.Runner.getDefaultOptions("./toilWorkflowRun")
    options.logLevel = "INFO"
    options.clean = "always"

    with Toil(options) as toil:
        output = toil.start(Job.wrapJobFn(helloWorld, "You did it!"))
    print(output)
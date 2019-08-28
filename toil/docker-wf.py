from toil.common import Toil
from toil.job import Job
from toil.lib.docker import apiDockerCall
import os

print(apiDockerCall)

container = Job.wrapJobFn(apiDockerCall,image="ubuntu",parameters=['ls', '-lha'])

if __name__ == "__main__":
    options = Job.Runner.getDefaultOptions("./toilWorkflowRun")
    options.logLevel = "INFO"
    options.clean = "never"

    with Toil(options) as toil:
        output = toil.start(container)

    print(output)
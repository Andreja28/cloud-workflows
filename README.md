# cloud-workflows

## toil/pakRunner

The task is to create a workflow executing a HPC job.
This feature is implemented using [pak runner](https://github.com/imilos/pakrunner) and wraping it in a toil service.

The workflow is run with the following command:

```
python main.py file:my-file-store
```

## toil/another-cwl

The task is to create a toil workflow which consists of a HPC job, and some other cwl workflow that is imported in a toil script. Cwl workflow is executing docker container. The workflow in this example is as follows:

* A hpc job is executed using pakrunner like in **toil/pakRunner** and as a result a .zip file is returned
* .zip file should be pipelined to the job executing the cwl workflow. Cwl is consisted only of a single step(for the example purposes), a docker container that is extracting the .zip, and returning the extrated files

Before running the workflow it is required to build docker image(the tag should be andra28/unpack) with the Dockerfile provided in the folder.
```
docker build --tag=andra28/unpack .
```
After building the image the workflow is run with the following command:
```
python main.py file:my-file-store
```

Output dir is se to cwlFiles

## toil/import_cwl
Example importing the cwl workflow in a toil script

* Provide the required inputs for the cwl
* Run the cwl workflow and get the outputs
* Export the outputs from the toil fileStore

Before running the workflow it is required to build docker image(the tag should be andra28/snpeff) with the Dockerfile provided in the folder.

The input for the cwl workflow is provided in cwlFiles dir (chr22.truncated.nosamples.1kg.vcf.gz)
```
docker build --tag=andra28/snpeff .
```
After building the image the workflow is run with the following command:
```
python toil_wf.py file:my-file-store
```

Output dir is set to cwlFiles.


**Note:** after running a workflow the folder toilWorkflowRun will be created. If you want to run the workflow again delete the folder or change the run options in the main function from **`_options.clean = "never"_ to _options.clean = "always"`** (automatically delete folder after completion)
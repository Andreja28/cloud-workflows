# morph-cwl workflow

Input in a workflow is a `.txt` file (as an example there is `input.txt` provided in this repository). The name of that file must be specified in the `.yaml` file (`inputs.yaml` provided in the repository) that needs to be uploaded to the [FES_API](https://github.com/Andreja28/FES-API). Zipped inputs field is a `.zip` file that contains inputs in the workflow (for example `.zip` containing `input.txt`) which is also provided in this repository (`inputs.zip`).

Also in the `.yaml` file there is an optional parameter `patient-id` that can take values 1, 3, 8, 12 (if the value is omitted or the value is incorrect default model will be deformed).

Example of creating and running workflow on FES_API:

* Create workflow

```bash
Request:

curl -F 'yaml=@mnt/d/inputs.yaml' -F 'input_zip=@mnt/d/inputs.zip' -F 'type=cwl' -F 'workflow-template=morph-cwl' -F 'metadata=Some metadata' cluster2.bioirc.ac.rs:5000/create-workflow

Response:

{
    "success": true,
    "GUID":"94506c1d-57cf-4268-83c1-f80b0c7e6c1d"
}


```

* Run workflow

```bash
Request:

curl -d '{"GUID":"94506c1d-57cf-4268-83c1-f80b0c7e6c1d"}' -H "Content-Type:application/json" -X POST cluster2.bioirc.ac.rs:5000/run-workflow

Response:
{
    "success": true
}

```

* Get results

```bash
Request:

curl cluster2.bioirc.ac.rs:5000/get-results?GUID=94506c1d-57cf-4268-83c1-f80b0c7e6c1d --output file.zip

Response:

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 9350k  100 9350k    0     0  84.8M      0 --:--:-- --:--:-- --:--:-- 85.3M

```
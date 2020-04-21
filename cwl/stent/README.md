I have provided an example of `.yaml` file from the `stent-cwl` template in the attachment.
Also I have provided a `.zip` file containing all the input files to the workflow

Here is the short overview ( `stent-cwl` template ):


Create workflow:
```bash
curl -F 'yaml=@inputs.yaml' -F 'input_zip=@inputs.zip'  -F 'type=cwl' -F 'workflow-template=stent-cwl' -F 'metadata=Some metadata' cluster2.bioirc.ac.rs:5000/create-workflow
```
Response:
```json
{
    "succcess": true,
    "GUID":"a9cc1463-76d8-4b35-a764-9b3fbf3477ad"
}
```

Run workflow:
```bash
curl -d '{"GUID":"a9cc1463-76d8-4b35-a764-9b3fbf3477ad"}' -H "Content-Type:application/json" -X POST cluster2.bioirc.ac.rs:5000/run-workflow
```

Response:
```json
{
    "success": true
}
```

Download results when the workflow is finished:

```bash
curl cluster2.bioirc.ac.rs:5000/get-results?GUID=a9cc1463-76d8-4b35-a764-9b3fbf3477ad --output file.zip
```

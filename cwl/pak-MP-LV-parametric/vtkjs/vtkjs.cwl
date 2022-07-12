class: CommandLineTool
cwlVersion: v1.0

hints:
  DockerRequirement:
    dockerImageId: vtkjs-pak
baseCommand: ["python3", "/vtkjs/main.py"]

requirements:
  InitialWorkDirRequirement:
    listing: 
      - $(inputs.vtu)

inputs:
    vtu:
        type: File[]
        inputBinding:
            position: 1
outputs:
    vtkjs:
        type: Directory
        outputBinding:
            glob: "_results/"
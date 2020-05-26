class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: ventricles

inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
outputs:
    stl:
        type: File
        outputBinding:
            glob: output.stl
    volume:
        type: File
        outputBinding:
            glob: volume.txt
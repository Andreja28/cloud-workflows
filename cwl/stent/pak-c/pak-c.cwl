class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/pak-c

inputs:
    dat:
        type: File
        inputBinding:
            position: 1
outputs:
    vtks:
        type:
            type: array
            items: File
        outputBinding:
            glob: "*.vtk"
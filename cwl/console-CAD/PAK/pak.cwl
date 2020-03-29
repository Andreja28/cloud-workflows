class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: pak

inputs:
    dat:
        type: File
        inputBinding:
            position: 1
outputs:
    res:
        type:
            type: array
            items: File
        outputBinding:
            glob: "*.VTK"
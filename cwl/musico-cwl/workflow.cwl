class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/musico

inputs:
    input-zip:
        type: File
        inputBinding:
            position: 1
outputs:
    res:
        type: File
        outputBinding:
            glob: results.zip
class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/morph

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
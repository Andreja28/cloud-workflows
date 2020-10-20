class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/torso-preprocessor

inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
outputs:
    dat:
        type: File
        outputBinding:
            glob: "pakf.dat"
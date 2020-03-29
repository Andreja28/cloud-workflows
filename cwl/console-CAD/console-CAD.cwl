class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: console-cad

inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
outputs:
    dat:
        type: File
        outputBinding:
            glob: "output/pak.dat"
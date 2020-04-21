class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: stent

inputs:
    fajl:
        type: File
        inputBinding:
            position: 1
outputs:
    dat:
        type: File
        outputBinding:
            glob: "Pak.dat"
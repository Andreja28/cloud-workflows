class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: console-cad:mp-cube


inputs:
    Ca:
        type: File
        inputBinding:
            position: 1

outputs:
    outputs:
        type: File[]
        outputBinding:
            glob: "output/*"
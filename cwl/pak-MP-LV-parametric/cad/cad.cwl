class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: console-cad:mp-lv-parametric


inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
    Ca:
        type: File
        inputBinding:
            position: 2

outputs:
    outputs:
        type: File[]
        outputBinding:
            glob: "output/*"
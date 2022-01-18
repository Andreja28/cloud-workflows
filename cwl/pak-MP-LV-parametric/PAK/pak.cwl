class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: pak:mp-lv-parametric


inputs:
    params:
        type: File
        inputBinding:
            position: 1
    cad:
        type: File[]
        inputBinding:
            position: 2
outputs:
    vtk:
        type: File[]
        outputBinding:
            glob: "*.vtk"
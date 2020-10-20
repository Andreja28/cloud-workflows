class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: slicer

inputs:
    txt:
        type: File
        inputBinding:
            position: 1
    vtks:
        type: File[]
        inputBinding:
            position: 2
outputs:
    vtu:
        type: File[]
        outputBinding:
            glob: "*-slice*.vtk"
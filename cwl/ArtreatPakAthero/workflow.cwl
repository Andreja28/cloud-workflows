class: CommandLineTool
cwlVersion: v1.0
baseCommand: ["/bin/bash", "/artreat/script.sh"]

requirements:
  - class: DockerRequirement
    dockerPull: andra28/artreat
  - class: InlineJavascriptRequirement
inputs:
    dat:
      type: File
      inputBinding:
        position: 1
outputs:
    vtk:
        type:
            type: array
            items: File
        outputBinding:
            glob: "*.vtk"

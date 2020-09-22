class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: pvpython
  - class: InlineJavascriptRequirement

inputs:
    ensi:
        type: File[]
        inputBinding:
            position: 1
outputs:
    vtu:
        type: File
        outputBinding:
            glob: ${var g = "sputnik/*.vtu";return g;}
            outputEval: ${ self[0].basename = self[0].basename.split("_")[0]+".vtu"; return self;}
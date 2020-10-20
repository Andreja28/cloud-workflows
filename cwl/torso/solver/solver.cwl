class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/torso-solver
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
    unvs:
        type:
            type: array
            items: File
        outputBinding:
            glob: "*.UNV"
            outputEval: ${ self.forEach(out => out.basename = out.basename.split(".")[0]+".unv"); return self;}
    unv:
        type:
            type: array
            items: File
        outputBinding:
            glob: "*.unv"
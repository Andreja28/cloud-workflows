class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/pak
  - class: InlineJavascriptRequirement
inputs:
    dat:
        type: File
        inputBinding:
            position: 1
outputs:
    vtks:
        type:
            type: array
            items: File
        outputBinding:
            glob: "*.VTK"
            outputEval: ${ self.forEach(out => out.basename = out.basename.split(".")[0]+".vtk"); return self;}
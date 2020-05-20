class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/morph
  - class: InlineJavascriptRequirement

inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
    patient-id:
        type: int?
        inputBinding:
            position: 2
            valueFrom: ${ if(self === null || self!=1 || self!=3 || self!=8 || self!=12) { return null;} else {return self;}}

outputs:
    stl:
        type: File
        outputBinding:
            glob: output.stl
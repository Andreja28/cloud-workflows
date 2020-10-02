class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/pak-fs:preprocess

inputs:
    input-file: 
        type: File
        inputBinding: 
            position: 1

outputs:
    dat:
        type: File
        outputBinding:
            glob: pak.dat
    solverVersion:
        type: File
        outputBinding:
            glob: solver_version.txt

class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerPull: andra28/console-cad:fs

inputs:
    input-file:
        type: File
        inputBinding:
            position: 1
outputs:
    dat:
        type: File
        outputBinding:
            glob: "output/pak.dat"
    solverVersion:
        type: File
        outputBinding:
            glob: "solver_version.txt"
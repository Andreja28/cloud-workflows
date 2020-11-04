class: CommandLineTool
cwlVersion: v1.0
baseCommand: []

requirements:
  - class: DockerRequirement
    dockerImageId: ohara

inputs:
    ohara-input:
        type: File
        inputBinding:
            position: 1
outputs:
    ohara-output:
        type: File
        outputBinding:
            glob: "OHaraOutput.txt"
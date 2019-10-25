#!usr/bin/env cwl-runner
class: Workflow

cwlVersion: v1.0

inputs:
    infile:
        type: File

outputs:
    skripta:
        type: File
        outputSource: unpack/skripta
    log:
        type: File
        outputSource: unpack/log

steps:
    unpack:
        run: 
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: []

            requirements:
              - class: DockerRequirement
                dockerImageId: andra28/unpack

            inputs:
                input_file:
                    type: File
                    inputBinding:
                        position: 1

            outputs:
                skripta:
                    type: File
                    outputBinding:
                        glob: "*.sh"
                log:
                    type: File
                    outputBinding:
                        glob: "*.log"
        in:
            input_file: infile
        out: [skripta, log]
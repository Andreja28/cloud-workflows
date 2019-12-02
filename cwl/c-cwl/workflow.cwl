#!usr/bin/env cwl-runner
class: Workflow

cwlVersion: v1.0

inputs:
    code:
        type: File
    infile:
        type: File

outputs:
    skripta:
        type: File
        outputSource: run_exec/output


steps:
    compile:
        run: 
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: [gcc,-o,exec]

            inputs:
                source_file:
                    type: File
                    inputBinding:
                        position: 1

            outputs:
                executable:
                    type: File
                    outputBinding:
                        glob: "exec"
        in:
            source_file: code
        out: [executable]
    run_exec:
        run:
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: []

            inputs:
                exec_file:
                    type: File
                    inputBinding:
                        position: 1
                input_file:
                    type: File
                    inputBinding:
                        position: 2
            outputs:
                output:
                    type: stdout
            
            stdout: output.txt
            
        in: 
            exec_file: compile/executable
            input_file: infile
        out:
            [output]
#!usr/bin/env cwl-runner
class: Workflow

cwlVersion: v1.0

inputs:
    file1:
        type: File
    file2:
        type: File
    script:
        type: File

outputs:
    merged:
        type: File
        outputSource: merge/mergedFile
    counted:
        type: File
        outputSource: count/countOut


steps:
    merge:
        run: 
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: [cat]

            inputs:
                first:
                    type: File
                    inputBinding:
                        position: 1
                second:
                    type: File
                    inputBinding:
                        position: 2

            outputs:
                mergedFile:
                    type: stdout

            
            stdout: merged.txt
        in:
            first: file1
            second: file2
        out: [mergedFile]
    count:
        run:
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: [bash]

            inputs:
                count-script:
                    type: File
                    inputBinding:
                        position: 1
                inputFile:
                    type: File
                    inputBinding:
                        position: 2
            outputs:
                countOut:
                    type: stdout
            
            stdout: count.txt
            
        in:
            count-script: script
            inputFile: merge/mergedFile
        out:
            [countOut]
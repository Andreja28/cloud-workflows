#!usr/bin/env cwl-runner
class: Workflow

cwlVersion: v1.0

inputs:
    genome:
        type: string
    infile:
        type: File
        doc: gzip VCF file to annotate

outputs:
    outfile:
        type: File
        outputSource: snpeff/output
    statsFile:
        type: File
        outputSource: snpeff/stats
    genesFile:
        type: File
        outputSource: snpeff/genes

steps:
    gunzip:
        run: 
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: [gunzip, -c]

            inputs:
                gzipfile:
                    type: File
                    inputBinding:
                        position: 1

            outputs:
                unzipped_vcf:
                    type: stdout

            stdout: unzipped.vcf
        in:
            gzipfile:
                source: infile
        out: [unzipped_vcf]
    snpeff:
        run: 
            class: CommandLineTool
            cwlVersion: v1.0
            baseCommand: []

            requirements:
              - class: DockerRequirement
                dockerImageId: andra28/snpeff

            inputs:
                genome:
                    type: string
                    inputBinding: 
                        position: 1
                input_vcf:
                    type: File
                    inputBinding:
                        position: 2
                    doc: VCF file to annotate

            outputs:
                output:
                    type: stdout
                stats:
                    type: File
                    outputBinding:
                        glob: "*.html"
                genes:
                    type: File
                    outputBinding:
                        glob: "*.txt"
        in:
            input_vcf: gunzip/unzipped_vcf
            genome: genome
        out: [output, stats, genes]
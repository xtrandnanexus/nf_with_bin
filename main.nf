nextflow.enable.dsl=2 

params.inputFile = ""
params.outDir = ""

inputFile = Channel.fromPath(params.inputFile)

workflow {
    main:
        modifyText(inputFile)
        duplicateText(modifyText.out)
    emit:
        modifyText.out.modify
        duplicateText.out.duplicate
}

process modifyText {
    container = "quay.io/nextflow/bash"
    publishDir "${params.outDir}"
    input:
	path inputFile
    output:
	path "output1.txt", emit: modify
    script:
	"""
	cat ${inputFile} | tr '[:lower:]' '[:upper:]' > output1.txt
	"""
}

process duplicateText {
    container = "quay.io/nextflow/bash"
    publishDir "${params.outDir}"
    input:
	path modify
    output:
	path "output2.txt", emit: duplicate
    script:
	"""
    	(cat ${modify}; script.sh ; cat ${modify}) > output2.txt
	"""
}

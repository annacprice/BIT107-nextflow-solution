#!/usr/bin/env nextflow

// enable dsl2
nextflow.enable.dsl = 2

// import modules
include {trimgalore} from '../modules/trimgalore.nf'
include {shovill} from '../modules/shovill.nf'
include {abricate} from '../modules/abricate.nf'
include {quast} from '../modules/quast.nf'
include {kraken2} from '../modules/kraken2.nf'

// define channels
Channel.fromFilePairs("${params.reads}", flat: true)
       .set{ inputFastq }

Channel.fromPath( "${params.kraken_db}" )
       .set{ kraken2DB }

// define workflow
workflow {

  // main workflow
  main:

    trimgalore(inputFastq)

    shovill(trimgalore.out.trimgalore_out)

    abricate(shovill.out.shovill_out)

    quast(shovill.out.shovill_quast.collect())

    kraken2(trimgalore.out.trimgalore_out, kraken2DB.toList())

}

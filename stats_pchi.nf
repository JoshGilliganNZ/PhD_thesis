#!/usr/bin/env nextflow

mapped_ch = Channel.fromPath("./markdup_pchi/*.cram")

process markdups {
  input:
    file(file) from mapped_ch

  output:
    file "*.stats"
    file "*.txt"

  publishDir "stats_processed_pchi", mode: 'move', overwrite: true

  cpus 6

  """
    samtools index ${file}
    samtools stats ${file} > ${file.baseName}.stats
    mosdepth -n --fasta /Volumes/scratch/deardenlab/Jgilligan/pop_2023/Pchi_annotated.fasta ${file.baseName} ${file} 
  """
}

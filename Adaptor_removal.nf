#!/usr/bin/env nextflow

reads_ch = Channel.fromFilePairs("/Volumes/scratch/deardenlab/Jgilligan/Population_full/combined/*{_r1,_r2}.fq.gz")

process AdapterTrim {
  input:
    tuple val(id), val(files) from reads_ch
  output:
    file "${id}*.gz"
  publishDir 'trimmed_fastq', mode: 'move' 
  cpus 16

  """
    AdapterRemoval --file1 ${files[0]} --file2 ${files[1]} \
      --threads 16 \
      --basename ${id} \
      --gzip \
      --trimns \
      --collapse \
       --adapter1 AGATCGGAAGAGCACACGTCTGAACTCCAGTCACAGAGTAGCATCTCGTATGCCGTCTTCTGCTT \
       --adapter2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAACAGGTGGTGTAGATCTCGGGGGTCGCCGTATCATT
    zcat *collapsed* > ${id}_singles.fastq
    zcat *singleton* >> ${id}_singles.fastq
    rm *collapsed*
    rm *singleton*
    pigz ${id}_singles.fastq
    mv ${id}*.pair1.truncated.gz ${id}_r1.fq.gz
    mv ${id}*.pair2.truncated.gz ${id}_r2.fq.gz
  """
}


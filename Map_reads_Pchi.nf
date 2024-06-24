#!/usr/bin/env nextflow

reads_ch = Channel.fromFilePairs("/Volumes/archive/scratch/deardenlab/Jgilligan/Population_full/trimmed_fastq/*_{r1,r2,singles}.f*.gz", size: 3)
// reads_ch.println()

process map_reads {
  input:
    tuple val(id), val(files) from reads_ch

  output:
    file "*.cram"

  publishDir "mapped_reads_pchi", mode: 'move' 
  

  cpus 30

  """
    bwa mem \
      -o ${id}.sam \
      -t 16 \
      -R '@RG\\tID:${id}_pair\\tSM:${id}' \
     /Volumes/scratch/deardenlab/Jgilligan/pop_2023/Pchi_annotated.fasta \
      ${files[0]} ${files[1]}
    samtools sort ${id}.sam -l 1 -o ${id}.sorted.bam -O bam
    bwa mem \
      -o ${id}_singles.sam \
      -t 16 \
      -R '@RG\\tID:${id}_single\\tSM:${id}' \
      /Volumes/scratch/deardenlab/Jgilligan/pop_2023/Pchi_annotated.fasta \
      ${files[2]}
   
    samtools sort ${id}_singles.sam -l 1 -o ${id}_singles.sorted.bam -O bam
    samtools merge -O CRAM --reference /Volumes/scratch/deardenlab/Jgilligan/pop_2023/Pchi_annotated.fasta \
      -o ${id}.cram *.bam
    rm *.sam
    rm *.bam
  """
}

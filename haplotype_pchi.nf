#!/usr/bin/env nextflow

markdup_ch = Channel.fromPath("./markdup_pchi/*.cram")
ref = "/Volumes/scratch/deardenlab/Jgilligan/pop_2023/Pchi_annotated.fasta"
gatk = "/Volumes/userdata/staff_users/joshgilligan/.conda/envs/Variant_calling/bin/gatk"

process haplotypecaller {
  input:
    file(file) from markdup_ch

  output:
    file "*.gvcf.gz"

  publishDir "gvcfs_pchi", mode: 'move', overwrite: true

  cpus 4
  memory '16 GB'

  """
    samtools index ${file}
    ${gatk} --java-options "-Xmx8g" HaplotypeCaller -I ${file} \
      -R ${ref} \
      -O ${file.baseName}.gvcf.gz \
      -ERC GVCF
  """
}

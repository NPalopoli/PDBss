#!/bin/bash

###############################################################################
#
# Add SEQRES and SEQATOM sequences (from SEQATOMs db) to PDB_ss entries
# File name: addSEQATOMs.sh
# Author: Nicolas Palopoli
# Date created: 2016/01/25
# Date last modified: 2016/01/25
# Bash version: 4.3.11(1)-release 
#
###############################################################################
#
# WARNING: PDB_ss_dis_all.txt 'PDB|Chain|sequence' sequences do not always match SEQRES/SEQATOM
# (e.g position 339 in sp|P05132|KAPCA_MOUSE, flanking ELMI001641, with PDB 1ATP, is S in PDB_ss and X in SEQRES/SEQATOM)
#
###############################################################################

### FUNCTIONS ###

### SETUP ###

# Set default paths
dirpdbss='/home/npalopoli/PDBss'
dirseqatom='/home/npalopoli/DBs/SEQATOMs'
outdir='/home/npalopoli/PDBss/PDBssSEQATOM_files'

# Check/create output directory
if [ ! -d "$dirpdbss"/PDBssSEQATOM_files ]
then
  mkdir "$outdir"
fi

# Write list of files to process
if [ ! -f "$dirpdbss"/PDBssSEQATOM.lst ]
then
  grep sequence "$dirpdbss"/PDB_ss_dis_all.txt | tr -d '>' | cut -d':' -f 1,2 | tr ':' '_' >"$dirpdbss"/PDB_ss.lst.tmp
  sort -u "$dirpdbss"/PDB_ss.lst.tmp >"$dirpdbss"/PDB_ss_sorted.lst.tmp
  sort -u "$dirseqatom"/SEQATOMs_split_present.lst >"$dirpdbss"/SEQATOMs_split_present_sorted.lst.tmp
  comm -1 -2 "$dirpdbss"/PDB_ss_sorted.lst.tmp "$dirpdbss"/SEQATOMs_split_present_sorted.lst.tmp >"$dirpdbss"/PDBssSEQATOM.lst  # PDB_Chain in common
  comm -2 -3 "$dirpdbss"/PDB_ss_sorted.lst.tmp "$dirpdbss"/SEQATOMs_split_present_sorted.lst.tmp >"$dirpdbss"/PDBssSEQATOM_onlyPDBss.lst  # Only in PDB_ss
  comm -1 -3 "$dirpdbss"/PDB_ss_sorted.lst.tmp "$dirpdbss"/SEQATOMs_split_present_sorted.lst.tmp >"$dirpdbss"/PDBssSEQATOM_onlySEQATOMs.lst  # Only in SEQATOMs
  rm "$dirpdbss"/PDB_ss.lst.tmp "$dirpdbss"/PDB_ss_sorted.lst.tmp "$dirpdbss"/SEQATOMs_split_present_sorted.lst.tmp
fi

### START ###

while read line
do
  pdb=`echo "$line" | cut -d'_' -f 1`
  chain=`echo "$line" | cut -d'_' -f 2`
  egrep -A 5 "$pdb:$chain:sequence" "$dirpdbss"/PDB_ss_dis_all.txt >"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  sed -i 's/:/|/g' "$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  cat "$dirseqatom"/SEQATOMs_split/SEQATOM_split_"$pdb"_"$chain".fasta >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
done<"$dirpdbss"/PDBssSEQATOM.lst 1>"$dirpdbss"/addSEQATOMs.out 2>"$dirpdbss"/addSEQATOMs.err

while read line
do
  pdb=`echo "$line" | cut -d'_' -f 1`
  chain=`echo "$line" | cut -d'_' -f 2`
  egrep -A 5 "$pdb:$chain:sequence" "$dirpdbss"/PDB_ss_dis_all.txt >"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  sed -i 's/:/|/g' "$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo ">""$pdb""|""$chain""|SEQRES" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  allgaps=`egrep -A 1 "$pdb:$chain:sequence" "$dirpdbss"/PDB_ss_dis_all.txt | tail -1 | tr '[[:alnum:]]' '-'`
  echo "$allgaps" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo '>'"$pdb"'|'"$chain"'|SEQATOM' >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo "$allgaps" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
done<"$dirpdbss"/PDBssSEQATOM_onlyPDBss.lst 1>>"$dirpdbss"/addSEQATOMs.out 2>>"$dirpdbss"/addSEQATOMs.err

while read line
do
  pdb=`echo "$line" | cut -d'_' -f 1`
  chain=`echo "$line" | cut -d'_' -f 2`
  allgaps=`egrep -A 1 "$pdb|$chain|SEQRES" "$dirseqatom"/SEQATOMs_split/SEQATOM_split_"$pdb"_"$chain".fasta | tail -1 | tr '[[:alnum:]]' '-'`
  echo ">""$pdb""|""$chain""|sequence" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo "$allgaps" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo ">""$pdb""|""$chain""|secstr" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo "$allgaps" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo ">""$pdb""|""$chain""|disorder" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  echo "$allgaps" >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
  cat "$dirseqatom"/SEQATOMs_split/SEQATOM_split_"$pdb"_"$chain".fasta >>"$outdir"/PDBssSEQATOM_"$pdb"_"$chain".fasta
done<"$dirpdbss"/PDBssSEQATOM_onlySEQATOMs.lst 1>>"$dirpdbss"/addSEQATOMs.out 2>>"$dirpdbss"/addSEQATOMs.err


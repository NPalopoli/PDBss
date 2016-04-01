#!/bin/bash

# Check output directory exists and list contents
if [ -d PDBssSEQATOM_files ]
then
  ls PDBssSEQATOM_files >PDBssSEQATOM_all.lst
else
  exit
fi

# concatenate files in directory
while read line
do
  cat PDBssSEQATOM_files/"$line" >>PDB_ss_dis_SEQATOM_all.txt
done<PDBssSEQATOM_all.lst

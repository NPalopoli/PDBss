#!/bin/bash

###############################################################################
#
# Bash wrapper to unify 'ss_dis.txt' and 'ss.txt' files from PDB
# File name: unifyPDBss.sh
# Author: Nicolas Palopoli
# Date created: 2015/11/01
# Date last modified: 2015/11/02
# Bash version: 4.3.11(1)-release 
#
###############################################################################

### START ###

# Activate to download files
# wget http://www.rcsb.org/pdb/files/ss.txt -o PDB_ss.txt
# wget http://www.rcsb.org/pdb/files/ss_dis.txt -o PDB_ss_dis.txt

cat PDB_ss.txt | tr ' ' '-' >PDB_ss_edit.txt
cat PDB_ss_dis.txt | tr ' ' '-' >PDB_ss_dis_edit.txt
./unifyPDBss.py >PDB_ss_dis_all.txt

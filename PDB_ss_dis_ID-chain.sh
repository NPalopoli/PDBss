#!/bin/bash

# get list of PDBID:CHAIN with disorder
grep disorder PDB_ss_dis.txt | cut -d'>' -f 2 | cut -d':' -f 1-2 >PDB_ss_dis_ID-chain.txt

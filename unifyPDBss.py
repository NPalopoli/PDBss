#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
  Unify 'ss_dis.txt' and 'ss.txt' files from PDB
  File name: unifyPDBss.py
  Author: Nicolas Palopoli
  Date created: 2015/10/31
  Date last modified: 2015/11/02
  Python Version: 2.7
'''

import sys
from collections import OrderedDict
from Bio import SeqIO

def parsePDBss(infile,infiledis):
  '''Read 2nd struct from PDB files ss.txt and ss_dis.txt in FASTA format'''
  PDBss = OrderedDict()
  for line in SeqIO.parse(infile,'fasta'):
    key = ">%s" % line.id
    PDBss[key] = line.seq
    if 'secstr' in line.id:
      linedis = ">%s:%s" % (line.id[0:6],'disorder')
      PDBss[linedis] = '-' * len(line.seq)
  for line in SeqIO.parse(infiledis,'fasta'):
    key = ">%s" % line.id
    PDBss[key] = line.seq
  return PDBss

PDBss = parsePDBss('PDB_ss_edit.txt','PDB_ss_dis_edit.txt')
for key,val in PDBss.items():
  print "%s\n%s" % (key,val)

# -*- coding: utf-8 -*-
"""
Created on Mon May 21 14:18:20 2018

@author: T004314
"""
import pdfminer

from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument

fp = open('diveintopython.pdf', 'rb')
parser = PDFParser(fp)
doc = PDFDocument(parser)

print doc.info  # The "Info" metadata
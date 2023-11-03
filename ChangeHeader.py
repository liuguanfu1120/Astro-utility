# -*- encoding:utf-8 -*-
"""
@Author: Guan-Fu Liu
Created on Aug. 28, 2023
Last modified on Sep. 17, 2023
Add TUNIT in the header of EBOUNDS BinTableHDU
"""

from astropy.io import fits
import os
filenames = os.listdir('.')
rspfiles = [a for a in filenames if a.endswith('.rsp')]

for i in rspfiles:
    rsp = fits.open(i)
    rsp.writeto(i[:-4]+'-old.rsp', overwrite=True)
    rsp['EBOUNDS'].header.insert(rsp['EBOUNDS'].header.index('TFORM1')+1, 
                                  ('TUNIT1','channel', 'physical unit of field'))

    rsp['EBOUNDS'].header.insert(rsp['EBOUNDS'].header.index('TFORM2')+1, 
                                  ('TUNIT2','keV', 'physical unit of field'))

    rsp['EBOUNDS'].header.insert(rsp['EBOUNDS'].header.index('TFORM3')+1, 
                                  ('TUNIT3','keV', 'physical unit of field'))

    rsp.writeto(i, overwrite=True)

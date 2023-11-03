#!/bin/bash
# This shell script should be executed in directory work_dir/obsid/rgs.
# Run the RGS data reduction pipeline rgsproc.
# The 3rd shell script.
# Author: Guan-Fu Liu
# Date: Sep. 18, 2023
rgsproc withsrc=yes srclabel=USER srcra=${ra_deg} srcdec=${dec_deg} witheffectiveareacorrection=yes withbackgroundmodel=yes xpsfincl=${xpsfincl} xpsfexcl=${xpsfexcl}

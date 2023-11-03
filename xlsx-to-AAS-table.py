# -*- coding: utf-8 -*-
# -*- coding: utf-8 -*-
"""
Author: Guan-Fu Liu
Created on Aug. 29, 2023
Last modified on Sep. 4, 2023
Convert excel table to LaTeX code of AASTeX (aastex631) template
"""
import pandas as pd
df = pd.read_excel('cie1.xlsx')
ncols = len(df.columns)
nrows = len(df.iloc[:,0])
# Define the file name
file_name = "cie1.tex"
# Open the file in write mode ('w')
lines = [ ]
title = "Fitting results of two observations for a single-temperature model"
comment = "The $C$-statistics of ObsID=0822960201 is within the expected $C$-statistics range, of which the 68\% confidence "+\
"level uncertainties are provided."
label = "cie1"
twocolumns = True
# If True, your table will span both columns in a double column text style,
# You should use \begin{deluxetable*} and \end{deluxetable*}.
# If Flase, you will use \begin{deluxetable} and \end{deluxetable}.
with open(file_name, 'w') as file:
    # Write lines to the file
    if twocolumns:
        line = "\\begin{deluxetable*}{%s}\n"%("l"+ (ncols-1)*"c")
    else:
        line = "\\begin{deluxetable}{%s}\n"%("l"+ (ncols-1)*"c")
    file.write(line)
    lines.append(line)
    line = "\t\\tabletypesize{\\scriptsize}\n"
    file.write(line)
    lines.append(line)
    line = "\t\\tablewidth{0pt}\n"
    file.write(line)
    lines.append(line)
    line = "\t%\\tablenum{1}\n"
    file.write(line)
    lines.append(line)
    line = "\t\\tablecaption{%s\\label{tab:%s}}\n" % (title, label)
    file.write(line)
    lines.append(line)
    line = "\t\\tablehead{\n"
    file.write(line)
    lines.append(line)
    # First row in the Excel table file
    line = ['\t']
    for i in range(ncols):
        line.append('\\colhead{%s} & '%str(df.columns[i]))
    second = input("Does the second line in Excel table file represent the units? (yes or no) \n")
    if (second).lower() == "yes":
        line[-1] = line[-1][:-3]+" \\\\\n"
        file.writelines(line)
        lines.append("".join(line))
        line = ['\t']
        for i in range(ncols):
            line.append('\colhead{%s} & ' % str(df.iloc[0, i]))
        line[-1] = line[-1][:-3]+" \n"
        line = [a.replace("nan","") for a in line]
        file.writelines(line)
        lines.append("".join(line))
    else:
        line[-1] = line[-1][:-3]+" \n"
        file.writelines(line)
        lines.append("".join(line))
    line = "\t}\n"
    file.writelines(line)
    lines.append(line)
    line = "\t\\colnumbers\n"
    file.writelines(line)
    lines.append(line)
    line = "\t\\startdata\n"
    file.writelines(line)
    lines.append(line)
    if (second).lower() == "yes":
        for i in range(1, nrows-1, 1):
            line = ['\t']
            for j in range(ncols):
                line.append("%s & " % str(df.iloc[i, j]))
            line[-1] = line[-1][:-3]+"\\\\\n"
            file.writelines(line)
            lines.append("".join(line))
    else:
        for i in range(0, nrows-1, 1):
            line = ['\t']
            for j in range(ncols):
                line.append("%s & " % str(df.iloc[i, j]))
            line[-1] = line[-1][:-3]+"\\\\\n"
            file.writelines(line)
            lines.append("".join(line))
        
    # The last row in the Excel table file
    line = ['\t']
    for j in range(ncols):
        line.append("%s & " % str(df.iloc[nrows-1, j]))
    line[-1] = line[-1][:-3]+"\n"
    file.writelines(line)
    lines.append("".join(line))
    line = "\t\\enddata\n"
    file.write(line)
    lines.append(line)
    line = "\\tablecomments{%s}\n"%comment
    file.write(line)
    lines.append(line)
    if twocolumns:
        line = "\\end{deluxetable*}"
    else:
        line = "\\end{deluxetable}"
    file.write(line)
    lines.append(line)
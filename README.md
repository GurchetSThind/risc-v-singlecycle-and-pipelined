In order to test out the processor design, open vivado and create a new project, then add the files under "Modules\design sources" and "Memory Files" as design sources and those under "Modules\simulation sources" as simulation sources, since there is only one simulation source, it will set as top by default. Next, select run simulation, the final values of the words in register file and data file after running the 24 instruction program, will be displayed in the TCL Console. The program includes the following types of instructions:
    1.) R type (add, sub, and, or)
    2.) I type (lw)
    3.) S type (sw)
    4.) B type (beq)
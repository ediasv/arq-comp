#!/usr/bin/fish

rm -f work-obj93.cf

for file in *.vhd
    ghdl -a $file
end

for file in *_tb.vhd
    set basename (basename $file .vhd)
    ghdl -e $basename
    ghdl -r $basename --vcd=$basename.vcd
end

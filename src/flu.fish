#!/usr/bin/fish

rm work-obj93.cf

for file in *.vhd
    ghdl -a $file
end

for file in *_tb.vhd
    set basename (basename $file .vhd)
    ghdl -e $basename
end

ghdl -r top_level_full_tb --vcd=top_level_full_tb.vcd
gtkwave top_level_full_tb.vcd
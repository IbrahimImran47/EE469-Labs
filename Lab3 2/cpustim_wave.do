onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpustim/dut/clk
add wave -noupdate /cpustim/dut/reset
add wave -noupdate -radix hexadecimal /cpustim/dut/PC
add wave -noupdate -radix hexadecimal /cpustim/dut/instruction
add wave -noupdate /cpustim/dut/NFlag
add wave -noupdate /cpustim/dut/VFlag
add wave -noupdate /cpustim/dut/ZFlag
add wave -noupdate /cpustim/dut/CFlag
add wave -noupdate -childformat {{{/cpustim/dut/regf/registerOut[31]} -radix unsigned} {{/cpustim/dut/regf/registerOut[30]} -radix unsigned} {{/cpustim/dut/regf/registerOut[29]} -radix unsigned} {{/cpustim/dut/regf/registerOut[28]} -radix unsigned} {{/cpustim/dut/regf/registerOut[27]} -radix unsigned} {{/cpustim/dut/regf/registerOut[26]} -radix unsigned} {{/cpustim/dut/regf/registerOut[25]} -radix unsigned} {{/cpustim/dut/regf/registerOut[24]} -radix unsigned} {{/cpustim/dut/regf/registerOut[23]} -radix unsigned} {{/cpustim/dut/regf/registerOut[22]} -radix unsigned} {{/cpustim/dut/regf/registerOut[21]} -radix unsigned} {{/cpustim/dut/regf/registerOut[20]} -radix unsigned} {{/cpustim/dut/regf/registerOut[19]} -radix unsigned} {{/cpustim/dut/regf/registerOut[18]} -radix unsigned} {{/cpustim/dut/regf/registerOut[17]} -radix unsigned} {{/cpustim/dut/regf/registerOut[16]} -radix unsigned} {{/cpustim/dut/regf/registerOut[15]} -radix unsigned} {{/cpustim/dut/regf/registerOut[14]} -radix unsigned} {{/cpustim/dut/regf/registerOut[13]} -radix unsigned} {{/cpustim/dut/regf/registerOut[12]} -radix unsigned} {{/cpustim/dut/regf/registerOut[11]} -radix unsigned} {{/cpustim/dut/regf/registerOut[10]} -radix unsigned} {{/cpustim/dut/regf/registerOut[9]} -radix unsigned} {{/cpustim/dut/regf/registerOut[8]} -radix unsigned} {{/cpustim/dut/regf/registerOut[7]} -radix unsigned} {{/cpustim/dut/regf/registerOut[6]} -radix unsigned} {{/cpustim/dut/regf/registerOut[5]} -radix unsigned} {{/cpustim/dut/regf/registerOut[4]} -radix unsigned} {{/cpustim/dut/regf/registerOut[3]} -radix unsigned} {{/cpustim/dut/regf/registerOut[2]} -radix unsigned} {{/cpustim/dut/regf/registerOut[1]} -radix unsigned} {{/cpustim/dut/regf/registerOut[0]} -radix unsigned}} -expand -subitemconfig {{/cpustim/dut/regf/registerOut[31]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[30]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[29]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[28]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[27]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[26]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[25]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[24]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[23]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[22]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[21]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[20]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[19]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[18]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[17]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[16]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[15]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[14]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[13]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[12]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[11]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[10]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[9]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[8]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[7]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[6]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[5]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[4]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[3]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[2]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[1]} {-height 15 -radix unsigned} {/cpustim/dut/regf/registerOut[0]} {-height 15 -radix unsigned}} /cpustim/dut/regf/registerOut
add wave -noupdate -radix hexadecimal /cpustim/dut/dMemory/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3615091935 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5257875 ns}

quit -sim
vlib work
vlog *.v 

vsim -Lf 220model_ver -Lf altera_mf_ver -Lf verilog work.basic2_tb

#configure wave -signalnamewidth 20
set SignalNameWidth 0

# show waveforms specified in wave.do
add wave -noupdate -divider AND
add wave -noupdate -label X1 /basic2_tb/tb_a
add wave -noupdate -label X2 /basic2_tb/tb_b
add wave -noupdate -label X1.X2 /basic2_tb/tb_and
add wave -noupdate -divider OR
add wave -noupdate -label X1 /basic2_tb/tb_a
add wave -noupdate -label X2 /basic2_tb/tb_b
add wave -noupdate -label X1+X2 /basic2_tb/tb_or
add wave -noupdate -divider NAND
add wave -noupdate -label X1 /basic2_tb/tb_a
add wave -noupdate -label B /basic2_tb/tb_b
add wave -noupdate -label Y /basic2_tb/tb_nand
add wave -noupdate -divider NOR
add wave -noupdate -label X1 /basic2_tb/tb_a
add wave -noupdate -label B /basic2_tb/tb_b
add wave -noupdate -label Y /basic2_tb/tb_nor
add wave -noupdate -divider NOT
add wave -noupdate -label X /basic2_tb/tb_a
add wave -noupdate -label not-X /basic2_tb/tb_not
add wave -noupdate -divider XOR
add wave -noupdate -label A /basic2_tb/tb_a
add wave -noupdate -label B /basic2_tb/tb_b
add wave -noupdate -label Y /basic2_tb/tb_xor


configure wave -timelineunits ns

update
WaveRestoreZoom {0 ps} {120 ns}

# advance the simulation the desired amount of time
run 50 ns
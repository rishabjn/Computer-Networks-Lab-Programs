
if {$argc != 1} {
	puts "invalid number of argunments"
	exit 0
}

set nn [lindex $argv 0]
set opt(x) 750
set opt(y) 750
set stop 100
set ns [new Simulator]
set t [open out4.tr w]
set nt [open out4.nam w]

$ns trace-all $t
$ns namtrace-all-wireless $nt $opt(x) $opt(y)

set topo [new Topography]
$topo load_flatgrid  $opt(x) $opt(y)

set god_ [create-god $nn]

$ns node-config \
-adhocRouting AODV \
-llType LL \
-macType Mac/802_11 \
-ifqType Queue/DropTail/PriQueue \
-ifqLen 50 \
-channelType Channel/WirelessChannel \
-propType Propagation/TwoRayGround \
-antType Antenna/OmniAntenna \
-phyType Phy/WirelessPhy \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace OFF 

for {set i 0} {$i < $nn } {incr i} {
	set n($i) [$ns node]
}

for {set i 0} {$i < $nn } {incr i} {
	$ns initial_node_pos $n($i) 30
}

set tcp [new Agent/TCP]
$ns attach-agent $n(1) $tcp
set ftp [new Application/FTP]
$ftp attach-agent $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n(3) $sink
$ns connect $tcp $sink
$ns at 0.0 "destination"

proc destination {} {
	global ns nn n
	set now [$ns now]
	set time 5.0
	for {set i 0} {$i < $nn} {incr i} {
		set XX [expr rand()*750]
		set YY [expr rand()*750]
		$ns at [expr $now + $time] "$n($i) setdest $XX $YY 20.0"
	}
	$ns at [expr $now + $time] "destination"
}
for {set i 0} {$i < $nn} {incr i} {
	$ns at $stop "$n($i) reset"
}
	$ns at 5.0 "$ftp start"
	$ns at $stop "$ns nam-end-wireless $stop"
	$ns at $stop "stop"

proc stop {} {
	global ns t nt
	close $t
	close $nt
	exec nam out4.nam &
	exit 0
}
$ns run

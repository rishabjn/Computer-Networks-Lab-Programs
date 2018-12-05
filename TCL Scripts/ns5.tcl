set opt(ecn) 0
set opt(window) 30
set opt(type) gsm

set bwdl(gsm) 100000
set bwul(gsm) 100000

set propdl(gsm) .500
set propul(gsm) .500

set buf(gsm) 10

set ns [new Simulator]
set tf [open out5.tr w]
set nf [open out5.nam w]

$ns trace-all $tf
$ns namtrace-all $nf

set nodes(s) [$ns node]
set nodes(bs1) [$ns node]
set nodes(ms) [$ns node]
set nodes(bs2) [$ns node]
set nodes(d) [$ns node]

proc cell_topo {} {
	global ns nodes
	$ns duplex-link $nodes(s) $nodes(bs1) 3mb 10ms DropTail
	$ns duplex-link $nodes(bs1) $nodes(ms) 3mb 10ms RED
	$ns duplex-link $nodes(ms) $nodes(bs2) 3mb 10ms RED
	$ns duplex-link $nodes(bs2) $nodes(d) 3mb 10ms DropTail
	puts "cell topology"
}

proc set_link_params {t} {
	global ns nodes bwul bwdl propul propdl buf
	$ns bandwidth $nodes(bs1) $nodes(ms) $bwdl($t) simplex
	$ns bandwidth $nodes(ms) $nodes(bs1) $bwul($t) simplex
	$ns bandwidth $nodes(bs2) $nodes(ms) $bwdl($t) simplex
	$ns bandwidth $nodes(ms) $nodes(bs2) $bwul($t) simplex

	$ns delay $nodes(bs1) $nodes(ms) $propdl($t) simplex
	$ns delay $nodes(ms) $nodes(bs1) $propdl($t) simplex
	$ns delay $nodes(bs2) $nodes(ms) $propdl($t) simplex
	$ns delay $nodes(ms) $nodes(bs2) $propdl($t) simplex

	$ns queue-limit $nodes(bs1) $nodes(ms) $buf($t)
	$ns queue-limit $nodes(ms) $nodes(bs1) $buf($t)
	$ns queue-limit $nodes(bs2) $nodes(ms) $buf($t)
	$ns queue-limit $nodes(ms) $nodes(bs2) $buf($t)
}

Queue/DropTail set summarystats_ true
Queue/RED set summarystats_ true
Queue/RED set adaptive_ 1
Queue/RED set q_weight_ 0.0
Queue/RED set thresh_ 5
Queue/RED set maxthresh_ 10
Agent/TCP set ecn_ $opt(ecn)
Agent/TCP set window_ $opt(window)

switch $opt(type) {
	gsm - gprs - umts {cell_topo}
}

set_link_params $opt(type)

$ns insert-delayer $nodes(ms) $nodes(bs1) [new Delayer]
$ns insert-delayer $nodes(bs1) $nodes(ms) [new Delayer]
$ns insert-delayer $nodes(ms) $nodes(bs2) [new Delayer]
$ns insert-delayer $nodes(bs2) $nodes(ms) [new Delayer]

set tcp1 [$ns create-connection TCP/Sack1 $nodes(s) TCPSink/Sack1 $nodes(d) 0.0]
set ftp1 [[set tcp1] attach-app FTP]

$ns at 0.5 "$ftp1 start"

proc stop {} {
	global ns nf tf
	$ns flush-trace 
	close $nf
	close $tf
	exec nam out5.nam & 
	exit 0
}

$ns at 100 "stop"
$ns run

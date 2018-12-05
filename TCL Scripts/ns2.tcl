set ns [new Simulator]
set nf [open out2.tr w]
set f [open out2.nam w]

$ns trace-all $nf
$ns namtrace-all $f

proc finish {} {
	global ns nf f
	$ns flush-trace
	close $nf
	close $f
	exec nam out2.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 2mb 10ms DropTail
$ns duplex-link $n1 $n2 2mb 10ms DropTail
$ns duplex-link $n2 $n3 0.1mb 10ms DropTail
$ns duplex-link $n3 $n4 2mb 10ms DropTail
$ns duplex-link $n3 $n5 2mb 10ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n5 orient right-down

$ns queue-limit $n2 $n3 20

set ping0 [new Agent/Ping]
set ping1 [new Agent/Ping]
set ping4 [new Agent/Ping]
set ping5 [new Agent/Ping]

$ns attach-agent $n0 $ping0
$ns attach-agent $n1 $ping1
$ns attach-agent $n4 $ping4
$ns attach-agent $n5 $ping5

$ns connect $ping0 $ping5
$ns connect $ping1 $ping4
$ns connect $ping4 $ping0
$ns connect $ping1 $ping5

proc sending {} {

	global ns ping0 ping1 ping4 ping5
	set pi 0.01
	set t [$ns now]
	puts "$t and $pi"
	$ns at [expr $t + $pi] "$ping0 send"
	$ns at [expr $t + $pi] "$ping1 send"
	$ns at [expr $t + $pi] "$ping4 send"
	$ns at [expr $t + $pi] "$ping5 send"
	$ns at [expr $t + $pi] "sending"
	
}

Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "node [$node_ id] receive ping msg $from with rtt $rtt ms"
}



$ns at 0.01 "sending"

$ns rtmodel-at 3.0 down $n2 $n3
$ns rtmodel-at 5.0 up $n2 $n3

$ns at 10.0 "finish"
$ns run
}

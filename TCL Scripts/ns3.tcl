set ns [new Simulator]
set nf [open out3.tr w]
set f [open out3.nam w]

$ns trace-all $nf
$ns namtrace-all $f

proc finish {} {
	global ns nf f
	$ns flush-trace
	close $f
	close $nf
	exec nam out3.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]

$n1 label "TCP/Vegas"
$n2 label "TCP/Reno"
$n7 label "sink1"
$n8 label "sink2"
$n7 shape box
$n7 color red
$n8 shape hexagon
$n8 color blue

$ns duplex-link $n0 $n2 2mb 10ms DropTail
$ns duplex-link $n1 $n2 2mb 10ms DropTail
$ns duplex-link $n2 $n3 2mb 10ms DropTail

$ns make-lan "$n3 $n4 $n5 $n6 $n7 $n8" 512kb 40ms LL Queue/DropTail Mac/802_3

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

$ns queue-limit $n2 $n3 20

set tcp1 [new Agent/TCP/Vegas]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n7 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
set tfile1 [open cwnd1.tr w]
$tcp1 attach $tfile1
$tcp1 trace cwnd_

set tcp2 [new Agent/TCP/Reno]
$ns attach-agent $n2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n8 $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
set tfile2 [open cwnd2.tr w]
$tcp2 attach $tfile2
$tcp2 trace cwnd_

$ns at 0.5 "$ftp1 start"
$ns at 1.0 "$ftp2 start"
$ns at 5.0 "$ftp1 stop"
$ns at 5.0 "$ftp2 stop"
$ns at 5.5 "finish"

$ns run

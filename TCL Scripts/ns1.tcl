 set ns [new Simulator]
 set nf [open out1.tr w]
 set f [open out1.nam w]

 $ns trace-all $nf
 $ns namtrace-all $f

 proc finish {} {
 	global ns nf f
 	$ns flush-trace
 	close $nf
 	close $f
 	exec nam out1.nam &
 	exit 0 
 }
 $ns color 1 "Red"
 $ns color 2 "Blue"
 set n0 [$ns node]
 set n1 [$ns node]
 set n2 [$ns node]

 $n0 label "UDP"
 $n1 label "TCP"
 $n2 label "Destination"

 $ns duplex-link $n0 $n1 0.25Mb 10ms DropTail
 $ns duplex-link $n1 $n2 1.25Mb 10ms DropTail

 $ns queue-limit $n0 $n1 20
 $ns queue-limit $n1 $n2 20

 $ns duplex-link-op $n0 $n1 orient right
 $ns duplex-link-op $n1 $n2 orient down

 set tcp [new Agent/TCP]
 $ns attach-agent $n1 $tcp
 set sink [new Agent/TCPSink]
 $ns attach-agent $n2 $sink
 $ns connect $tcp $sink
 #$tcp set packetSize_ 552
 $tcp set fid_ 1
 set ftp [new Application/FTP]
 $ftp attach-agent $tcp

 set udp [new Agent/UDP]
 $ns attach-agent $n0 $udp
 set null [new Agent/Null]
 $ns attach-agent $n2 $null
 $ns connect $udp $null
 set cbr [new Application/Traffic/CBR]
 $cbr attach-agent $udp
 #$cbr set packetSize_ 552
 $cbr set fid_ 2

 
 $ns at 0.1 "$cbr start" 
 $ns at 1.0 "$ftp start"
 $ns at 124.0 "$ftp stop"
 $ns at 124.5 "$cbr stop"
 $ns at 125.0 "finish"
 $ns run
BEGIN {
	PacketRecv = 0;
	Throughput =0;
}
{
	if(($1 == "r")&& ($3 == "_3_") && ($4 == "AGT") && ($7 == "tcp")&& ($8 > 1000))
	{
		PacketRecv++;
	}
}
END {
	Throughput = ((PacketRecv *1000 * 8)/(95.0*1000000));
	printf("Throughput is %f\n", Throughput);
}
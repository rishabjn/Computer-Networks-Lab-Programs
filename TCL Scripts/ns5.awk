BEGIN{
	pkt=0;
	t=0;
}
{
	if(($1 == "r") && ($5 == "tcp") && ($10 == 4.0)){
	p++;
	}
}
END{
	t = ((p * 1000 *8)/(95 * 1000000));
	printf("Throughput: %f\n", t);
}
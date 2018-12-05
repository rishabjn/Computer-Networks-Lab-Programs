BEGIN{
	c=0;
}
{
	if($1 == "d"){
	c++;
	}
}
END{
	printf("packet drop is: %d\n",c);
}
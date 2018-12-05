import java.util.*;

class crc{
	public void div(int a[], int k,int gp[]){
		int c=0;
		for(int i=0;i<k;i++)
			if(a[i] == gp[0]){
				for(int j=i;j<17+i;j++)
					a[j]=a[j]^gp[c++];
				c=0;
			}
		}

	public static void main(String[] args)  {
		int gp[] = {1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1};
		Scanner sc = new Scanner(System.in);
		int a[] = new int[100];
		int b[] = new int[100];
		int len,k,inplen;
		crc cc = new crc();
		System.out.println("enter size of message");
		len = sc.nextInt();
		int flag=0;
		inplen=len;
		System.out.println("enter the message");
		for(int i=0;i<len;i++)
			a[i]=sc.nextInt();
		for(int i=0;i<16;i++)
			a[len++]=0;
		k = len-16;
		System.out.println(k);
		for(int i=0;i<len;i++)
			b[i]=a[i];
		cc.div(a,k,gp);
		System.out.println("checksum is:");
		for(int i=inplen;i<len;i++)
			System.out.print(a[i]+" ");
		System.out.println();
		for(int i=0;i<len;i++)
			a[i]=a[i]^b[i];
		System.out.println("data to be transmitted is");
		for(int i=0;i<len;i++)
			System.out.print(a[i]+" ");
		
		System.out.println("\nenter data received");
		for(int i=0;i<len;i++)
			a[i]=sc.nextInt();
		cc.div(a,k,gp);
		for(int i=0;i<len;i++)
			if(a[i]!=0){
				flag=1;
				break;
			}
		if(flag==1)
			System.out.println("error in data");
		else
			System.out.println("No error");
	}

}
	

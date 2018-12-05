import java.util.Scanner;

class bell{ 
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int n,src;
		System.out.println("enter matrix size");
		n=sc.nextInt();
		int a[][] = new int[n][n];
		System.out.println("enter matrix values");
		for(int i=0;i<n;i++){
			for(int j=0;j<n;j++){
				a[i][j]=sc.nextInt();
			}
		}
		System.out.println("enter source");
		src = sc.nextInt();
		bell b = new bell();
		b.evalute(a,n,src);
	}

	public void evalute(int a[][],int n,int src){
			int max=999;
			int dist[] = new int[n];
			for(int i=0;i<n;i++){
				dist[i]=max;
			}
			dist[src]=0;
			for(int k=0;k<n-1;k++){
				for(int i=0;i<n;i++){
					for(int j=0;j<n;j++){
						if(a[i][j]!=max){
							if(dist[j]>dist[i]+a[i][j]){
								dist[j]=dist[i]+a[i][j];
							}
						}
					}
				}
			}
			for(int i=0;i<n;i++){
					for(int j=0;j<n;j++){
						if(a[i][j]!=max){
							if(dist[j]>dist[i]+a[i][j]){
								System.out.println("negative cycle");
								return;
							}
						}
					}
				}
			for(int i=0;i<n;i++){

				System.out.println("dist from " +src +"to " + (i) +"is " +dist[i]);
			}	
		}
	}
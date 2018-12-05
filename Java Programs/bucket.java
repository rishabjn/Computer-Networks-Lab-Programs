import java.util.*;
import java.io.*;

class bucket{
	public static int bsize,q_data,trate,time,inp[],drec[],ddrop[],dleft[];
	public static void input(){
		Scanner sc = new Scanner(System.in);
		System.out.println("enter bucket size");
		bsize=sc.nextInt();
		System.out.println("enter transmission rate");
		trate=sc.nextInt();
		System.out.println("enter transmission time");
		time=sc.nextInt();
		inp = new int[time];
		for(int i=0;i<time;i++){
			System.out.print("enter data in " +i + " sec:");
			inp[i]=sc.nextInt();
		}
		drec = new int[time];
		ddrop = new int[time];
		dleft = new int[time];
		for(int i=0;i<time;i++){
			drec[i]=0;
			ddrop[i]=0;
			dleft[i]=0;
		}
	}

	public static void cal(){
		q_data=0;
		for(int i=0;i<time;i++){
			q_data=q_data+inp[i];
			if(q_data<=trate){
				drec[i]= q_data;
				ddrop[i]=0;
				dleft[i]=0;
				q_data=0;
				
			}
			else if(q_data<=bsize){
				drec[i]=trate;
				ddrop[i]=0;
				dleft[i]=q_data - trate;
				q_data=q_data - trate;
				
			}
			else if(bsize<trate){
					drec[i]=bsize;
					ddrop[i]=q_data-bsize;
					dleft[i]=0;
					q_data=0;
				}
			else{
				drec[i]=trate;
				ddrop[i]=q_data-bsize;
				dleft[i]= bsize - trate;
				q_data = bsize - trate;	

			}

		}
	}
	public static void display(){
		System.out.println("Time\t Data send\t Data received\t Data left\t Data dropped");
		for(int i=0;i<time;i++){
			System.out.println(i +"\t\t" +inp[i] + "\t\t" +drec[i] +"\t\t" +dleft[i] +"\t\t" +ddrop[i] +"\t\t");
		}
	}

	public static void main(String [] args){
		input();
		cal();
		display();
	}
}
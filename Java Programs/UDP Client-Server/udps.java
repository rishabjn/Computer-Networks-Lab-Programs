import java.util.*;
import java.net.*;
import java.io.*;

class udps{

	public static void main(String[] args) throws IOException{
		int i=3000;
		String foo = new String("exit");
		while(true){
			InetAddress clientIP=InetAddress.getLocalHost();
			int clientPort=i;
			byte buf[]=new byte[1024];
			DatagramSocket ds = new DatagramSocket();
			BufferedReader dis = new BufferedReader(new InputStreamReader(System.in));
			System.out.println("server is ready.....");
			String str1 = new String();
			str1=dis.readLine();
			if(str1.equals(foo)){
				ds.close();
				break;
			}
			else{
				buf = str1.getBytes();
				DatagramPacket pkt = new DatagramPacket(buf, str1.length(),clientIP,clientPort);
				ds.send(pkt);
				i++;
			}
		}
	}
}
import java.net.*;
import java.io.*;
import java.util.*;

class tcpc{
	public static void main(String[] args) throws IOException {
		
		Socket sock = new Socket("127.0.0.1",3000);
		System.out.println("enter file name");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String fname = br.readLine();
		OutputStream os=sock.getOutputStream();
		PrintWriter pwrite = new PrintWriter(os,true);
		pwrite.println(fname);
		InputStream is = sock.getInputStream();
		BufferedReader sr = new BufferedReader(new InputStreamReader(is));
		String str;
		while((str=sr.readLine())!=null){
			System.out.println(str);

		}
		pwrite.close();
		sock.close();
		br.close();
	}
}
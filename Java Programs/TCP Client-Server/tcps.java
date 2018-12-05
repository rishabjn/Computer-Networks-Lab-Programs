import java.io.*;
import java.net.*;
import java.util.*;
class tcps{
	public static void main(String[] args) throws IOException {
	
		ServerSocket ser = new ServerSocket(3000);
		System.out.println("server is ready...");
		Socket sock=ser.accept();
		System.out.println("conn is done...");
		InputStream is = sock.getInputStream();
		BufferedReader br = new BufferedReader(new InputStreamReader(is));
		OutputStream os =sock.getOutputStream();
		PrintWriter pwrite = new PrintWriter(os,true);
		String str;
		String fname = br.readLine();
		File fp = new File(fname);
		if(!fp.exists()){
			pwrite.println("file does not exist");
		}
		else{
			BufferedReader bf = new BufferedReader(new FileReader(fname));
			while((str = bf.readLine())!=null){
				pwrite.println(str);
			}
			bf.close();
		}
		sock.close();
		ser.close();
		pwrite.close();
	}
}
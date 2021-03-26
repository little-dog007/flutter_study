package io.flutter.plugins;

import android.net.IpSecManager;
import android.util.Log;
import android.widget.EditText;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.net.Socket;

public class DownloadUtil {
    static String tag = "DOWNLOADUTIL";
    static DownloadUtil instance = null;
    String path = "";
    public void setPath(String str){
        path = str;
    }
    public DownloadUtil(){}

    public static DownloadUtil getInstance(){
        if(instance == null){
            instance = new DownloadUtil();
        }
        return instance;
    }

    public class Header{
        String CONTENT_LENGTH = "Content-length";
        private int content_length = 0;
        public void parseHeader(String str){
            if(str.isEmpty()){
                return;
            }
            if(str.contains(CONTENT_LENGTH)){
//                content_length = Integer.parseInt(str);
//                Log.i(tag,""+content_length);
            }
        }

    }

    public void DownFile() throws IOException {
        try {
            Log.d(tag, "start download");
            Socket socket = new Socket("10.90.185.207", 8000);

            OutputStream outputStream = socket.getOutputStream();
            String str = "GET / HTTP/1.1\n";
            outputStream.write(str.getBytes("utf-8"));
            outputStream.flush();

            InputStream in = socket.getInputStream();
            InputStreamReader isr = new InputStreamReader(in);
            BufferedReader buf = new BufferedReader(isr);

            String respone = buf.readLine();
            Header header = new Header();
            while(!respone.isEmpty()){
                Log.i(tag,respone);
                header.parseHeader(respone);
                respone = buf.readLine();

            }

//            InputStream in = socket.getInputStream();
//            DataInputStream datains = new DataInputStream(in);
//
            File file = new File(path,"/test.zip");
            RandomAccessFile raf = new RandomAccessFile(file, "rwd" );
            byte buff[] = new byte[8192];
            while(true){
                int read = 0;
                read = in.read(buff);
                if(read == -1){
                    break;
                }
                raf.write(buff);
            }






        } catch (Exception e) {
            e.printStackTrace();
        }

    }

     public void DownFileAsync() {
        Runnable networkTask = new Runnable() {
            @Override
            public void run() {
                try {
                    DownFile();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };

        new Thread(networkTask).start();
    }
}




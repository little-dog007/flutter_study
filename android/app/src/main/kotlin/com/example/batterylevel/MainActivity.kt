package com.example.batterylevel


import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.DownloadUtil
import io.flutter.plugins.PluginManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    private val CHANNEL1 = "com.jzhu.jump/plugin"
    private val CHANNEL2 = "plugins.flutter.io/path_provider";
    private  var  application_ = application;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        application_ = application;
        PluginManager.getInstance().init(application);
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler{ call, result->
            if(call.method == "getBatteryLevel"){
                val batteryLevel = getBatteryLevel();

                if(batteryLevel != -1){
                    result.success(batteryLevel);
                }else{
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                }
            }else{
                result.notImplemented();
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL1).setMethodCallHandler{ call, result->
            if(call.method.equals("loadPlugin")){
                var text:String? = call.argument("app_name");
                val apk_path = this.application_.filesDir.absolutePath +"/unzip/";
                Log.d("test","apk_path:" + apk_path);
                Log.d("test","text "+ text);
                val path: String = AssetUtil.copyAssetToCache(this@MainActivity, text,apk_path)
                PluginManager.getInstance().loadPluginApk(path)
                Log.d("test","loadPlugin success");

            }else if(call.method.equals("startPlugin")){
                // 先跳到代理Activity，由代理Activity展示真正的Activity内容
//                PluginManager.getInstance().gotoActivity(this@MainActivity,
//                        PluginManager.getInstance().packageInfo.activities[0].name)
                var text:String? = call.argument("app_name");
//                var intent:Intent = Intent(activity, TwoActivity::class.java);
//                intent.putExtra(TwoActivity.VALUE, text);
//                activity.startActivity(intent);
                //跳转到指定Activity
                var  intent:Intent = Intent(activity, OneActivity::class.java);
                activity.startActivity(intent);
                Log.d("test","startPlugin success");
            }
            else {
                result.notImplemented();
            }
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2).setMethodCallHandler{ call, result->
            if(call.method == "getApplicationDocumentsDirectory"){
                val batteryLevel = getBatteryLevel();
                val path = this.application_.filesDir;
                if(path!= null){
                    result.success(path.absolutePath);
                }else{
                    result.error("UNAVAILABLE", "Battery level not available.", null);
                }
            }else{
                result.notImplemented();
            }
        }
        
        
        
        

       
    }
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }





}

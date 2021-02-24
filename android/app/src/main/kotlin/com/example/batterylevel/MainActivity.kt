package com.example.batterylevel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.os.PersistableBundle
import android.view.ActionMode


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.FlutterPluginJumpToAct
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    private val CHANNEL1 = "com.jzhu.jump/plugin"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
            call,result->
            if(call.method == "getBatteryLevel"){
                val batteryLevel = getBatteryLevel();

                if(batteryLevel != -1){
                    result.success(batteryLevel);
                }else{
                    result.error("UNAVAILABLE","Battery level not available.",null);
                }
            }else{
                result.notImplemented();
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL1).setMethodCallHandler{
            call,result->
            //接收来自flutter的指令oneAct
            if (call.method.equals("oneAct")) {

                //跳转到指定Activity
                var  intent:Intent = Intent(activity, OneActivity::class.java);
                activity.startActivity(intent);

                //返回给flutter的参数
                result.success("success");
            }
            //接收来自flutter的指令twoAct
            else if (call.method.equals("twoAct")) {

                //解析参数
                var text:String? = call.argument("flutter");

                //带参数跳转到指定Activity
                var intent:Intent = Intent(activity, TwoActivity::class.java);
                intent.putExtra(TwoActivity.VALUE, text);
                activity.startActivity(intent);

                //返回给flutter的参数
                result.success("success");
            }
            else {
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

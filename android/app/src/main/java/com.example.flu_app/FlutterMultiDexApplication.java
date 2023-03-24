package com.example.flu_app;

import androidx.multidex.MultiDexApplication;
import io.flutter.view.FlutterMain;

public class FlutterMultiDexApplication extends MultiDexApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }
}
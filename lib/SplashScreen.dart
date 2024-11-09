import 'dart:convert';
import 'dart:io';
import 'package:dealsdray/Login.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  Map<String, dynamic> app = {};
  Map<String, dynamic> deviceData = {};
  @override
  void initState() {
    super.initState();
    getLocalIPAddress();
    getAppData();
    InstallAndUninstallTimestamps();
    getDeviceDetails();
    getall();
  }

  Future<String> getLocalIPAddress() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }
      return 'No IPv4 address found';
    } catch (e) {
      print("Failed to get IP address: $e");
      return 'Error fetching IP address';
    }
  }

  Future InstallAndUninstallTimestamps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentTime = DateTime.now();
    String currentTimestamp = currentTime.toIso8601String();
    print(currentTimestamp);
    await prefs.setString('installTimestamp', currentTimestamp);
      await prefs.setString('uninstallTimestamp', currentTimestamp);
  }
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<Map<String, dynamic>> getAppData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    app['version'] = await getAppVersion();
    app['installTimestamp'] = prefs.getString('installTimestamp');
    app['uninstallTimestamp'] = prefs.getString('uninstallTimestamp');
    print(app);

    return app;
  }

  Future<Map<String, dynamic>> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData['deviceType'] = "android";
      deviceData['deviceId'] = androidInfo.id;
      deviceData['deviceName'] = androidInfo.model;
      deviceData['deviceOSVersion'] = androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData['deviceType'] = "iOS";
      deviceData['deviceId'] = iosInfo.identifierForVendor;
      deviceData['deviceName'] = iosInfo.name;
      deviceData['deviceOSVersion'] = iosInfo.systemVersion;
    }

    deviceData['deviceIPAddress'] = await getLocalIPAddress();

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      deviceData['lat'] = null;
      deviceData['long'] = null;
      return deviceData;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        deviceData['lat'] = null;
        deviceData['long'] = null;
        return deviceData;
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    deviceData['lat'] = position.latitude;
    deviceData['long'] = position.longitude;
    print(deviceData);

    return deviceData;
  }

  var sample={};
  Future getall() async{
    final response = await http.post(Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/device/add"),
    headers: {
      "content-type":"application/json"
    },
    body: jsonEncode(
        {
          "deviceType": deviceData['deviceType'],
          "deviceId": deviceData['deviceId'],
          "deviceName": deviceData['deviceName'],
          "deviceOSVersion": deviceData['deviceOSVersion'],
          "deviceIPAddress":  deviceData['deviceIPAddress'],
          "lat": deviceData['lat'],
          "long": deviceData['long'],
          "buyer_gcmid": "",
          "buyer_pemid": "",
          "app": {
            "version": app['version'],
            "installTimeStamp": app['installTimeStamp'],
            "uninstallTimeStamp": app['uninstallTimeStamp'],
            "downloadTimeStamp": app['installTimeStamp']
          }
        }
    )
    );
    print(response.statusCode);
    if(response.statusCode==200||response.statusCode==201){
      sample = jsonDecode(response.body);
      print(sample);
      print(response.body);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login(deviceId: deviceData['deviceId'],)));
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

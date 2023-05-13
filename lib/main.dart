import 'package:flutter/material.dart';
import 'package:kelompok_3/screens/register.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());  //sebelum memulai flutter run pastikan menjalankan dart pub get terlebih dahulu saat pertama kali membuka file ini
}
/* README =================================================================
* jika banyak err itu dikarenakan flutter belum sepenuhnya terinstall, pastikan menjalankan dart pub get terlebih dahulu dan pastikan koneksi internet lancar jaya
* pastikan juga untuk menggunakan laravel yang  diberikan dan setup env file dan buat database baru, lalu run dengan port 8081 dengan perintah php artisan serve --port=8001 (baca README_FIRST.md di folder laravel)
* jika menggunakan port lain selain 8081 atau menggunakan xampp maka ganti url yang berada didalam file api.dart yang berada di lib>network>api.dart dengan url yang berada diatas chrome
* file ini telah diuji coba dan dapat berjalan sepeuhnya, saat penulisan command ini || 1.26.42 am || 13/05/2023 ||
*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
          brightness: Brightness.dark, accentColor: Colors.blueAccent),
      themeMode: ThemeMode.dark,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  late SharedPreferences sharedPreferences;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

void _checkIfLoggedIn() async {
  sharedPreferences = await SharedPreferences.getInstance(); // membuat instance SharedPreferences
  var token = sharedPreferences.getString('token'); // mengambil token dari SharedPreferences
  if (token != null) { // cek jika token tidak null
    if (mounted) { // cek jika widget sudah di-mounting
      setState(() { // mengubah state isAuth menjadi true
        isAuth = true;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) { // perbandingan sederhana dengan isAuth yang sudah dikondisikan tadi diatas
      child = Home();
    } else {
      child = Register();
    }

    return Scaffold(
      body: child,
    );
  }
}

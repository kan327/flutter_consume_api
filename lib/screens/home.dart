import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kelompok_3/network/api.dart';
import 'dart:convert';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
// inisialisasi variabel isLoading dengan false
  bool isLoading = false;

// inisialisasi sharedPreferences dengan late keyword agar tidak perlu diinisialisasi secara langsung
  late SharedPreferences sharedPreferences;

// inisialisasi variabel name dengan null, agar dapat diubah nilainya nanti saat proses loading selesai
  String? name = "loading...";
  late String token;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

// method untuk mengambil data user dari SharedPreferences
  _loadUserData() async {
    // men-set state isLoading menjadi true untuk menampilkan widget loading
    setState(() {
      isLoading = true;
    });
    // mengambil instance SharedPreferences untuk digunakan
    sharedPreferences = await SharedPreferences.getInstance();
    // mengambil data userName dari SharedPreferences dan menyimpannya ke dalam variabel name
    name = sharedPreferences.getString('userName');
    token = sharedPreferences.getString('token').toString();
    // men-set state isLoading menjadi false untuk menghilangkan widget loading
    setState(() {
      isLoading = false;
    });
  }

  // Membuat fungsi _showMsg untuk menampilkan pesan pada snackbar
  _showMsg(String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff151515),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff151515),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Hello, ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    name ??
                        '', // mengambil nilai name, atau string kosong ('') jika null
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

void logout() async {
  if (sharedPreferences != null) { // cek apakah shared preference sudah diinisialisasi
    final res = await Network().postRequest( // membuat request HTTP POST menggunakan class Network
      route: '/logout', // alamat endpoint logout
      data: {}, // data kosong karena logout tidak memerlukan data
      token: token, // menambahkan token untuk otorisasi
    );
    final result = jsonDecode(res.body); // mengubah hasil response ke dalam bentuk JSON
    if (result['status'] == 200) { // jika status response 200 (OK)
      _showMsg(result['message']); // menampilkan pesan sukses pada user
      sharedPreferences.clear(); // menghapus data shared preference
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        // melakukan perpindahan halaman ke halaman Login
        builder: (context) => Login(),
      ));
    } else { // jika status response tidak 200 (error)
      _showMsg(result['message']); // menampilkan pesan error pada user
    }
  }
}

}

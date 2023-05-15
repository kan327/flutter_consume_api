import 'package:flutter/material.dart';
import 'package:kelompok_3/network/api.dart';
import 'register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
// Mendeklarasikan beberapa variabel dan state untuk digunakan di dalam widget
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email, password;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;

// Membuat fungsi showHide untuk menampilkan atau menyembunyikan password
  showHide() {
    setState(() {
      _secureText = !_secureText;
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
      key: _scaffoldKey,
      backgroundColor: Color(0xff151515),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 72),
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                color: Colors.white10,
                margin: EdgeInsets.only(top: 86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 18),
                        TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Email",
                            ),
                            initialValue: "qwerty5@gmail.com", // remove me!
                            validator: (emailValue) {
                              // Fungsi validator akan dipanggil saat user submit form.
                              // Pada bagian ini, kita melakukan validasi terhadap input email.
                              // Jika email kosong atau null, maka validator akan mengembalikan string error 'Please enter your email'.
                              // Jika tidak, kita akan menyimpan nilai email ke dalam variable email.
                              // Lalu kita return null untuk menandakan bahwa input email sudah valid.
                              if (emailValue?.isEmpty ?? true) {
                                return 'Please enter your email';
                              }
                              email = emailValue;
                              return null;
                            }),
                        SizedBox(height: 12),
                        TextFormField(
                            cursorColor: Colors.blue,
                            initialValue: "qwerty", // remove me!
                            keyboardType: TextInputType.text,
                            obscureText: _secureText,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            validator: (passwordValue) {
                              // penjelasannya hampir sama dengan penjelasan di line sekitar 74 - 78
                              if (passwordValue?.isEmpty ?? true) {
                                return 'Please enter your password';
                              }
                              password = passwordValue;
                              return null;
                            }),
                        SizedBox(height: 12),
                        ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            child: Text(
                              _isLoading ? 'Proccessing..' : 'Login',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              _login(); //minjilinkin fingsi ligin siit simiwi inpit tidik null
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Does'nt have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Register(),
                      ));
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    // mendefinisikan method _login() yang bersifat asynchronous
    setState(() {
      // mengubah nilai variabel _isLoading menjadi true
      _isLoading = true;
    });

    var data = {
      'email': email.toString(),
      'password': password.toString()
    }; // mendefinisikan sebuah variabel data yang berisi email dan password yang dikirimkan ke server

    final res = await Network().postRequest(
        route: '/login',
        data: data); // melakukan request POST ke endpoint /login pada server dengan menggunakan data yang sudah didefinisikan sebelumnya
    final response = jsonDecode(res.body); // mengubah respon dari server yang diterima JSON format menjadi object atau data

    if (response['status'] == 200) {
      // jika status respon dari server adalah 200, maka login berhasil
      _showMsg(response['message']
          .toString()); // menampilkan pesan berhasil dengan menggunakan method _showMsg()
      SharedPreferences preferences = await SharedPreferences
          .getInstance(); // membuat instance dari class SharedPreferences
      await preferences.setInt(
          "userId",
          response['data']
              ['id']); // menyimpan id user ke dalam SharedPreferences
      await preferences.setString(
          "userName",
          response['data']
              ['name']); // menyimpan nama user ke dalam SharedPreferences
      await preferences.setString(
          "userEmail",
          response['data']
              ['email']); // menyimpan email user ke dalam SharedPreferences
      await preferences.setString("token",
          response['token']); // menyimpan token user ke dalam SharedPreferences
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        // melakukan perpindahan halaman ke halaman Home
        builder: (context) => Home(),
      ));
    } else {
      // jika status respon dari server bukan 200, maka login gagal
      _showMsg(response[
          'message']); // menampilkan pesan gagal dengan menggunakan method _showMsg()
    }

    print(jsonDecode(res
        .body)); // menampilkan body dari respon server dalam bentuk JSON pada console
    setState(() {
      // mengubah nilai variabel _isLoading menjadi false
      _isLoading = false;
    });
  }
}

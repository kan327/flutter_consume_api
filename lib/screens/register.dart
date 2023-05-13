import 'package:flutter/material.dart';
import 'login.dart';
import 'package:kelompok_3/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _secureText = true;
  late String name, email, password;

  showHide() {
    setState(() {// membuat fitur hide password di tampilan 
      _secureText = !_secureText;
    });
  }

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
                          "Register",
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
                              hintText: "Full Name",
                            ),
                            validator: (nameValue) {
                              if (nameValue?.isEmpty ?? true) {
                                return 'Please enter your full name';
                              }
                              name = nameValue!;
                              return null;
                            }),
                        SizedBox(height: 12),
                        TextFormField(
                            cursorColor: Colors.blue,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Email",
                            ),
                            validator: (emailValue) {
                              if (emailValue?.isEmpty ?? true) {
                                return 'Please enter your email';
                              }
                              email = emailValue!;
                              return null;
                            }),
                        SizedBox(height: 12),
                        TextFormField(
                            cursorColor: Colors.blue,
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
                              if (passwordValue?.isEmpty ?? true) {
                                return 'Please enter your password';
                              }
                              password = passwordValue!;
                              return null;
                            }),
                        SizedBox(height: 12),
                        ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            child: Text(
                              _isLoading ? 'Proccessing..' : 'Register',
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
                              _register(); //minjilinkin fingsi rigirtir siit simiwi inpit tidik null
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
                    "Already have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Login(),
                    ));},
                    child: Text(
                      'Login',
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

void _register() async {
  setState(() {
    _isLoading = true;
  });
  var data = {'name': name, 'email': email, 'password': password}; // membuat objek data yang berisi name, email, dan password untuk dikirim ke server
  final res = await Network().postRequest(route: '/register', data: data); // mengirim data ke server dengan metode post
  final response = jsonDecode(res.body); // mengkonversi response server dari bentuk json ke bentuk object atau data
  if (response['status'] == 200) { // jika response dari server adalah 200 OK
    _showMsg(response['message']); // menampilkan pesan sukses
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Login(),
    )); // navigasi ke halaman login
  }

  print(jsonDecode(res.body)); // mencetak response server
  setState(() {
    _isLoading = false;
  });
}

}

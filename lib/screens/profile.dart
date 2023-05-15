import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:kelompok_3/network/api.dart';
import 'package:kelompok_3/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final user;
  const Profile({super.key, this.user = 'not found'});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var id;
  late String name = '';
  late String email = '';
  late String token = '';
  late dynamic user;
  bool isEditing = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  _showMsg(String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  void _update() async {
    setState(() {
      // mengubah nilai variabel _isLoading menjadi true
      _isLoading = true;
    });

    var data = {
      'id': user['id'],
      'name': name.toString(),
      'email': email.toString(),
      'password': 'qwerty',
    }; // mendefinisikan sebuah variabel data yang berisi email dan password yang dikirimkan ke server

    // mengambil instance SharedPreferences untuk digunakan
    sharedPreferences = await SharedPreferences.getInstance();
    // mengambil data userName dari SharedPreferences dan menyimpannya ke dalam variabel name
    token = sharedPreferences.getString('token').toString();

    final res = await Network().postRequest(
        route: '/update',
        data: data,
        token:
            token); // melakukan request POST ke endpoint /login pada server dengan menggunakan data yang sudah didefinisikan sebelumnya
    final response = jsonDecode(res
        .body); // mengubah respon dari server yang diterima JSON format menjadi object atau data
    if (response['status'] == 200) {
      user['id'] = response['data']['id'];
      user['name'] = response['data']['name'];
      user['email'] = response['data']['email'];
    }
    setState(() {
      // mengubah nilai variabel _isLoading menjadi true
      _isLoading = false;
    });
    _showMsg(response['message'].toString());
    print(
        "response.toString() =================================================================");
    print(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isEditing? Colors.blueAccent : Color(0xFF1E1E1E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(isEditing? 'Mengedit' : 'Info Lengkap'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isEditing
                      ? Form(
                        key: _formKey,
                        child: Column(
                            children: [
                              TextFormField(
                                cursorColor: Colors.blue,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  hintText: "ID",
                                ),
                                initialValue: "${user['id']}",
                                enabled: false, // set to false to make it readonly
                              ),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                  ),
                                  initialValue: "${user['name']}", // remove me!
                                  validator: (nameValue) {
                                    if (nameValue?.isEmpty ?? true) {
                                      return 'Please enter your name';
                                    }
                                    name = nameValue.toString();
                                    return null;
                                  }),
                              TextFormField(
                                  cursorColor: Colors.blue,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  initialValue: "${user['email']}", // remove me!
                                  validator: (emailValue) {
                                    if (emailValue?.isEmpty ?? true) {
                                      return 'Please enter your name';
                                    }
                                    email = emailValue.toString();
                                    return null;
                                  }),
                            ],
                          ),
                      )
                      : Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                  children: [
                                    TextFormField(
                                      cursorColor: Colors.blue,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "ID",
                                      ),
                                      initialValue: "${user['id']}",
                                      enabled: false, // set to false to make it readonly
                                    ),
                                    TextFormField(
                                        cursorColor: Colors.blue,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: "Name",
                                        ),
                                        initialValue: "${user['name']}", // remove me!
                                        enabled: false, // set to false to make it readonly
                                        validator: (nameValue) {
                                          if (nameValue?.isEmpty ?? true) {
                                            return 'Please enter your name';
                                          }
                                          name = nameValue.toString();
                                          return null;
                                        }
                                    ),
                                    TextFormField(
                                      cursorColor: Colors.blue,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                      ),
                                      initialValue: "${user['email']}", // remove me!
                                      enabled: false, // set to false to make it readonly
                                      validator: (emailValue) {
                                        if (emailValue?.isEmpty ?? true) {
                                          return 'Please enter your name';
                                        }
                                        email = emailValue.toString();
                                        return null;
                                      }
                                    ),
                                  ],
                                ),
                            )
                          ],
                        ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        // Event onTap akan diisi dengan kode yang diinginkan
                        _formKey.currentState?.validate();
                        // // if (_formKey.currentState?.validate() == true) {
                        // // }
                        if (isEditing) _update();
                        setState(() {
                          isEditing = !isEditing;
                        });
                        print("${id}, ${name}, ${email}, ${token}");
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        minimumSize: Size(double.infinity, 0),
                      ),
                      child: Text(isEditing ? "Simpan" : "Edit"),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

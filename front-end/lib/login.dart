import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_end_ing_software/InitialPage.dart';
import 'package:front_end_ing_software/model/LoginF.dart';
import 'package:front_end_ing_software/model/User.dart';
import 'package:front_end_ing_software/register.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

Loginf loginf = new Loginf(userType: "", email: "", password: "");

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAdmin = false;

  Future<void> verificaLogin() async {
    String userType = _isAdmin ? 'Admin' : 'Regular_User';
    print(
        'Username: ${_usernameController.text}, Password: ${_passwordController.text}, Tipo di utente: $userType');
    print(_isAdmin);
    print(userType);
    loginf = new Loginf(
        userType: userType,
        email: _usernameController.text,
        password: _passwordController.text);

    print(loginf.toJson().toString());

    final response = await http.post(
      Uri.parse('http://localhost:8080/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginf.toJson()),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      User user = User(
          email: _usernameController.text,
          password: _passwordController.text,
          UserType: userType);

      _usernameController.text = "";
      _passwordController.text = "";
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InitialPage(
              flag: _isAdmin,
              user: user,
            ),
          ));

      if (result != null) {
        setState(() {
          _isAdmin = result['flag'] ?? _isAdmin;
        });
      }
    } else {
      // Mostra un messaggio di errore all'utente
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Errore di Login"),
            content: Text(
                "Utente non presente. Procedere prima con la registrazione"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Benvenuto!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade400,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tipo di Utente:',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          Text('Normale'),
                          Switch(
                            value: _isAdmin,
                            onChanged: (bool value) {
                              setState(() {
                                _isAdmin = value;
                              });
                            },
                            activeColor: Colors.blue.shade200,
                          ),
                          Text('Admin'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: verificaLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    child: Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    child: Text(
                      'Registrati',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

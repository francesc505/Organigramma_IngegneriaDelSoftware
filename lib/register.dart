import 'package:flutter/material.dart';
import 'package:front_end_ing_software/login.dart';
import 'package:front_end_ing_software/model/LoginF.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAdmin = false;

  Future<void> registerUser() async {
   String userType = _isAdmin ? 'Admin' : 'Regular_User';

    print(
        'Username: ${_usernameController.text}, Password: ${_passwordController.text}, Tipo di utente: $userType');

    Loginf loginf = new Loginf(
        userType: userType,
        email: _usernameController.text,
        password: _passwordController.text);

    final response = await http.post(
      Uri.parse('http://localhost:8080/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginf),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Registrazione Completata"),
            content: Text("Utente registrato con successo!"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ));
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Errore di Registrazione"),
            content: Text("Registrazione fallita, riprova."),
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
      appBar: AppBar(
        title: Text('Registrazione'),
        backgroundColor: Colors.teal, // Colore dell'AppBar
      ),
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
                    'Registrati!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
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
                            activeColor: Colors.teal,
                          ),
                          Text('Admin'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Colore del bottone
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

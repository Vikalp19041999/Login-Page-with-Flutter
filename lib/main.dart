import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

final String domain = "192.168.0.123:3000";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  //*ANIMATION IN FLUTTER LOGO
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  //*CONNECTION WITH API
  String email_text, pass_text;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool rememberMe = false;
  Future<Null> setLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('isLogin', rememberMe);
  }

  Future<http.Response> Login() async {
    Map body = {'user': email.text.toString(), 'pass': pass.text.toString()};
    return http
        .post('http://$domain/login', body: body)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      print(response.body);
    });
  }

  @override
  //*THE UI
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Image(
          image: AssetImage('assets/flutter.png'),
          fit: BoxFit.fill,
          color: Colors.black87,
          colorBlendMode: BlendMode.darken,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlutterLogo(
              size: _iconAnimation.value * 50,
            ),
            Theme(
              data: new ThemeData(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.teal,
                  inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                  ))),
              child: Form(
                child: Container(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: email,
                        onChanged: (a) {
                          email_text = null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: pass,
                        onChanged: (a) {
                          pass_text = null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      MaterialButton(
                        height: 40,
                        minWidth: 100,
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Text('Login'),
                        splashColor: Colors.redAccent,
                        onPressed: () {
                          setLogin();
                          if (email.text == '' && pass.text == '') {
                            setState(() {
                              email_text = 'Enter Email';
                              pass_text = 'Enter Password';
                            });
                          } else if (email.text == '') {
                            setState(() {
                              email_text = 'Enter Email';
                            });
                          } else if (pass.text == '') {
                            setState(() {
                              pass_text = 'Enter Password';
                            });
                          } else {
                            Login();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

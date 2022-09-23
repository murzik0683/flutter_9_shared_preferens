import 'package:flutter/material.dart';
import 'package:flutter_lesson_13/screens/reristration_screen.dart';
import 'package:flutter_lesson_13/screens/user_profile.dart';
import 'package:flutter_lesson_13/widget/input_decoration.dart';
import 'package:flutter_lesson_13/widget/text_button_class.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String username = '';
  String password = '';

  bool _obscureText = true;
  bool _isChecked = false;

  Future getValidation(String name, String pass) async {
    bool getVal = false;
    final SharedPreferences storage = await SharedPreferences.getInstance();
    if ((storage.getString('name_key') == name &&
        storage.getString('password_key') == pass)) {
      getVal = true;
      Get.offAll(
        () => const UserProfile(),
      );
      Fluttertoast.showToast(
          fontSize: 22,
          msg: 'Login Successful',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.green,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    } else {
      getVal = false;
      Fluttertoast.showToast(
          fontSize: 22,
          msg: 'Login Invalid',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    }
    return getVal;
  }

  Future<void> remember(bool isChecked) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setBool('isChecked', isChecked);
  }

  Future<void> rememberFields() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    bool getValidation = storage.getBool('isChecked') ?? false;
    if (getValidation == true) {
      setState(() {});
      // nameController =
      //     TextEditingController(text: storage.getString('name_key'));
      passwordController =
          TextEditingController(text: storage.getString('password_key'));
      _isChecked = true;
    }
  }

  @override
  void initState() {
    super.initState();
    rememberFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextHello(),
                _buildSpacer(50),
                _buildLoginForm(),
                _buildSpacer(10),
                _buildRememberMeCheckBox(),
                _buildSpacer(15),
                _buildTextButton(),
                _buildSpacer(25),
                _buildTextRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextHello() {
    return Column(
      children: const [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hello',
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Sign in to your account',
            style: TextStyle(fontSize: 20, color: Colors.black45),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: inputDecorationForm(const Text('Login'),
              prefixIcon: const Icon(Icons.mail)),
          onChanged: (value) {
            username = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please enter your username';
            return null;
          },
        ),
        _buildSpacer(15),
        TextFormField(
          controller: passwordController,
          obscureText: _obscureText,
          decoration: inputDecorationForm(
            const Text('Password'),
            prefixIcon: const Icon(Icons.vpn_key),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
                  Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          onChanged: (value) {
            password = value;
          },
          validator: (value) {
            if (value!.isEmpty) return 'Please enter your password';
            return null;
          },
        ),
        _buildSpacer(15),
      ],
    );
  }

  Widget _buildRememberMeCheckBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Remember password'),
        Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
            })
      ],
    );
  }

  Widget _buildTextButton() {
    return TextButtonClass(
      title: 'Login',
      function: () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            getValidation(nameController.text, passwordController.text)
                .then((value) {
              if (value == true) {
                remember(_isChecked);
                Get.offAll(() => const UserProfile());
              } else {
                Get.offAll(() => const RegistrationScreen());
              }
            });
          });
        }
      },
    );
  }

  Widget _buildTextRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Do not have an Account?',
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Get.offAll(() => const RegistrationScreen());
          },
          child: const Text(
            '  Register Here',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
  }
}

Widget _buildSpacer(double space) {
  return SizedBox(
    height: space,
  );
}

import 'package:desafio/screens/init/init_screen.dart';
import 'package:desafio/screens/login/widgets/app_title_widget.dart';
import 'package:desafio/screens/login/widgets/go_to_signin_button.dart';
import 'package:desafio/screens/login/widgets/input_field_widget.dart';
import 'package:desafio/screens/login/widgets/submit_button_widget.dart';
import 'package:desafio/screens/signin/signin_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formCtrl = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController(text: '');
  final TextEditingController _passwordCtrl = TextEditingController(text: '');

  void _login() {
    if (_formCtrl.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InitScreen(),
        ),
      );
    }
  }

  void _goToSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formCtrl,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppTitleWidget(),
                  const SizedBox(height: 50.0),
                  InputFieldWidget(
                    controller: _emailCtrl,
                    hintText: 'E-mail',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                    isObscure: false,
                    keyBoardType: TextInputType.emailAddress,
                    maxLength: 45,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser vazio';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'E-mail inválido';
                      } else {
                        return null;
                      }
                    },
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 10.0),
                  InputFieldWidget(
                    controller: _passwordCtrl,
                    hintText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_rounded),
                    isObscure: true,
                    keyBoardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser vazio';
                      } else if (value.length < 8) {
                        return 'Senha inválida';
                      } else {
                        return null;
                      }
                    },
                    onSubmit: (_) => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 30.0),
                  SubmitButtonWidget(
                    onPressed: _login,
                    buttonName: const Text(
                      'Entrar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  GoToSignInButton(onPressed: _goToSignIn),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

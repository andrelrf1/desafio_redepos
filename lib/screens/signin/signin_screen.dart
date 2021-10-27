import 'package:desafio/screens/login/widgets/input_field_widget.dart';
import 'package:desafio/screens/login/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formCtrl = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  void _signIn() {
    if (_formCtrl.currentState!.validate()) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Cadastrar'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formCtrl,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputFieldWidget(
                    controller: _nameCtrl,
                    hintText: 'Nome',
                    prefixIcon: const Icon(Icons.person_rounded),
                    isObscure: false,
                    keyBoardType: TextInputType.name,
                    maxLength: 50,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ficar vazio';
                      } else if (value.length < 5) {
                        return 'O nome precisa conter no minimo 5 caracteres';
                      } else {
                        return null;
                      }
                    },
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 10.0),
                  InputFieldWidget(
                    controller: _emailCtrl,
                    hintText: 'E-mail',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                    isObscure: false,
                    keyBoardType: TextInputType.emailAddress,
                    maxLength: 45,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ficar vazio';
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
                        return 'A senha é muito curta';
                      } else if (value != _confirmPasswordCtrl.text) {
                        return 'As senhas são diferentes';
                      } else {
                        return null;
                      }
                    },
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  ),
                  const SizedBox(height: 10.0),
                  InputFieldWidget(
                    controller: _confirmPasswordCtrl,
                    hintText: 'Comfirme a senha',
                    prefixIcon: const Icon(Icons.lock_rounded),
                    isObscure: true,
                    keyBoardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo não pode ser vazio';
                      } else if (value.length < 8) {
                        return 'A senha é muito curta';
                      } else if (value != _passwordCtrl.text) {
                        return 'As senhas são diferentes';
                      } else {
                        return null;
                      }
                    },
                    onSubmit: (_) => FocusScope.of(context).unfocus(),
                  ),
                  const SizedBox(height: 30.0),
                  SubmitButtonWidget(
                    onPressed: _signIn,
                    buttonName: const Text(
                      'Cadastar',
                      style: TextStyle(fontWeight: FontWeight.w600),
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

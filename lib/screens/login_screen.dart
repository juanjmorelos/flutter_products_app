import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decoration.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Iniciar Sesión', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: const _loginForm()
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
            ]
          ),
        )
      ),
   );
  }
}

class _loginForm extends StatelessWidget {
  const _loginForm({super.key});

  @override
  Widget build(BuildContext context) {
    
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                labelText: "Correo electrónico",
                borderColors: Colors.deepPurple,
                labelColor: Colors.grey,
                hintText: 'correo@example.com',
                icon: const Icon(Icons.email, color: Colors.deepPurple
                )
              ),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '') ? null : "Debe ingresar un correo electrónico válido";
              },
            ),
            const SizedBox(height: 30,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                labelText: "Contraseña",
                borderColors: Colors.deepPurple,
                labelColor: Colors.grey,
                icon: const Icon(Icons.lock, color: Colors.deepPurple),
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6) ? null : "La contraseña debe tener al menos 6 caracteres";
              },
            ),
            const SizedBox(height: 30,),
            MaterialButton(
              onPressed: loginForm.isLoading ? null : () async => validateForm(loginForm, context),
              minWidth: double.infinity,
              color: Colors.deepPurple,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              child: Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Text(loginForm.isLoading ? "" : "Iniciar Sesión"),
                  _ProgressBar(loginForm: loginForm)
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    super.key,
    required this.loginForm,
  });

  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width:  20,
      child: loginForm.isLoading ? const CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white,
        ),
        strokeWidth: 3,
      ) : null,
    );
  }
}

Future validateForm(LoginFormProvider loginForm, BuildContext context) async {
  FocusScope.of(context).unfocus();
  
  if(loginForm.isValidForm()) {
    loginForm.isLoading = true;
    if(loginForm.email == "admin@admin.com" && loginForm.password == "admin1") {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        loginForm.isLoading = false;
        Navigator.pop(context, "home");
      });
    } else {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        loginForm.isLoading = false;
        showSnackBar(context, "Correo o contraseña inválidas", null);
      });
    }
  }
}

void showSnackBar(BuildContext context, String text, SnackBarAction? action) {
  final snackBar = SnackBar(
    content: Text(text),
    action: action,
    duration: const Duration(milliseconds: 2500),
    elevation: 10,
    behavior: SnackBarBehavior.floating
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
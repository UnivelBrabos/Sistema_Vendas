import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabalho_vendas_univel/core/app_colors.dart';
import 'package:trabalho_vendas_univel/modules/auth/auth_controller.dart';
import 'package:trabalho_vendas_univel/widgets/social_login_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool rememberMe = false;
  bool _obscurePassword = true;

  final TextEditingController emailController    = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('savedEmail');
    final savedPass  = prefs.getString('savedPass');
    if (savedEmail != null && savedPass != null) {
      setState(() {
        emailController.text    = savedEmail;
        passwordController.text = savedPass;
        rememberMe = true;
      });
    }
  }

  Future<void> _onLogin() async {
    final email = emailController.text.trim().toLowerCase();
    final pass  = passwordController.text;

    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('savedEmail', email);
      await prefs.setString('savedPass', pass);
    } else {
      await prefs.remove('savedEmail');
      await prefs.remove('savedPass');
    }

    final authController = Modular.get<AuthController>();
    await authController.login(email, pass, context);
  }

  final String googleSvg =
      '''<svg version="1.1" width="20" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve">
<path style="fill:#FBBB00;" d="M113.47,309.408L95.648,375.94l-65.139,1.378C11.042,341.211,0,299.9,0,256
	c0-42.451,10.324-82.483,28.624-117.732h0.014l57.992,10.632l25.404,57.644c-5.317,15.501-8.215,32.141-8.215,49.456
	C103.821,274.792,107.225,292.797,113.47,309.408z"/>
<path style="fill:#518EF8;" d="M507.527,208.176C510.467,223.662,512,239.655,512,256c0,18.328-1.927,36.206-5.598,53.451
	c-12.462,58.683-45.025,109.925-90.134,146.187l-0.014-0.014l-73.044-3.727l-10.338-64.535
	c29.932-17.554,53.324-45.025,65.646-77.911h-136.89V208.176h138.887L507.527,208.176L507.527,208.176z"/>
<path style="fill:#28B446;" d="M416.253,455.624l0.014,0.014C372.396,490.901,316.666,512,256,512
	c-97.491,0-182.252-54.491-225.491-134.681l82.961-67.91c21.619,57.698,77.278,98.771,142.53,98.771
	c28.047,0,54.323-7.582,76.87-20.818L416.253,455.624z"/>
<path style="fill:#F14336;" d="M419.404,58.936l-82.933,67.896c-23.335-14.586-50.919-23.012-80.471-23.012
	c-66.729,0-123.429,42.957-143.965,102.724l-83.397-68.276h-0.014C71.23,56.123,157.06,0,256,0
	C318.115,0,375.068,22.126,419.404,58.936z"/>
</svg>''';

  

 @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),

            Center(
              child: Image.asset(
                'lib/assets/logo/spark_logo.jpg',
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Email',
              style: TextStyle(
                color: Color(0xFF151717),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Digite seu email',
                prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Senha',
              style: TextStyle(
                color: Color(0xFF151717),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Digite sua senha',
                prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: AppColors.primaryColor,
                      onChanged: (v) =>
                          setState(() => rememberMe = v ?? false),
                    ),
                    const Text(
                      'Lembre de mim',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // implementar recuperação de senha
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onLogin,  // chama o método que salva e faz login
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Column(
                children: [
                  const Text("Nao tem uma conta?"),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // implementar sign up
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Center(child: Text("Ou com")),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SocialLoginButton(
                    svgCode: googleSvg,
                    label: 'Google',
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}







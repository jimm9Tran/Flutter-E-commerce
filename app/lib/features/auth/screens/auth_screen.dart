import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/auth/services/auth_service.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordSUpController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordSInController = TextEditingController();

  bool isSignIn = true;
  double opacityLvl = 1.0;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordSUpController.dispose();
    _confirmPasswordController.dispose();
    _passwordSInController.dispose();
    super.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordSUpController.text,
        name: _nameController.text);
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordSInController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    myTextTheme = Theme.of(context).textTheme;

    return isSignIn
        ? GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SafeArea(
                child: Container(
                  height: mq.height,
                  width: mq.width,
                  decoration: const BoxDecoration(
                      gradient: GlobalVariables.loginPageGradient),
                  child: Padding(
                    padding: EdgeInsets.all(mq.width * .1),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: _signInFormKey,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                "assets/images/logo.png",
                                height: mq.height * .16,
                              ),
                            ),
                            SizedBox(height: mq.height * .03),
                            const Text("E-Shop",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 25)),
                            SizedBox(height: mq.height * .05),
                            CustomTextField(
                                controller: _emailController,
                                hintText: "Email"),
                            SizedBox(height: mq.height * .025),
                            CustomTextField(
                                isObscureText: true,
                                controller: _passwordSInController,
                                hintText: "Mật khẩu"),
                            SizedBox(height: mq.height * .01),
                            SizedBox(height: mq.height * .04),
                            AnimatedOpacity(
                              opacity: opacityLvl,
                              duration: const Duration(seconds: 1),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    opacityLvl = 0.5;
                                  });
                                  if (_signInFormKey.currentState!.validate()) {
                                    signInUser();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    minimumSize:
                                        Size(mq.width, mq.height * 0.08),
                                    backgroundColor: Colors.orange.shade700),
                                child: const Text("Đăng nhập"),
                              ),
                            ),
                            SizedBox(height: mq.height * .015),
                            SizedBox(height: mq.height * .015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Chưa có tài khoản?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                SizedBox(width: mq.width * .012),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSignIn = !isSignIn;
                                    });
                                  },
                                  child: Text(
                                    "Đăng ký",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade800,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SafeArea(
                child: Container(
                  height: mq.height,
                  width: mq.width,
                  decoration: const BoxDecoration(
                      gradient: GlobalVariables.loginPageGradient),
                  child: Padding(
                    padding: EdgeInsets.all(mq.width * .1),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: _signUpFormKey,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset("assets/images/logo.png",
                                  height: mq.height * .16),
                            ),
                            SizedBox(height: mq.height * .03),
                            const Text("Tạo tài khoản mới",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 25)),
                            SizedBox(height: mq.height * .03),
                            CustomTextField(
                                controller: _nameController,
                                hintText: "Họ và tên"),
                            SizedBox(height: mq.height * .01),
                            CustomTextField(
                                controller: _emailController,
                                hintText: "Email"),
                            SizedBox(height: mq.height * .01),
                            CustomTextField(
                                isObscureText: true,
                                controller: _passwordSUpController,
                                hintText: "Mật khẩu"),
                            SizedBox(height: mq.height * .01),
                            CustomTextField(
                                isObscureText: true,
                                controller: _confirmPasswordController,
                                hintText: "Xác nhận mật khẩu"),
                            SizedBox(height: mq.height * .04),
                            ElevatedButton(
                                onPressed: () {
                                  if (_signUpFormKey.currentState!.validate() &&
                                      _passwordSUpController.text ==
                                          _confirmPasswordController.text) {
                                    signUpUser();
                                    setState(() {
                                      isSignIn = !isSignIn;
                                    });
                                  }
                                  if (_signUpFormKey.currentState!.validate() &&
                                      _passwordSUpController.text !=
                                          _confirmPasswordController.text) {
                                    showSnackBar(
                                        context: context,
                                        text: "Mật khẩu không khớp");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    minimumSize:
                                        Size(mq.width, mq.height * 0.08),
                                    backgroundColor: Colors.orange.shade700),
                                child: const Text("Đăng ký")),
                            SizedBox(height: mq.height * .015),
                            SizedBox(height: mq.height * .015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Đã có tài khoản?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                SizedBox(width: mq.width * .012),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSignIn = !isSignIn;
                                    });
                                  },
                                  child: Text(
                                    "Đăng nhập",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade800,
                                        decoration: TextDecoration.underline,
                                        decorationStyle:
                                            TextDecorationStyle.solid),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_assets.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/modals/loading_modal.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/auth/model/auth_model.dart';
import 'package:read_quest/features/auth/repository/auth_repository.dart';
import 'package:read_quest/features/auth/views/register_screen.dart';
import 'package:read_quest/features/home/views/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (!formKey.currentState!.validate()) return;

    // Show loading before async gap
    LoadingModal.showLoadingModal(context);

    final authRepo = ref.read(authRepositoryProvider);
    final auth = AuthModel(
      uid: idController.text,
      password: passwordController.text,
    );

    final result = await authRepo.login(auth);

    if (!mounted) return;

    LoadingModal.hideLoadingModal(context);

    if (result.isSuccess) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Login Successfully',
      ).show();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const HomeScreen()),
      );
      return;
    }

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      desc: result.error,
    ).show();
  }

  @override
  dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width / 16),
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.appBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(size.width / 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  AppBorderSettings.borderRadius + 8,
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //? TOP LABELS
                    Text('Login Account', style: theme.textTheme.headlineLarge),
                    Gap(size.height / 60),
                    Text(
                      'Please enter your existing credentials.',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.textLabel,
                      ),
                    ),
                    Gap(size.height / 40),

                    //? TEXT FORM FIELDS
                    TextFormField(
                      controller: idController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'ID'),
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),

                    //? FORGOT PASSWORD
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          //TODO: CREATE FORGOT PASSWORD LOGIC
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    Gap(size.height / 60),

                    //? LOGIN BUTTON
                    PrimaryButton(label: 'Login', onPressed: login),

                    Gap(size.height / 60),

                    //? NAVIGATE TO SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.textLabel,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          ),
                          child: Text(
                            'Register',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

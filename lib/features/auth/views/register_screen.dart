import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_assets.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/modals/loading_modal.dart';
import 'package:read_quest/core/model/user_model.dart';
import 'package:read_quest/core/widgets/primary_button.dart';
import 'package:read_quest/features/auth/model/auth_model.dart';
import 'package:read_quest/features/auth/provider/show_password_toggle.dart';
import 'package:read_quest/features/auth/repository/auth_repository.dart';
import 'package:read_quest/features/auth/views/login_screen.dart';
import 'package:read_quest/features/membership/views/membership_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signup() async {
    if (!formKey.currentState!.validate()) return;

    LoadingModal.showLoadingModal(context);

    final authRepo = ref.read(authRepositoryProvider);

    final auth = AuthModel(
      uid: idController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    final user = UserModel(
      uid: idController.text,
      email: emailController.text,
      name: nameController.text,
    );

    final result = await authRepo.register(auth, user);

    if (!mounted) return;

    LoadingModal.hideLoadingModal(context);

    if (result.isSuccess) {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Registration Successfully',
      ).show();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => MembershipScreen()),
        (route) => false,
      );
    } else {
      await AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Failed',
        desc: result.error,
      ).show();
    }
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final showPassword = ref.watch(showPasswordToggleProvider);
    final togglePassword = ref.read(showPasswordToggleProvider.notifier);

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
                    Text(
                      'Create Account',
                      style: theme.textTheme.headlineLarge,
                    ),
                    Gap(size.height / 60),
                    Text(
                      'Please enter all required fields.',
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
                      validator: idValidator,
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: nameValidator,
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: emailValidator,
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: passwordValidator,
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: !showPassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => togglePassword.toggle(),
                          icon: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        labelText: 'Confirm Password',
                      ),

                      validator: confirmPasswordValidator,
                    ),

                    Gap(size.height / 60),

                    //? REGISTER BUTTON
                    PrimaryButton(label: 'Sign Up', onPressed: signup),

                    Gap(size.height / 60),

                    //? NAVIGATE TO lOGIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.textLabel,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(builder: (_) => LoginScreen()),
                            );
                          },

                          child: Text(
                            'Login',
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

  String? idValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ID';
    }
    return null;
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value != passwordController.text) {
      return 'Password does not match';
    }
    return null;
  }
}

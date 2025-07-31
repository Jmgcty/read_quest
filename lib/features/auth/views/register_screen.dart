import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:read_quest/core/const/app_assets.dart';
import 'package:read_quest/core/const/app_border_settings.dart';
import 'package:read_quest/core/const/app_colors.dart';
import 'package:read_quest/core/widgets/primary_button.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final formKey = GlobalKey<FormState>();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
                    Text('Register', style: theme.textTheme.headlineLarge),
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
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    Gap(size.height / 80),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                    ),

                    Gap(size.height / 60),

                    //? REGISTER BUTTON
                    PrimaryButton(
                      label: 'Sign Up',
                      onPressed: () {
                        //TODO: CREATE REGISTER LOGIC
                      },
                    ),

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
                            //TODO: CREATE LOGIN NAVIGATION LOGIC
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
}

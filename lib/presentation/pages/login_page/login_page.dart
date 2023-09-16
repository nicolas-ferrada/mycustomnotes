import 'package:flutter/material.dart';
import 'package:mycustomnotes/domain/services/auth_services.dart/auth_user_service_google_singin.dart';
import 'package:provider/provider.dart';

import '../../../domain/services/auth_services.dart/auth_user_service_email_password.dart';
import '../../../l10n/change_language.dart';
import '../../../l10n/l10n_export.dart';
import '../../../l10n/l10n_locale_provider.dart';
import '../../../utils/app_color_scheme/app_color_scheme.dart';
import '../../../utils/dialogs/change_language_dialog.dart';
import '../../../utils/enums/select_language_enum.dart';
import '../../../utils/exceptions/exceptions_alert_dialog.dart';
import '../../routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailLoginController = TextEditingController();
  final _passwordLoginController = TextEditingController();
  bool isPasswordHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailLoginController.dispose();
    _passwordLoginController.dispose();
    super.dispose();
  }

  getCurrentLanguage({
    required String language,
  }) {
    switch (language) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
    }
  }

  @override
  Widget build(BuildContext context) {
    String language = getCurrentLanguage(
        language: context.read<L10nLocaleProvider>().locale.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Custom Notes',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              changeLanguageWidget(language, context),
              emailUserInputWidget(context),
              passwordUserInputWidget(context),
              loginButtonWidget(context),
              forgotPasswordWidget(context),
              loginProvidersSeparationWidget(context),
              googleLoginButtonWidget(context),
              createAccountSeparationWidget(context),
              signUpWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget changeLanguageWidget(String language, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          try {
            final SelectLanguage? language = await showDialog<SelectLanguage?>(
              context: context,
              builder: (context) {
                return ChangeLanguageDialog(
                  context: context,
                );
              },
            );
            if (language != null && context.mounted) {
              await ChangeLanguage.changeLanguage(
                  context: context, language: language.lenguageId);
            }
          } catch (errorMessage) {
            // errorMessage is the custom message probably sent by the user configuration functions
            if (!context.mounted) return;

            ExceptionsAlertDialog.showErrorDialog(
                context: context, errorMessage: errorMessage.toString());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            language,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }

  Widget emailUserInputWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        controller: _emailLoginController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.email_textformfield_loginPage,
          prefixIcon: const Icon(Icons.mail),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColorScheme.purple(),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget passwordUserInputWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        controller: _passwordLoginController,
        obscureText: isPasswordHidden,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context)!.password_textformfield_loginPage,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              setState(() {
                isPasswordHidden = !isPasswordHidden;
              });
            },
            child: isPasswordHidden
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          ),
          suffixIconColor: Colors.grey.shade400,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColorScheme.purple()),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget loginButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 30,
          backgroundColor: AppColorScheme.darkPurple(),
          minimumSize: const Size(200, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () async {
          if (_emailLoginController.text.isEmpty ||
              _passwordLoginController.text.isEmpty) {
            ExceptionsAlertDialog.showErrorDialog(
              context: context,
              errorMessage:
                  AppLocalizations.of(context)!.unknown_empty_dialog_loginPage,
            );
            return;
          }

          try {
            await AuthUserServiceEmailPassword.logInInEmailPassword(
              email: _emailLoginController.text,
              password: _passwordLoginController.text,
              context: context,
            );
          } catch (errorMessage) {
            // errorMessage is the custom message sent by the firebase function.
            if (!context.mounted) return;

            ExceptionsAlertDialog.showErrorDialog(
                context: context, errorMessage: errorMessage.toString());
          }
        },
        child: Text(
          AppLocalizations.of(context)!.login_button_loginPage,
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, recoverPasswordPageRoute);
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppLocalizations.of(context)!.passwordRecover_richText_info_loginPage,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  Widget loginProvidersSeparationWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey.shade600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Text(AppLocalizations.of(context)!.or_text_separator_loginPage),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget googleLoginButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        onPressed: () async {
          try {
            await AuthUserServiceGoogleSignIn.logInGoogle(context);
          } catch (errorMessage) {
            // errorMessage is the custom message sent by the firebase function.
            if (!context.mounted) return;

            ExceptionsAlertDialog.showErrorDialog(
                context: context, errorMessage: errorMessage.toString());
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 22),
              child: Image(
                image: AssetImage("assets/google_icon.png"),
                height: 22,
                width: 22,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.googleButton_button_loginPage,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createAccountSeparationWidget(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        thickness: 1,
        color: Colors.white70,
      ),
    );
  }

  Widget signUpWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.signUp_text_info_loginPage,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.pushNamed(context, registerPageRoute),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              AppLocalizations.of(context)!.signUp_richText_loginPage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontStyle: FontStyle.italic,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

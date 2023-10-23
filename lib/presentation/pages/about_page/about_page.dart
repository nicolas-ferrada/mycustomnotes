import 'package:flutter/material.dart';
import 'package:mycustomnotes/l10n/l10n_export.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    privacyPolicy(context),
                    termsOfService(context),
                    softwareLicense(context),
                    thirdPartySoftware(context),
                    developerWebsite(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        AppLocalizations.of(context)!.about_text_aboutPage,
        style: const TextStyle(fontSize: 22),
      ),
    );
  }

  Widget widgetsStyle({
    required String title,
    String? subtitle,
    Function? onTapFunction,
  }) {
    return Column(
      children: [
        Divider(
          thickness: 0.8,
          color: Colors.grey.shade800,
        ),
        ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          subtitle: (subtitle != null)
              ? Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                )
              : const Text(''),
          onTap: () {
            if (onTapFunction != null) {
              onTapFunction();
            }
          },
        ),
        Divider(
          thickness: 0.8,
          color: Colors.grey.shade800,
        ),
      ],
    );
  }

  Widget privacyPolicy(context) {
    return widgetsStyle(
      title: AppLocalizations.of(context)!.privacyPolicyTitle_text_aboutPage,
      subtitle:
          AppLocalizations.of(context)!.privacyPolicySubtitle_text_aboutPage,
      onTapFunction: () {
        launchUrl(
          Uri.parse('https://mycustomnotes.nicolasferrada.com/privacy-policy'),
        );
      },
    );
  }

  Widget termsOfService(context) {
    return widgetsStyle(
      title: AppLocalizations.of(context)!.termsOfServiceTitle_text_aboutPage,
      subtitle:
          AppLocalizations.of(context)!.termsOfServiceSubtitle_text_aboutPage,
      onTapFunction: () {
        launchUrl(
          Uri.parse(
              'https://mycustomnotes.nicolasferrada.com/terms-of-service'),
        );
      },
    );
  }

  Widget softwareLicense(context) {
    return widgetsStyle(
      title: AppLocalizations.of(context)!.softwareLicenseTitle_text_aboutPage,
      subtitle:
          AppLocalizations.of(context)!.softwareLicenseSubtitle_text_aboutPage,
      onTapFunction: () {
        launchUrl(
          Uri.parse(
              'https://github.com/nicolas-ferrada/mycustomnotes/blob/main/LICENSE'),
        );
      },
    );
  }

  Widget thirdPartySoftware(context) {
    return widgetsStyle(
      title:
          AppLocalizations.of(context)!.thirdPartySoftwareTitle_text_aboutPage,
      subtitle: AppLocalizations.of(context)!
          .thirdPartySoftwareSubtitle_text_aboutPage,
      onTapFunction: () {
        showLicensePage(context: context);
      },
    );
  }

  Widget developerWebsite(context) {
    return widgetsStyle(
      title: AppLocalizations.of(context)!.websiteTitle_text_aboutPage,
      subtitle: AppLocalizations.of(context)!.websiteSubtitle_text_aboutPage,
      onTapFunction: () {
        launchUrl(Uri.parse('https://nicolasferrada.com'));
      },
    );
  }
}

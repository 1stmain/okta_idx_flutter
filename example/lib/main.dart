// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:okta_oidc_flutter/okta_oidc_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  OktaOidcFlutter? oktaOidcFlutter;
  @override
  void initState() {
    super.initState();

    OktaOidcFlutter.instance.initOkta(
      InitOkta(
        clientId: '0oa1k4uyv06twnAW8697',
        issuer: 'https://dev.auth.magnifi.com/oauth2/default',
        scopes: ['openid', 'profile', 'email', 'offline_access'],
        redirectUrl: 'com.jiju.thomas.oktaOidcFlutterExample:/app',
        endSessionRedirectUri: 'com.jiju.thomas.oktaOidcFlutterExample:/splash',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                OktaResponse oktaResposne =
                    await OktaOidcFlutter.instance.signInWithCredentials(
                  email: '########################',
                  password: '########################',
                );
                if (oktaResposne.reEnroll) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          alignment: Alignment.center,
                          title: const Text('reset'),
                          actions: [
                            Center(
                              child: SizedBox(
                                height: 30,
                                width: 100,
                                child: TextButton(
                                  onPressed: () async {
                                    OktaResponse oktaResposne =
                                        await OktaOidcFlutter.instance
                                            .signInWithCredentials(
                                      email: '########################',
                                      password: '########################',
                                      newPassword: '########################',
                                    );

                                    print(oktaResposne.accessToken.toString());
                                  },
                                  child: const Text('RESET'),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                } else if (oktaResposne.codeSentFor2FA) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController textEditingController =
                            TextEditingController();
                        return AlertDialog(
                          alignment: Alignment.center,
                          title: TextFormField(
                            controller: textEditingController,
                            onChanged: (String? e) {
                              if (e != null) {
                                textEditingController.text = e;
                              }
                            },
                          ),
                          actions: [
                            Center(
                              child: SizedBox(
                                height: 30,
                                width: 100,
                                child: TextButton(
                                  onPressed: () async {
                                    OktaResponse oktaResposne =
                                        await OktaOidcFlutter
                                            .instance
                                            .signInWithCredentials(
                                                email:
                                                    '########################',
                                                password:
                                                    '########################',
                                                tfaCode: '######');
                                    print(oktaResposne.accessToken.toString());
                                  },
                                  child: const Text('RESET'),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                } else {
                  print(oktaResposne.accessToken!);
                }
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () async {
                bool result = await OktaOidcFlutter.instance.signOut();
                print(result);
              },
              child: const Text('Sign Out'),
            ),
            TextButton(
              onPressed: () async {
                OktaResponse token = await OktaOidcFlutter.instance
                    .registerWithCreds(
                        '########################', '########################');
                print(token.accessToken.toString());
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

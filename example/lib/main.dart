import 'dart:developer';

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
        clientId: '########################',
        issuer: '########################',
        endSessionRedirectUri: '########################',
        redirectUrl: '########################',
        scopes: ['openid', 'profile', 'email', 'offline_access'],
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

                                    log(oktaResposne.accessToken.toString());
                                  },
                                  child: const Text('RESET'),
                                ),
                              ),
                            )
                          ],
                        );
                      });
                } else {
                  log(oktaResposne.accessToken!.toString());
                }
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () async {
                bool result = await OktaOidcFlutter.instance.signOut();
                log(result.toString());
              },
              child: const Text('Sign Out'),
            ),
            TextButton(
              onPressed: () async {
                await OktaOidcFlutter.instance.initOkta(
                  InitOkta(
                      clientId: '########################',
                      issuer: '########################',
                      endSessionRedirectUri: '########################',
                      redirectUrl: '########################',
                      scopes: ['openid', 'profile', 'email', 'offline_access'],
                      idp: '########################'),
                );
                await OktaOidcFlutter.instance
                    .sso(idp: '########################');
              },
              child: const Text('SSO'),
            ),
            TextButton(
              onPressed: () async {
                await OktaOidcFlutter.instance.registerWithGoogle();
              },
              child: const Text('Register with google'),
            ),
            TextButton(
              onPressed: () async {
                OktaResponse token = await OktaOidcFlutter.instance
                    .registerWithCreds(
                        '########################', '########################');
                log(token.accessToken.toString());
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

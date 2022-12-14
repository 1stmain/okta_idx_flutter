import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../okta_oidc_flutter.dart';

class OktaOidcFlutter {
  static const MethodChannel _channel = MethodChannel('okta_oidc_flutter');

  static OktaOidcFlutter? _instance;
  OktaOidcFlutter._();
  static OktaOidcFlutter get instance => _instance ??= OktaOidcFlutter._();

  bool isInitialized = false;

  /// Initialize Okta OIDC
  Future<void> initOkta(InitOkta request) async {
    isInitialized = false;
    try {
      await _channel.invokeMethod("CREATE_CONFIG", request.toMap());
      isInitialized = true;
    } catch (e) {
      isInitialized = false;
    }
  }

  Future<OktaResponse> signInWithCredentials(
      {required String email,
      required String password,
      String? newPassword,
      String? tfaCode}) async {
    if (isInitialized == false) {
      throw Exception("Cannot sign in before initializing Okta SDK");
    }
    Map? tokens;

    tokens = await _channel.invokeMethod(
      "SIGN_IN_WITH_CREDENTIAL",
      {
        'username': email,
        'password': password,
        'newPassword': newPassword,
        'tfaCode': tfaCode
      },
    );

    return OktaResponse.parse(tokens);
  }

  Future<OktaResponse?> sso({
    required String idp,
  }) async {
    if (isInitialized == false) {
      throw Exception("Cannot sign in before initializing Okta SDK");
    }
    if (Platform.isAndroid) {
      return null;
    }

    Map? tokens;

    tokens = await _channel.invokeMethod("WEB_SIGN_IN", idp);

    return OktaResponse.parse(tokens);
  }

  /// Sign out by revoking okta tokens
  Future<bool> signOut() async {
    if (isInitialized == false) {
      throw Exception("Cannot sign out in before initializing Okta SDK");
    }

    return await _channel.invokeMethod("SIGN_OUT") as bool;
  }

  Future<Map?> forgotPassword(String userName, String domainUrl) async {
    if (isInitialized == false) {
      throw Exception("Cannot sign in before initializing Okta SDK");
    }

    if (Platform.isIOS) {
      return await _channel.invokeMethod("FORGOT_PASSWORD", {
        "username": userName,
      });
    }
    return null;
  }

  Future<OktaResponse> registerWithCreds(String email, String password) async {
    Map? tokens;
    tokens = await _channel.invokeMethod(
        "REGISTER_WITH_CREDENTIAL", {"email": email, "password": password});

    return OktaResponse.parse(tokens);
  }

  Future<OktaResponse> registerWithGoogle() async {
    if (isInitialized == false) {
      throw Exception("Cannot sign in before initializing Okta SDK");
    }
    Map? tokens;
    if (Platform.isAndroid) {
      tokens = await _channel.invokeMethod("REGISTER_WITH_GOOGLE");
    }

    return OktaResponse.parse(tokens);
  }
}

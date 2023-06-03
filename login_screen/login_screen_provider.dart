// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_track/app/validation_utils.dart';
import 'package:fleet_track/app/widget/app_toast.dart';
import 'package:fleet_track/generated/l10n.dart';
import 'package:fleet_track/model/user_profile_model.dart';
import 'package:fleet_track/provider/disposable_provider.dart';
import 'package:fleet_track/provider/signup_screen_provider.dart';
import 'package:fleet_track/screen/home_screen/home_screen.dart';
import 'package:fleet_track/screen/sign_up_screen/sign_up_screen.dart';
import 'package:fleet_track/services/auth_service.dart';
import 'package:fleet_track/services/users_service.dart';
import 'package:fleet_track/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LogInScreenProvider extends DisposableProvider {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  String? userNameError;
  String? passwordError;
  bool obscureText = false;
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  DateTime? currentBackPressTime;

  void changeVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> validateUser(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (ValidationUtils.validateEmptyController(userNameController)) {
      userNameError = S.of(context).emptyUserNameError;
    } else {
      userNameError = null;
    }
    if (ValidationUtils.validateEmptyController(passwordController)) {
      passwordError = S.of(context).emptyPasswordError;
    } else {
      passwordError = null;
    }
    isLoading = (userNameError == null && passwordError == null);
    notifyListeners();
    if (isLoading) {
      final AuthService authService = Provider.of<AuthService>(context, listen: false);
      UserCredential? user = await authService.verifyUser(userNameController.text.trim(), passwordController.text);
      if (user != null) {
        setPrefBoolValue(isLoggedIn, true);
        S.of(context).loginSuccessfully.showToast();
        userNameController.clear();
        passwordController.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    }
    isLoading = false;
    notifyListeners();
  }

  // void googleLoginButton(BuildContext context) async {
  //   isLoading = true;
  //   notifyListeners();
  //   UserCredential? userCredential = await signInWithGoogle();
  //   if (userCredential != null) {
  //     logs('Google Account Details --> $userCredential');
  //     FocusScope.of(context).unfocus();
  //     'Login successfully'.showToast();
  //     setPrefBoolValue(isLoggedIn, true);
  //     SignUpScreenProvider signUpScreenProvider = Provider.of<SignUpScreenProvider>(context,listen: false);
  //     signUpScreenProvider.nameController.text = userCredential.additionalUserInfo!.profile!['given_name'] ??'';
  //     signUpScreenProvider.emailController.text = userCredential.additionalUserInfo!.profile!['email'] ??'';
  //     signUpScreenProvider.phoneController.text = userCredential.additionalUserInfo!.profile!['phoneNumber'] ??'';
  //     final AuthService authService = Provider.of<AuthService>(context, listen: false);
  //     UserModel? user = await authService.checkUserAvailability(signUpScreenProvider.nameController.text.trim());
  //     if (user != null) {
  //       setPrefBoolValue(isLoggedIn, true);
  //       userNameController.clear();
  //       passwordController.clear();
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const HomeScreen()),
  //         (route) => false,
  //       );
  //     } else {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SignUpScreen(isGoogleUser: true)),
  //         (route) => false,
  //       );
  //     }
  //   } else {
  //     isLoading = false;
  //   }
  //   isLoading = true;
  //   notifyListeners();
  // }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await googleSignIn.signOut();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleSignInAccount!.authentication;
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential;
      }
      return null;
    } on PlatformException catch (e) {
      debugPrint('Error-->>$e');
      return null;
    }
  }

  @override
  void disposeAllValues() {
    disposeValues();
  }

  @override
  void disposeValues() {
    userNameController.clear();
    passwordController.clear();
    obscureText = false;
  }

  Future<void> loginWithGoogle(BuildContext context, UserCredential userCredential) async {
    final signUpScreenProvider = Provider.of<SignUpScreenProvider>(context, listen: false);
    signUpScreenProvider.nameController.text = userCredential.user!.displayName ?? '';
    signUpScreenProvider.emailController.text = userCredential.user!.email!;
    signUpScreenProvider.phoneController.text = userCredential.user!.phoneNumber ?? '';
    UserProfileModel? userModel = await UserService.instance.checkUserNameAvailability(signUpScreenProvider.nameController.text);
    if (userModel == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(fromSplash: true, isGoogleUser: true),
        ),
      );
    } else {
      await setPrefBoolValue(isLoggedIn, true);
      S.of(context).loginSuccessfully.showToast();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> continueWithGoogle(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    isLoading = true;
    notifyListeners();
    UserCredential? userCredential = await authService.signInWithGoogle();
    if (userCredential != null) {
      loginWithGoogle(context, userCredential);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> sendEmail(BuildContext context) async {
    if (ValidationUtils.validateEmptyController(emailController)) {
      emailError = S.of(context).emptyEmailError;
    } else if (!ValidationUtils.regexValidator(emailController, ValidationUtils.emailRegExp)) {
      emailError = S.of(context).inValidMail;
    } else {
      emailError = null;
      FocusScope.of(context).unfocus();
      isLoading = true;
      notifyListeners();
      bool isSendMail = await AuthService.forgotPassword(context, emailController.text.trim());
      if (isSendMail) Navigator.pop(context);
    }
    isLoading = false;
    notifyListeners();
  }
}

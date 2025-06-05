import 'package:domain/models/doctor/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:api/api.dart';
import 'package:siscoca/app/data/controller/brain.dart';
import 'package:siscoca/app/modules/auth/auth_login/controllers/auth_exception.dart';
import 'dart:developer' as developer;
import 'package:siscoca/routes/routes.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TokenStorage _tokenStorage;
  final Brain _brain = Get.find<Brain>();
  
  AuthController({
    required TokenStorage tokenStorage,
  }) : _tokenStorage = tokenStorage
      {
    _initializeAuth();
  }

  void _initializeAuth() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _handleLogout();
      } else {
        try {
          final token = await firebaseUser.getIdToken();
          if (token != null) {
            await _handleBackendLogin(token);
          }
        } catch (e) {
          developer.log('Auth initialization error', error: e);
          _handleLogout();
        }
      }
    });
  }

  Future<void> _handleBackendLogin(String token) async {
    try {
      await _tokenStorage.saveToken(token);
      final doctor = await loginBackend(token);
      _brain.updateAuthState(
        doctor: doctor,
        authenticated: true,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      developer.log('Backend login error', error: e);
      if (e is! AuthException) {
        _handleLogout();
      } else {
        _tokenStorage.clearToken();
        rethrow;
      }
    }
  }

  void _handleLogout() {
    _brain.clearAuthState();
    _tokenStorage.clearToken();
    Get.offAllNamed(AppRoutes.auth);
  }

  Future<void> login(String email, String password) async {
    try {
      final credentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      final token = await credentials.user?.getIdToken();
      if (token == null) throw Exception('No token received');
    } catch (e) {
      developer.log('Login error', error: e);
      String errorMessage = 'An unexpected error occurred';
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
          case 'wrong-password':
          case 'invalid-credential':
            errorMessage = 'Invalid credentials. Please check your email and password.';
            break;
          case 'user-disabled':
            errorMessage = 'This account has been disabled. Please contact support.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many failed attempts. Please try again later.';
            break;
          default:
            errorMessage = 'Authentication failed. Please try again.';
        }
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      
      throw AuthException(errorMessage);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      _handleLogout();
    } catch (e) {
      developer.log('Logout error', error: e);
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset email sent',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      developer.log('Password reset error', error: e);
      Get.snackbar(
        'Error',
        'Password reset failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    }
  }

  Future<Doctor> loginBackend(String token) async {
    try {
      final (userId, loginError) = await CococareAuthApi.loginDoc();
      if (loginError != null) {
        throw AuthException('Invalid credentials. Please check your email and password.');
      }

      final (data, error) = await CococareUserApi.getDocData(userId!);
         
      if (data == null || error != null) {
        throw AuthException('No user data received from backend');
      }
      
      return Doctor.fromJson(data);
    } catch (e) {
      if (e is AuthException) {
        Get.snackbar(
          'Authentication Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }
      rethrow;
    }
  }
    void checkFirebaseAccount() {
    // final options = Firebase.app().options;
    // print('Firebase Config:');
    // print('Project ID: ${options.projectId}');
    // print('App ID: ${options.appId}');
    // print('API Key: ${options.apiKey}');
    // print('Messaging Sender ID: ${options.messagingSenderId}');
  }
}
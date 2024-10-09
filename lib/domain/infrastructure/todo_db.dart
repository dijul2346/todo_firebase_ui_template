import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_firebase_ui_template/domain/infrastructure/user_model.dart';

Future<void> registerUser(UserModel user) async {
  final userAuth = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.userEmail, password: user.userPassword);

  if (userAuth != null) {
    await addUser(userAuth.user!.uid, user);
  }
}

Future<void> addUser(String userId, UserModel user) async {
  final firestore = await FirebaseFirestore.instance;
  await firestore.collection('user').doc(userId).set({
    'name': user.userName,
    'email': user.userEmail,
    'mobile': user.userMobile,
    'address': user.userAddress
  });
}

Future<bool> checkLogin(UserModel user) async {
  bool flag = false;
  final userAuth = FirebaseAuth.instance;
  UserCredential userCredential = await userAuth.signInWithEmailAndPassword(
      email: user.userEmail, password: user.userPassword);
}

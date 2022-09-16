import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safe_app/services/database/database.dart';
import 'package:safe_app/services/models/auth_model.dart';


class AuthService {
  // Firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  /// Create user object based on firebase user
  ///
  /// Return AppUser or Null
  AppUser? _userFromFireBase(User? user) {
    return user!=null? AppUser(id: user.uid, isAdmin: false):null;
  }


  /// Auth change user stream
  ///
  /// Return a stream of AppUser
  Stream<AppUser?>? get user{
    var result =  _auth.authStateChanges()
        .map((User? user) => _userFromFireBase(user));
    return result;
  }

  /// Sign in with Google
  ///
  /// Return Null if there's no user
  Future loginGoogle() async {
    // Sign in with Google
    final user = await googleSignIn.signIn();
    if (user == null) {
      return;
    }
    final googleAuth = await user.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in Firebase with Google credential
    await _auth.signInWithCredential(credential).then((value) async {
      String uid = value.user!.uid;
      await DatabaseService(uid: uid).checkExist().then((value) async {
        // Check if user exists to create entry in database
        if(value == false) {
          await DatabaseService(uid: uid).setUserData(user.displayName.toString(), "", user.email, "");
        }
      });
    });
  }


  /// Sign in anonymously
  ///
  /// Return null if there's an error
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
    } catch(e){
      //print(e.toString());
      return null;
    }
  }

  /// Sign in with email & password
  ///
  /// Return App User or the error string
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFireBase(user);
    }catch(e){
      return e.toString();
    }
  }


  /// Register with email & password
  ///
  /// Return App User or the error string
  Future registerWithEmailAndPassword(String email, String password, String fName, String lName, String phoneNumber) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // Update information to database
      await DatabaseService(uid: user!.uid).setUserData(fName, lName, email, phoneNumber);
      return _userFromFireBase(user);
    }catch(e){
      //print(e.toString());
      return e.toString();
    }
  }
  
  /// Reset password with email
  ///
  /// Return error message if there's one
  Future resetPassword (String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e){
      print(e);
      return e.toString();
    }


  }

  /// Sign out
  ///
  /// Return nothing
  Future signOut() async{
    // Check if user uses Google Sign in
    await googleSignIn.isSignedIn().then((value) async{
      if(value == true){
        // Sign out Google first then Firebase
        await googleSignIn.disconnect().then((value) async {
          return await _auth.signOut();
        });
      }
      else{
        // Sign out Firebase
        return await _auth.signOut();
      }
    });
  }
}
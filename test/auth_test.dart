

import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';



class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if(!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return login(email: email, password: password,);
  }

  @override

  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
      await Future.delayed(const Duration(seconds: 1));
      _isInitialized=true;
  }

  @override
  Future<void> logOut() async{
     if(!isInitialized) throw NotInitializedException();
     if(_user==null) throw UserNotLoggedInAuthException();
     await Future.delayed(const Duration(seconds:1));
     _user=null;
    //  return Future.value(user);


  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if(!isInitialized) throw NotInitializedException();
    if(email=='foo@bar.com' ) throw InvalidLoginCredentialsAuthException();
    
    const user=AuthUser(isEmailVerified: false, email: 'foo@bar.com');
    _user=user;
    return Future.value(user);
    
  }

  @override
  Future<void> sendEmailVerification()async {
    
     if(!isInitialized) throw NotInitializedException();
     final user=_user;
     if(user==null){
      throw UserNotLoggedInAuthException();
     }
     const newUser=AuthUser(isEmailVerified: true, email: 'foo@bar.com');
    _user=newUser;

  }
}


void main(){
  group('Mock Authentication',(){
    final provider=MockAuthProvider();

    test('Should not be initalized to begin with', (){
      expect(provider.isInitialized, false);
    });
    test('Cannot logout if not initialized', (){
      expect(provider.logOut(), 
      throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('Should be able to be initalized',() async {
      await provider.initialize();
      expect(provider.isInitialized,true);
    });
    test('User shoulld be null after initialization',() async {
      
      expect(provider.currentUser,null);
    });
    
    test('should be able to initialize in less than 2 seconds',() async {
     await provider.initialize();
     expect(provider.isInitialized, true);
    },
    timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login function', ()async{
      final badEmailUser=provider.createUser(
        email:'foo@bar.com',
        password:"foobar",
      );

      expect(badEmailUser,
      throwsA(const TypeMatcher<InvalidLoginCredentialsAuthException>()));

      final user=await provider.createUser(email: 'foo', password: 'bar');
      expect(provider.currentUser,user);
    });

    test('Email Verification',()async{
      await provider.sendEmailVerification();
      final user=provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('should be able to logout and login again', ()async{
      await provider.logOut();
      await provider.login(email: 'email', password: 'password');
      final user= provider.currentUser;
      expect(user, isNotNull);
    });




  });
}
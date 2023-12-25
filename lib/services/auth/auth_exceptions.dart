//login exception
class InvalidLoginCredentialsAuthException implements Exception{
  
}
class InvalidEmailAuthException implements Exception{}
class UserNotFoundAuthException implements Exception{}
//register
class WeakPasswordAuthException implements Exception{
  
}
class EmailAlreadyInUseAuthException implements Exception{
  
}

//generic exception
class GenericAuthException implements Exception{

}

class UserNotLoggedInAuthException implements Exception{
  
}


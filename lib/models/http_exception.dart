class HttpException implements Exception {
  //We are signing  a contract we are forced to implement all
  //the functions this class have
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    //return super.toString(); //Instance of HttpException
  }
}

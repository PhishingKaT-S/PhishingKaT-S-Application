class Sms {
  final int id ;
  final String sender ;
  final String text ;
  final String date ;
  final int type ;
  final int prediction ;
  final int smishing ;
  // id INTEGER PRIMARY KEY,
  //     sender TEXT,
  // text TEXT,
  //     date TEXT,
  // type INTEGER,
  //     prediction INTEGER,
  // smishing INTEGER

  Sms({required this.id, required this.sender, required this.text, required this.date,
        required this.type, required this.prediction, required this.smishing}) ;
}
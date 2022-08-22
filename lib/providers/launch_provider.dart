

// class Banks {
//   final String name ;
//   List<String> phones ;
//
//   Banks({required this.name, required this.phones}) ;
//
//   Banks.fromJson(Map<String, dynamic> json, this.name) {
//     name = json['name'];
//     phones = json['phones'] ;
//   }
// }
// Future<List<Banks>> ReadJsonData() async {
//   final jsondata = await rootBundle.rootBundle.loadString('assets/json/bank.json');
//   final list = json.decode(jsondata) as List<dynamic> ;
//
//   return list.map((e) => Banks.fromJson(e)).toList();
// }
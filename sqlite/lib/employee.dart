class Employee {
  int id = 0;
  String name = '';
  int age = 0;

  Employee({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
    };
    return map;
  }

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
        id: map['id'],
        name: map['name'],
        age: map['age'],
      );
}

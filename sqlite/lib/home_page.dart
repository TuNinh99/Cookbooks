import 'package:flutter/material.dart';
import 'package:sqlite/db_provider.dart';
import 'package:sqlite/employee.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite App'),
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: FutureBuilder(
        future: DBProvider.db.employees(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          } else if (snapshot.hasData) {
            List<Employee>? emps = snapshot.data;
            return ListView.builder(
              itemCount: emps!.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(emps[index].name),
                    subtitle: Text(emps[index].age.toString()),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddNewEmployee(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> showAddNewEmployee(BuildContext context) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController ageCtrl = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new employee'),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Age'),
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              List<Employee> emps = await DBProvider.db.employees();
              int lastId = emps.last.id;
              DBProvider.db.insertEmployee(
                Employee(
                  id: lastId + 1,
                  name: nameCtrl.text,
                  age: int.parse(ageCtrl.text),
                ),
              );
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            color: Colors.blue,
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: const Color.fromARGB(255, 201, 199, 199),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_api/resource/api_service.dart';

import 'models/member.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(color: Colors.blue)
      ),
      home: const MyHomePage(title: 'Api Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService api = ApiService();
  late Future<List<member>> memberList;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  int m_id = 0;

  @override
  void initState() {
    // TODO: implement initState
    memberList = api.getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () {
                        _displayInsertDialog();
                      },
                      child: const Text('Add a member')),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: FutureBuilder(
                      future: memberList,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var data = snapshot.data[index] as member;
                                return Dismissible(
                                    key: ValueKey(data),
                                    onDismissed: (direction) {
                                      api.deleteMember(data.m_id);
                                      setState(() {
                                        memberList = api.getMembers();
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  super.widget));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  ' $index\'s member is  deleted')));
                                    },
                                    child: Card(
                                        child: ListTile(
                                      leading: const Icon(Icons.person),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.update),
                                        onPressed: () {
                                          setState(() {
                                            m_id = data.m_id;
                                          });

                                          idController.text = m_id.toString();
                                          nameController.text = data.m_name;
                                          batchController.text = data.m_batch;
                                          _displayUpdateDialog();
                                        },
                                      ),
                                      title: Text(data.toString()),
                                    )));
                              });
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayInsertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white70,
            title: const Text('Add Member'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                const Divider(
                  color: Colors.pink,
                  thickness: 3.0,
                ),
                TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: "Enter Member Name")),
                TextField(
                    controller: batchController,
                    decoration:
                        const InputDecoration(hintText: "Enter Member Batch")),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop();
                  String name = nameController.text;
                  String batch = batchController.text;

                  var _member = member(m_id: 0, m_name: name, m_batch: batch);
                  api.createMember(_member);
                  setState(() {
                    memberList = api.getMembers();
                  });
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => super.widget));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Member Created')));
                  nameController.clear();
                  batchController.clear();
                },
              ),
              TextButton(
                  onPressed: () {
                    nameController.clear();
                    batchController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  Future<void> _displayUpdateDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white70,
            title: const Text('Add Member'),
            content: SingleChildScrollView(
              child: Column(children: <Widget>[
                const Divider(
                  color: Colors.pink,
                  thickness: 3.0,
                ),
                TextField(
                    readOnly: true,
                    controller: idController,
                    decoration:
                        const InputDecoration(hintText: "Enter Member ID")),
                TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: "Enter Member Name")),
                TextField(
                    controller: batchController,
                    decoration:
                        const InputDecoration(hintText: "Enter Member Batch")),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Navigator.of(context).pop();
                  String name = nameController.text;
                  String batch = batchController.text;
                  int id = m_id;

                  var _member = member(m_id: id, m_name: name, m_batch: batch);
                  api.updateMember(_member, id);
                  setState(() {
                    memberList = api.getMembers();
                  });
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => super.widget));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Member Updated')));
                  nameController.clear();
                  batchController.clear();
                },
              ),
              TextButton(
                  onPressed: () {
                    nameController.clear();
                    batchController.clear();
                    idController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }
}

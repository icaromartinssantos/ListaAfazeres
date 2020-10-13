import 'package:flutter/material.dart';
import 'package:primeiro_projeto/data_base/data_base.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  TextEditingController textController;

  DataBase _db;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    textController = TextEditingController();
    _db = DataBase();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Lista de Afazeres"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(children: [
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'O que vamos fazer hoje?',
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.green,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          _db.insereTarefa(Tarefa(nome: textController.text));
                        }
                      },
                    ),
                  ),
                )
              ]),
              Expanded(
                  child: StreamBuilder(
                stream: _db.observaTarefas(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.0),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            key: ObjectKey(snapshot.data[index].nome),
                            child: Card(
                                child: ListTile(
                              title: Text(snapshot.data[index].nome),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            )),
                            onDismissed: (direcao) {
                              var tarefa = snapshot.data[index];

                              _db.deletaTarefa(tarefa);

                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Item deletado com sucesso"),
                                  action: SnackBarAction(
                                      label: "Desfazer",
                                      onPressed: () {
                                        _db.insereTarefa(tarefa);
                                      })));
                            },
                          );
                        });
                  } else {
                    return Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        height: 50.0,
                        width: 50.0,
                      ),
                    );
                  }
                },
              )),
            ],
          )),
    );
  }
}

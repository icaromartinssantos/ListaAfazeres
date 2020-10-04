import 'package:flutter/material.dart';

class Tarefa {
  String nome;

  Tarefa(this.nome);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  TextEditingController textController;
  List<Tarefa> tarefas = [
    Tarefa("Limpar Casa"),
    Tarefa("Lavar Carro"),
    Tarefa("Lavar Louça")
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    textController = TextEditingController();
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
                          setState(() {
                            tarefas.add(Tarefa(textController.text));
                            textController.text = "";
                          });
                        }
                      },
                    ),
                  ),
                )
              ]),
              Expanded(
                child: ListView.builder(
                    itemCount: tarefas.length,
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
                        key: ObjectKey(tarefas[index].nome),
                        child: Card(
                            child: ListTile(
                          title: Text(tarefas[index].nome),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        )),
                        onDismissed: (direcao) {
                          var tarefa = tarefas[index];

                          setState(() {
                            tarefas.removeAt(index);
                          });

                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Item deletado com sucesso"),
                              action: SnackBarAction(
                                  label: "Desfazer", onPressed: () {
                                    setState(() {
                                      tarefas.insert(index,tarefa );
                                    });
                                  })));
                        },
                      );
                    }),
              ),
            ],
          )),
    );
  }
}

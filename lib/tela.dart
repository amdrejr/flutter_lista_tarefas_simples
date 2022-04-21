import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List lista = [];
  Map<String, dynamic> _lastRemoved = {};
  late int _lastRemovedPosition;

  late DateTime agora = DateTime.now();
  TextEditingController textController = TextEditingController();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: textController,
              )),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    setState(() {
                      lista.add({
                        'title': textController.text,
                        'date': DateFormat('dd-MM-yyyy').format(agora),
                      });
                      index++;
                    });
                    textController.clear();
                  }
                },
                child: const Text('Salvar'),
              )
            ],
          ),
          const SizedBox(height: 25),
          const Icon(Icons.person),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: listItemCreate,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                lista.clear();
              });
            },
            child: const Text('Limpar tudo'),
          ),
          TextButton(
              onPressed: () {
                print(lista);
              },
              child: Text('teste')),
        ],
      ),
    );
  }

  Widget listItemCreate(context, index) {
    return Padding(
      key: Key(DateTime.now().microsecond.toString()),
      padding: const EdgeInsets.all(10),
      child: Dismissible(
        key: const Key('oioioi'),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.delete, color: Colors.white, size: 30),
              SizedBox(width: 15),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(blurRadius: 2),
            ],
          ),
          child: ListTile(
            leading: const Icon(Icons.cabin),
            title: Text(lista[index]['title']),
            trailing: Text(lista[index]['date']),
          ),
        ),
        onDismissed: (direction) {
          setState(() {
            _lastRemoved = lista[index];
            _lastRemovedPosition = index;
            lista.removeAt(index);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Tarefa ${_lastRemoved['title']} removida com sucesso!'),
                action: SnackBarAction(
                  label: 'Desfazer',
                  onPressed: () {
                    setState(() {
                      lista.insert(_lastRemovedPosition, _lastRemoved);
                    });
                  },
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

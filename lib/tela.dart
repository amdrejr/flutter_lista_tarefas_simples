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
  bool clique = false;

  late DateTime agora;
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
                      agora = DateTime.now();
                      lista.add({
                        'title': textController.text,
                        'date': DateFormat('dd/MM/yyyy - kk:mm').format(agora),
                        'ok': false,
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
              child: const Text('teste')),
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
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Text(
                'Remover',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Icon(Icons.delete, color: Colors.white, size: 30),
              SizedBox(width: 15),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(blurRadius: 2),
            ],
          ),
          child: ListTile(
              minLeadingWidth: 20,
              dense: true,
              leading: lista[index]['ok']
                  ? const Icon(Icons.check, color: Colors.grey, size: 30)
                  : Icon(Icons.do_disturb_on_outlined,
                      color: Colors.amber[400], size: 30),
              title: Text(lista[index]['title'],
                  style: const TextStyle(fontSize: 16)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(lista[index]['date']),
              ),
              trailing: Checkbox(
                checkColor: Colors.white,
                value: clique,
                onChanged: (bool? value) {
                  setState(() {
                    clique = value!;
                    print(clique);
                  });
                },
              )),
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

class ListItemCreate extends StatefulWidget {
  const ListItemCreate({Key? key}) : super(key: key);

  @override
  State<ListItemCreate> createState() => _ListItemCreateState();
}

class _ListItemCreateState extends State<ListItemCreate> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

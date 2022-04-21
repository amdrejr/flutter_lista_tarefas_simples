import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Future _refresh() async {
    // Esperar 0.3 sec, só pra ficar bonito
    await Future.delayed(const Duration(milliseconds: 300));

    setState(
      () {
        // Ordena a lista de acordo com a função adicionada
        // a e b são os index que serão comparados
        //
        lista.sort(
          (a, b) {
            if (a['ok'] && !b['ok']) {
              // elemento 'a' é 'maior', portanto, será empurrado para o final
              // lembrando que é uma lista ordenada, então começa do menor para o maior
              return 1;
            } else if (!a['ok'] && b['ok']) {
              // elemento 'b' é maior, então, 'a' virá primeiro que o 'b'
              return -1;
            } else {
              // Se iguais, nada muda
              return 0;
            }
          },
        );
      },
    );
  }

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
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: listItemCreate,
              ),
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
                  ? const Icon(Icons.check, color: Colors.green, size: 30)
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
                value: lista[index]['ok'],
                onChanged: (bool? value) {
                  setState(() {
                    lista[index]['ok'] = value!;
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

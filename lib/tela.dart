import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_design.dart';
import 'app_repository.dart';

String? errorText;

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final AppRepository todoRepositorio = AppRepository();

  @override
  void initState() {
    super.initState();
    todoRepositorio.getTodoList().then((value) {
      setState(() {
        lista = value;
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: inputDecorat(),
                  controller: textController,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: appButtonStyle(),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    setState(
                      () {
                        errorText = null;
                        agora = DateTime.now();
                        lista.add(
                          {
                            'title': textController.text,
                            'date':
                                DateFormat('dd/MM/yyyy - kk:mm').format(agora),
                            'ok': false,
                          },
                        );
                      },
                    );
                    textController.clear();
                    todoRepositorio.saveTodoList(lista);
                  } else {
                    setState(
                      () {
                        errorText = 'Digite para adicionar!';
                      },
                    );
                  }
                },
                child: const Icon(Icons.add_outlined, size: 30),
              )
            ],
          ),
          const SizedBox(height: 25),
          Flexible(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Container(
                padding: lista.isNotEmpty ? const EdgeInsets.all(8) : null,
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    tileMode: TileMode.mirror,
                    colors: [
                      AppColor.backgroundAppColor,
                      Colors.white,
                      AppColor.backgroundAppColor,
                      AppColor.backgroundColor,
                      AppColor.backgroundAppColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: lista.isNotEmpty
                      ? Border.all(color: AppColor.primary, width: 1.2)
                      : null,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: lista.length,
                  itemBuilder: listItemCreate,
                ),
              ),
            ),
          ),
          lista.isNotEmpty
              ? TextButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(AppColor.primary)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Limpar Lista'),
                            content: const Text(
                                'Deseja excluir todos itens da lista? Esta ação é irreversível.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Apagar Alert
                                },
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: AppColor.primary),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    lista.clear();
                                    todoRepositorio.saveTodoList(lista);
                                  });
                                },
                                child: const Text(
                                  'Confirmar',
                                  style: TextStyle(color: AppColor.primary),
                                ),
                              )
                            ],
                            elevation: 24,
                          );
                        });
                  },
                  child:
                      const Text('Limpar tudo', style: TextStyle(fontSize: 16)),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget listItemCreate(context, index) {
    return Padding(
      key: Key(DateTime.now().microsecond.toString()),
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
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
            child: melhor(context, index)),
        onDismissed: (direction) {
          setState(() {
            _lastRemoved = lista[index];
            _lastRemovedPosition = index;
            lista.removeAt(index);
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Tarefa ${_lastRemoved['title']} removida com sucesso!'),
                action: SnackBarAction(
                  label: 'Desfazer',
                  textColor: AppColor.primary,
                  onPressed: () {
                    setState(() {
                      lista.insert(_lastRemovedPosition, _lastRemoved);
                      todoRepositorio.saveTodoList(lista);
                    });
                  },
                ),
              ),
            );
            todoRepositorio.saveTodoList(lista);
          });
        },
      ),
    );
  }

  Widget melhor(context, index) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
      child: Row(
        children: [
          lista[index]['ok']
              ? const Icon(Icons.check, color: Colors.green, size: 30)
              : Icon(Icons.do_disturb_on_outlined,
                  color: Colors.amber[400], size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lista[index]['title'],
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  lista[index]['date'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Checkbox(
            activeColor: Colors.green,
            value: lista[index]['ok'],
            onChanged: (bool? value) {
              setState(() {
                lista[index]['ok'] = value!;
              });
            },
          ),
          const Icon(Icons.arrow_back_ios, color: AppColor.primary)
        ],
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

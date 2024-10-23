import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:front_end_ing_software/InitialPage.dart';
import 'package:front_end_ing_software/graphs.dart';
import 'package:front_end_ing_software/login.dart';
import 'package:front_end_ing_software/model/Dipendente.dart';
import 'package:front_end_ing_software/model/Gruppo.dart';
import 'package:front_end_ing_software/model/Organigramma.dart';
import 'package:front_end_ing_software/model/Unita.dart';
import 'package:graphview/GraphView.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crea Organigramma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
      //InitialPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Map<String, List<String>> units;
  final Graph graph;
  final BuchheimWalkerConfiguration builderConfig;
  final int orientation;
  final double levelSeparation;
  final List<String> unitaInserite;
  final Map<Node, List<Node>> listanodes;
  final Map<Node, List<Employer>> listaNomiNodi;
  final Map<Node, List<String>> listaGroup;
  final Map<String, List<Employer>> groupEmp;
  final Map<String, Map<Node, List<Node>>> proviamo;
  final Map<Node, List<Graph>> nodeGraphs;
  final Map<String, List<Dipendente>> gruppoDipendente;
  final Map<String, List<Gruppo>> unitaGruppo;
  final List<Unita> listaUnita;
  final bool flag;

  MyHomePage({
    Key? key,
    required this.units,
    required this.graph,
    required this.builderConfig,
    required this.orientation,
    required this.levelSeparation,
    required this.unitaInserite,
    required this.listanodes,
    required this.listaNomiNodi,
    required this.listaGroup,
    required this.groupEmp,
    required this.proviamo,
    required this.nodeGraphs,
    required this.gruppoDipendente,
    required this.unitaGruppo,
    required this.listaUnita,
    required this.flag,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Graph graph; // Rimuovere l'assegnazione qui
  late BuchheimWalkerConfiguration
      builderConfig; // Rimuovere l'assegnazione qui
  late int _orientation; // Rimuovere l'assegnazione qui
  late double _levelSeparation;
  late List<String> unitaGiaInserite;

  late Map<Node, List<Node>> listanodes = <Node,
      List<
          Node>>{}; // in modo da poter gestire il salvataggio delle persone inserite

  late Map<Node, List<String>> listaGroup = <Node, List<String>>{}; // questo
  late Map<String, List<Employer>> groupEmp = {}; //questo

  String azienda = '';
  late int check = 1;
  late Map<String, List<Dipendente>> gruppoDipendente =
      <String, List<Dipendente>>{};
  late Map<String, List<Gruppo>> unitaGruppo = <String, List<Gruppo>>{};
  late List<Unita> listaUnita = [];

  late bool flag = widget.flag;

  //List<Employer> employerList = [];

  final _formKey = GlobalKey<FormState>();

  late Map<Node, List<Employer>> listaNomiNodi = <Node, List<Employer>>{};
  late Map<String, Map<Node, List<Node>>> proviamo =
      <String, Map<Node, List<Node>>>{};
  late Map<Node, List<Graph>> nodeGraphs = <Node, List<Graph>>{};

  // per poter gestire dentro quale nodo posso inserire un determinato dipendente che svolge un determinato ruolo:
  Map<Node, List<String>> listaNodeRole = {};
  Map<Node, bool> listaViewThings = <Node, bool>{};
//fine variabili utilizzate.

  void newPage() {
    setState(() {
      //employerList.clear();
      // se è il nodo radice anche le liste e tutte le variabili si ripristinano
      deleteNode(graph.getNodeAtPosition(
          0)); // anche widget dovrà essere aggiornato ma se tutto va bene dovrebbe aggiornarsi in automatico

//devo puliere anche tutte le altre strutture dati
      unitaGiaInserite.clear();
      listanodes.clear();
      listaGroup.clear();
      groupEmp.clear();
      proviamo.clear();
      nodeGraphs.clear();
      listaNodeRole.clear();
      listaNomiNodi.clear();
    });
  }

  void sistemaNodeRole() {
    for (var entry in widget.units.entries) {
      List<String> listaRuoli = entry.value;
      Node nodo = Node.Id(entry.key);
      listaNodeRole[nodo] = [];
      for (String s in listaRuoli) {
        listaNodeRole[nodo]!.add(s);
      }
    }
  }

  Map<String, List<String>> sistema() {
    for (var entry in listaNodeRole.entries) {
      List<String> lista = entry.value;
      String unita = entry.key.key!.value;

      if (widget.units[unita] == null) {
        widget.units[unita];
      }
      for (String s in lista) {
        if (!widget.units[unita]!.contains(s)) widget.units[unita]!.add(s); //
      }
    }

    listaNodeRole.clear(); // fare la clear qua
    return widget.units;
  }

  Future<void> inviaOrganigramma() async {
    Organigramma organigramma = Organigramma(
        nomeAzienda: nomeA, visualizationType: "TopToBottom", nodi: listaUnita);
    print(organigramma.toJson().toString());
    //fine creazione del RequestBody ( potrei mettere anche un tasto per far selezionare all'utente che tipo di salvataggio vuole e se sceglie il file deve inserire il nome)

    if (check == 0) {
      final response = await http.post(
        Uri.parse('http://localhost:8080/salvaOrganigrammaDB'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(organigramma.toJson()),
      );

      if (response.statusCode == 200) {
        print("Organigramma inviato con successo");
        newPage();
      } else {
        throw Exception('Errore nell\'invio dei dati');
      }
    } else {
      print("File");

      final response = await http.post(
        Uri.parse('http://localhost:8080/salvaOrganigrammaFile'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(organigramma.toJson()),
      );

      if (response.statusCode == 200) {
        print("Organigramma inviato con successo");
        newPage();
      } else {
        throw Exception('Errore nell\'invio dei dati');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Inizializza qui
    graph = widget.graph;
    builderConfig = widget.builderConfig;
    _orientation = widget.orientation;
    _levelSeparation = widget.levelSeparation;
    sistemaNodeRole();
    unitaGiaInserite = widget.unitaInserite;
    listanodes = widget.listanodes;
    listaNomiNodi = widget.listaNomiNodi;
    listaGroup = widget.listaGroup;
    groupEmp = widget.groupEmp;
    proviamo = widget.proviamo;
    nodeGraphs = widget.nodeGraphs;
    gruppoDipendente = widget.gruppoDipendente;
    unitaGruppo = widget.unitaGruppo;
    listaUnita = widget.listaUnita;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          'units': sistema(),
          'graph': graph,
          'builderConfig': builderConfig,
          'orientation': _orientation,
          'levelSeparation': _levelSeparation,
          'unitaInserite': unitaGiaInserite,
        });

        return false; // Consente di tornare indietro
      },
      child: Scaffold(
        key: _formKey,
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          title: Text(azienda),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              iconSize: 25,
              tooltip: 'Salva organigramma',
              onPressed: () {
                _showSaveTypeDialog(context);
                //prova();
                //save();
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings),
              iconSize: 25,
              onSelected: (value) {
                if (value == 'orientation') {
                  _showOrientationDialog(context);
                } else if (value == 'separation') {
                  _showSeparationDialog(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'orientation',
                    child: Text('Modifica orientamento'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'separation',
                    child: Text('Modifica level separation'),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              graph.nodeCount() > 0
                  ? InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.01,
                      maxScale: 5.6,
                      child: GraphView(
                        graph: graph,
                        algorithm: BuchheimWalkerAlgorithm(
                          builderConfig,
                          TreeEdgeRenderer(builderConfig),
                        ),
                        builder: _buildNode,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Inserire gli utenti",
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _showEditDialog(),
                          child: const Text('+ Aggiungi utente'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSaveTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tipo di salvataggio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Salva su Database'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    check = 0;
                  });
                  inviaOrganigramma();
                },
              ),
              ListTile(
                title: const Text('Salva su File'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    check = 1;
                  });
                  inviaOrganigramma();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNode(Node node) {
    String? text = node.key?.value.toString() ?? 'N/A';

    return Container(
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(
          color: Colors.blue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              // Testo centrato verticalmente
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: text.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Icone sotto il testo
              Positioned(
                left: 0,
                bottom: 5,
                right: 0,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Spazia le icone
                  children: [
                    // Icona di eliminazione
                    Tooltip(
                      message: 'Elimina Unità Organizzativa',
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.blue),
                        iconSize: 20,
                        onPressed: () {
                          deleteNode(node);
                        },
                      ),
                    ),
                    // Icona di visualizzazione, visibile se flag è true
                    if (flag)
                      Tooltip(
                        message: 'Visualizza Dipendenti',
                        child: IconButton(
                          icon: const Icon(Icons.remove_red_eye,
                              color: Colors.blue),
                          iconSize: 17,
                          onPressed: () {
                            seeDatas(node);
                          },
                        ),
                      ),
                    // Icona di modifica, visibile se flag è true
                    if (flag)
                      Tooltip(
                        message: 'Inserisci Dipendente',
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          iconSize: 17,
                          onPressed: () {
                            showEmployeeForm(node);
                          },
                        ),
                      ),
                    // Icona di aggiunta
                    Tooltip(
                      message: 'Inserisci Unità Organizzativa',
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        iconSize: 20,
                        onPressed: () {
                          _showEditDialog(node: node);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Icona di modifica, visibile sempre
              Positioned(
                top: 0,
                right: 2,
                child: IconButton(
                  onPressed: () => changeName(node),
                  icon: const Icon(Icons.abc, color: Colors.blue),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void changeName(Node node) {
    TextEditingController positionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("MODIFICA UNITA' ORGANIZZATIVA"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: positionController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (positionController.text.isNotEmpty) {
                  setState(() {
                    List<Node> figli = listanodes[node]!;
                    listanodes.remove(node);

                    node.key = ValueKey(
                        positionController.text); // Modifica la chiave del nodo
                    // Se stai usando una mappa, assicurati di aggiornare anche lì il nome
                    //
                    listanodes[node] = [];
                    listanodes[node] = figli;
                  });

                  Navigator.pop(context); // Chiudi il dialog
                } else {
                  // Visualizza un alert se i dati non sono completi
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Errore'),
                        content: const Text(
                            'Inserire tutti i dati prima di procedere.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Chiudi il dialog di errore
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Salva'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showInvalidRolesDialog(
      BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ruoli inseriti non validi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Chiudiamo solo l'AlertDialog
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool elimina = false;

  Future<void> showRoleInputForm(Node node) async {
    List<TextEditingController> roleControllers = [];

    // Inizializza i controller con i ruoli esistenti
    if (listaNodeRole[node] != null) {
      for (var entry in listaNodeRole.entries) {
        if (node == entry.key) {
          List<String> ruoliInseriti = entry.value;
          for (String s in ruoliInseriti) {
            TextEditingController textEditingController =
                TextEditingController();
            textEditingController.text = s;
            roleControllers.add(textEditingController);
          }
        }
      }
    }

    // Aggiungi un controller vuoto per il nuovo ruolo
    roleControllers.add(TextEditingController());

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${node.key?.value.toString().toUpperCase()}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Costruzione della lista dei TextField
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: roleControllers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: roleControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Ruolo ${index + 1}',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // Controlla che il campo attuale sia compilato prima di aggiungere un nuovo controller
                              if (roleControllers.last.text.isNotEmpty) {
                                roleControllers.add(TextEditingController());
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Errore'),
                                      content: const Text(
                                          'Il campo attuale deve essere compilato prima di aggiungere un nuovo ruolo.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                          },
                          child: Text('Aggiungi un altro ruolo'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (roleControllers.length > 1) {
                                // Rimuovi l'ultimo controller e aggiorna listaNodeRole se necessario
                                roleControllers.removeLast();
                                if (listaNodeRole[node] != null &&
                                    listaNodeRole[node]!.length > 1) {
                                  listaNodeRole[node]!.removeLast();
                                }
                              } else if (roleControllers.length == 1) {
                                // Se rimane un solo ruolo, cancella il testo e rimuovi dalla listaNodeRole
                                roleControllers[0].clear();
                                elimina = true; //variabile cambiata qui.
                                listaNodeRole[node]?.clear();
                              }
                            });
                          },
                          child: Text('Rimuovi Ruolo'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        bool allFieldsFilled = roleControllers
                            .every((controller) => controller.text.isNotEmpty);

                        if (allFieldsFilled) {
                          List<String> roles = roleControllers
                              .map((controller) => controller.text)
                              .toList();

                          setState(() {
                            listaNodeRole[node] = roles;
                          });
                          Navigator.pop(context); // Chiudi il BottomSheet
                        } else {
                          showInvalidRolesDialog(
                            context,
                            'Tutti i campi devono essere compilati per salvare.',
                          );
                        }
                      },
                      child: Text('Salva'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Chiudi il BottomSheet
                      },
                      child: Text('Annulla'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showEmployeeForm(Node node) {
    // Controller per i campi nome e cognome
    TextEditingController _nameController = TextEditingController();
    TextEditingController _surnameController = TextEditingController();
    String? selectedRole;
    String? selectedGroup;

    // Assicura che la lista dei gruppi esista per il nodo
    if (listaGroup[node] == null) listaGroup[node] = [];

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Inserisci Dipendente in ${node.key?.value.toString()}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _surnameController,
                      decoration: InputDecoration(
                        labelText: 'Cognome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // DropdownButton per selezionare il ruolo
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      hint: Text('Seleziona Ruolo'),
                      items: listaNodeRole[node]?.isNotEmpty == true
                          ? listaNodeRole[node]!.map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList()
                          : null,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      disabledHint: Text('Nessun ruolo disponibile'),
                    ),
                    SizedBox(height: 10),
                    // Pulsante per selezionare il gruppo
                    ElevatedButton(
                      onPressed: () async {
                        await showGroup(node, setState);
                        setState(() {
                          selectedGroup = listaGroup[node]?.isNotEmpty == true
                              ? listaGroup[node]!.last
                              : null;
                        });
                      },
                      child: Text('Seleziona Gruppo'),
                    ),
                    SizedBox(height: 10),
                    // DropdownButton per selezionare il gruppo
                    DropdownButtonFormField<String>(
                      value: selectedGroup,
                      hint: Text('Seleziona Gruppo'),
                      items: listaGroup[node]?.isNotEmpty == true
                          ? listaGroup[node]!.map((group) {
                              return DropdownMenuItem<String>(
                                value: group,
                                child: Text(group),
                              );
                            }).toList()
                          : null,
                      onChanged: (value) {
                        setState(() {
                          selectedGroup = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      disabledHint: Text('Nessun gruppo disponibile'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_nameController.text.isNotEmpty &&
                                _surnameController.text.isNotEmpty &&
                                selectedRole != null &&
                                selectedGroup != null) {
//costruisco il tutto per poter effettuare la chiamata al back-end( "/salvaOrganigramma")
                              Dipendente dipendente = Dipendente(
                                nome: _nameController.text,
                                cognome: _surnameController.text,
                                ruolo: selectedRole!,
                              );

// Funzione per controllare se un dipendente esiste già
                              bool isDipendenteExists(Dipendente dipendente,
                                  List<Dipendente> dipendenti) {
                                return dipendenti.any((d) =>
                                    d.nome == dipendente.nome &&
                                    d.cognome == dipendente.cognome &&
                                    d.ruolo == dipendente.ruolo);
                              }

// Gestione del gruppo dipendenti
                              if (gruppoDipendente[selectedGroup] == null) {
                                gruppoDipendente[selectedGroup!] = [];
                              }
                              if (!isDipendenteExists(dipendente,
                                  gruppoDipendente[selectedGroup]!)) {
                                gruppoDipendente[selectedGroup]!
                                    .add(dipendente);
                              }

// Creazione del gruppo
                              Gruppo gruppo = Gruppo(
                                nome: selectedGroup!,
                                dipendenteList:
                                    gruppoDipendente[selectedGroup]!,
                              );

// Funzione per controllare se un gruppo esiste già
                              bool isGruppoExists(
                                  Gruppo gruppo, List<Gruppo> gruppi) {
                                return gruppi.any((g) => g.nome == gruppo.nome);
                              }

// Gestione unità gruppo
                              if (unitaGruppo[node.key!.value] == null) {
                                unitaGruppo[node.key!.value] = [];
                              }
                              if (!isGruppoExists(
                                  gruppo, unitaGruppo[node.key!.value]!)) {
                                unitaGruppo[node.key!.value]!.add(gruppo);
                              }

// Gestione unità organizzativa
                              if (!listaUnita
                                  .any((u) => u.nome == node.key!.value)) {
                                Unita unita = Unita(
                                  nome: node.key!.value,
                                  gruppoList: unitaGruppo[node.key!.value]!,
                                );
                                listaUnita.add(unita);
                              } else {
                                // Se esiste già, aggiungo il nuovo gruppo
                                for (Unita u in listaUnita) {
                                  if (u.nome == node.key!.value) {
                                    if (!isGruppoExists(gruppo, u.gruppoList)) {
                                      u.gruppoList.add(gruppo);
                                    }
                                  }
                                }
                              }

//fine parte utile per il back-end
                              // Creazione di un nuovo oggetto Employer
                              Employer emp = Employer(
                                name: _nameController.text,
                                surname: _surnameController.text,
                                role: selectedRole!,
                                group: selectedGroup!,
                              );

                              // Verifica se il dipendente è già inserito in quel gruppo
                              if (groupEmp[selectedGroup] != null &&
                                  groupEmp[selectedGroup]!.contains(emp)) {
                                // Mostra un messaggio di errore
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Errore'),
                                      content: Text(
                                          'Dipendente già inserito nel gruppo $selectedGroup.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Aggiungi il dipendente alla lista
                                setState(() {
                                  if (listaNomiNodi[node] == null) {
                                    listaNomiNodi[node] = [];
                                  }
                                  listaNomiNodi[node]!.add(emp);
                                });

                                Navigator.pop(context); // Chiudi il BottomSheet
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Compila tutti i campi')),
                              );
                            }
                          },
                          child: Text('Aggiungi'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Annulla'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await showRoleInputForm(node);
                            setState(() {
                              // Aggiorna i ruoli nel dropdown
                            });
                          },
                          child: Text('Modifica ruoli'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

// Metodo per selezionare il gruppo
  Future<void> showGroup(Node node, StateSetter setState) async {
    List<TextEditingController> _groupControllers =
        []; // Lista per i controller dei gruppi
    bool _canAddNewGroup =
        true; // Variabile per controllare l'aggiunta di nuovi gruppi

    // Inizializza il primo controller per il nome del gruppo
    _groupControllers.add(TextEditingController());

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Inserisci nomi dei gruppi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Lista dei campi di input per i gruppi
                  Expanded(
                    child: ListView.builder(
                      itemCount: _groupControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16.0), // Aggiungi spazio tra le righe
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _groupControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Nome Gruppo ${index + 1}',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    // Se l'ultimo campo non è vuoto, permetti l'aggiunta di un nuovo campo
                                    if (index == _groupControllers.length - 1 &&
                                        value.isNotEmpty) {
                                      setState(() {
                                        _canAddNewGroup = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                              if (index == _groupControllers.length - 1 &&
                                  _canAddNewGroup)
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    // Verifica se l'ultimo campo è vuoto
                                    if (_groupControllers.last.text.isEmpty) {
                                      // Mostra un dialogo di errore
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Errore'),
                                            content: Text(
                                                'Inserisci un nome di gruppo prima di aggiungerne un altro.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      // Aggiungi un nuovo campo solo se l'ultimo non è vuoto
                                      setState(() {
                                        _groupControllers
                                            .add(TextEditingController());
                                        _canAddNewGroup = true;
                                      });
                                    }
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Salva i nomi dei gruppi nella lista
                      for (var controller in _groupControllers) {
                        String groupName = controller.text.trim();
                        if (groupName.isNotEmpty) {
                          if (listaGroup[node] == null) {
                            listaGroup[node] = [];
                          }
                          if (!listaGroup[node]!.contains(groupName)) {
                            listaGroup[node]!.add(groupName);
                          } else {
                            // Mostra un AlertDialog se il nome del gruppo è già utilizzato
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Errore'),
                                  content:
                                      Text('Nome del gruppo già utilizzato.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Chiudi l'AlertDialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                      // Chiudi il BottomSheet
                      Navigator.pop(context);
                    },
                    child: Text('Salva'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Employer> employeeList = [];

  void seeDatas(Node node) {
    if (elimina) {
      listaNomiNodi[node] = [];
      setState(() {
        elimina = false;
      });
    }

    // Inizializza `groupEmp` per il nodo corrente
    Map<String, List<Employer>> localGroupEmp = {};

    // Assumendo che `listaNomiNodi[node]` contenga una lista di `Employer`
    employeeList = listaNomiNodi[node] ?? [];

    // Raggruppa i dipendenti per gruppo
    for (var employee in employeeList) {
      // Aggiungi l'impiegato al gruppo corrispondente solo per il nodo corrente
      if (!localGroupEmp.containsKey(employee.group)) {
        localGroupEmp[employee.group] = []; // Aggiunge il gruppo se non esiste
      }
      if (!localGroupEmp[employee.group]!.contains(employee)) {
        localGroupEmp[employee.group]!.add(employee); // Aggiunge l'employee
      }
    }

    // Visualizza il BottomSheet per il nodo corrente
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${node.key?.value.toString().toUpperCase()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  localGroupEmp.isNotEmpty
                      ? SizedBox(
                          height: 300, // Limite di altezza per il BottomSheet
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: localGroupEmp.keys.length,
                            itemBuilder: (BuildContext context, int index) {
                              String group =
                                  localGroupEmp.keys.elementAt(index);
                              List<Employer> employeesInGroup =
                                  localGroupEmp[group]!;
                              print(localGroupEmp[group].toString()); // Debug

                              groupEmp[group] = localGroupEmp[group]!;

                              return ExpansionTile(
                                leading: IconButton(
                                  onPressed: () {
                                    print(
                                        'Icona del grafo toccata per il gruppo: $group');
                                    navigateToThirdPage(node, group);
                                  },
                                  icon: Icon(Icons.graphic_eq),
                                ), // Icona simile a un grafo
                                title: Text(
                                  group,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: employeesInGroup.map((employee) {
                                  return ListTile(
                                    title: Text(
                                        '${employee.name} ${employee.surname} ${employee.role}'),
                                    trailing: Tooltip(
                                      message: 'Modifica dipendente',
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          _editEmployee(employee, node, index,
                                              setModalState);
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        )
                      : Text(
                          'Nessun dipendente inserito.'), // Messaggio se la lista è vuota
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Chiudi il BottomSheet
                    },
                    child: Text('Chiudi'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _editEmployee(
      Employer employee, Node node, int index, StateSetter setModalState) {
    // Inizializza i TextEditingController con i valori esistenti dell'Employer
    TextEditingController nameController =
        TextEditingController(text: employee.name);
    TextEditingController surnameController =
        TextEditingController(text: employee.surname);
    String? selectedRole =
        employee.role; // Imposta il ruolo selezionato attuale

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifica Dipendente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo per modificare il nome
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(height: 10),
              // Campo per modificare il cognome
              TextField(
                controller: surnameController,
                decoration: InputDecoration(labelText: 'Cognome'),
              ),
              SizedBox(height: 10),
              // DropdownButton per selezionare il ruolo
              DropdownButtonFormField<String>(
                value: selectedRole,
                hint: Text('Seleziona Ruolo'),
                items: listaNodeRole[node]?.isNotEmpty == true
                    ? listaNodeRole[node]!.map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList()
                    : null,
                onChanged: (value) {
                  setModalState(() {
                    selectedRole = value; // Aggiorna il ruolo selezionato
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                disabledHint: Text('Nessun ruolo disponibile'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Chiudi senza modificare nulla
              },
              child: Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                // Verifica che i campi non siano vuoti
                if (nameController.text.isNotEmpty &&
                    surnameController.text.isNotEmpty &&
                    selectedRole != null) {
                  setModalState(() {
                    // Aggiorna i dettagli dell'Employer nella lista
                    listaNomiNodi[node]![index] = Employer(
                      name: nameController.text,
                      surname: surnameController.text,
                      role: selectedRole!,
                      group: employee.group, // Mantieni il gruppo esistente
                    );

                    // Aggiorna immediatamente la lista dei dipendenti del gruppo
                    groupEmp[employee.group]
                        ?.removeAt(index); // Rimuovi l'elemento vecchio
                    groupEmp[employee.group]?.insert(
                        index,
                        listaNomiNodi[node]![
                            index]); // Inserisci quello modificato

                    // Aggiorna anche l'interfaccia per vedere subito i cambiamenti
                  });

                  Navigator.pop(context); // Chiudi il dialog
                } else {
                  // Mostra un messaggio se i campi non sono completi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Compila tutti i campi')),
                  );
                }
              },
              child: Text('Salva'),
            ),
          ],
        );
      },
    );
  }

  //Map<Graph, List<Employer>> listaGraphEmp = <Graph, List<Employer>>{};

  void navigateToThirdPage(Node node, String nomeGruppo) async {
    List<String> listaGruppiNode =
        listaGroup[node]!; // tutti i gruppi di quel nodo
    int x = 0;

    for (String s in listaGruppiNode) {
      if (s == nomeGruppo) {
        break;
      }
      x++; // trovo l'indice del gruppo che devo visualizzare/creare l'organigramma
    }

    //print("verifica");
    //print(listaGroup[node].toString());

    //print(groupEmp[nomeGruppo].toString());

    // Controllo se nodeGraphs[node] è null, altrimenti inizializzo
    if (nodeGraphs[node] == null) {
      nodeGraphs[node] = []; // Inizializzo la lista dei graph per il nodo
      for (int i = 0; i < listaGruppiNode.length; i++) {
        nodeGraphs[node]!.add(Graph()); // Aggiungo un Graph per ogni gruppo
      }

      Map<Node, List<Node>> pro = <Node, List<Node>>{};

      List<Graph> lista = nodeGraphs[node]!;

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Graphs(
            graphGrouph: lista[x], // qui passo il graph del gruppo corrente
            nodeGraphs: nodeGraphs,
            groupEmployers:
                groupEmp[nomeGruppo], // passo i dipendenti del gruppo

            // elementi della pagina attuale
            graph: graph,
            builderConfig: builderConfig,
            orientation: orientation,
            levelSeparation: levelSeparation,
            unitaGiaInserite: unitaGiaInserite,
            listanodes: listanodes,
            listaGroup: listaGroup,
            listaNomiNodi: listaNomiNodi,
            groupEmp: groupEmp,
            units: widget.units,
            pro: pro,
            gruppoDipendente: gruppoDipendente,
            unitaGruppo: unitaGruppo,
            listaUnita: listaUnita,
          ),
        ),
      );

      if (result != null) {
        setState(() {
          lista[x] = result['graphGroup'] ?? lista[x];
          nodeGraphs = result['nodeGraphs'] ?? nodeGraphs;

          // Elementi della pagina corrente
          graph = result['graph'] ?? graph;
          widget.units = result['units'] ?? widget.units;
          builderConfig = result['builderConfig'] ?? builderConfig;
          orientation = result['orientation'] ?? orientation;
          levelSeparation = result['levelSeparation'] ?? levelSeparation;
          unitaGiaInserite = result['unitaGiaInserite'] ?? unitaGiaInserite;
          listanodes = result['listanodes'] ?? listanodes;
          listaGroup = result['listaGroup'] ?? listaGroup;
          listaNomiNodi = result['listaNomiNodi'] ?? listaNomiNodi;
          groupEmp = result['groupEmp'] ?? groupEmp;
          gruppoDipendente = result['gruppoDipendente'] ?? gruppoDipendente;
          unitaGruppo = result['unitaGruppo'] ?? unitaGruppo;
          listaUnita = result['listaUnita'] ?? listaUnita;

          nodeGraphs[node] =
              lista; // Aggiorno nodeGraphs con la lista aggiornata

          // Controllo se `proviamo[nomeGruppo]` è null e lo inizializzo se necessario
          if (proviamo[nomeGruppo] == null) {
            proviamo[nomeGruppo] = pro;
          }
        });
      }
    } else {
      // Controllo esistenza di proviamo[nomeGruppo] e inizializzo se necessario
      Map<Node, List<Node>> pro2;
      if (proviamo[nomeGruppo] != null) {
        pro2 = proviamo[nomeGruppo]!;
      } else {
        proviamo[nomeGruppo] = {};
        pro2 = proviamo[nomeGruppo]!;
      }

      List<Graph> lista = nodeGraphs[node]!;
      if (lista.length != listaGruppiNode.length) {
        // se hanno lunghezze diverse:

        if (lista.length < listaGruppiNode.length) {
          // devo aggiungere
          int y = listaGruppiNode.length - lista.length;
          for (int i = 0; i < y; i++) {
            nodeGraphs[node]!.add(Graph());
          }
        } else {
          // devo togliere elementi, inoltre QUALI elementi devo capire, quindi mi serve la posizione ( scalano con le posizioni )
        }
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Graphs(
            graphGrouph: lista[x], // passo il graph del gruppo corrente
            groupEmployers:
                groupEmp[nomeGruppo], // passo i dipendenti del gruppo
            nodeGraphs: nodeGraphs,

            // elementi della pagina attuale
            graph: graph,
            builderConfig: builderConfig,
            orientation: orientation,
            levelSeparation: levelSeparation,
            unitaGiaInserite: unitaGiaInserite,
            listanodes: listanodes,
            listaGroup: listaGroup,
            pro: pro2,
            units: widget.units,
            listaUnita: listaUnita,
            listaNomiNodi: listaNomiNodi,
            groupEmp: groupEmp,
            gruppoDipendente: gruppoDipendente,
            unitaGruppo: unitaGruppo,
          ),
        ),
      );

      if (result != null) {
        setState(() {
          lista[x] = result['graphGrouph'] ?? lista[x];
          nodeGraphs = result['nodeGraphs'] ?? nodeGraphs;

          // Elementi della pagina corrente
          graph = result['graph'] ?? graph;
          widget.units = result['units'] ?? widget.units;
          builderConfig = result['builderConfig'] ?? builderConfig;
          orientation = result['orientation'] ?? orientation;
          levelSeparation = result['levelSeparation'] ?? levelSeparation;
          unitaGiaInserite = result['unitaGiaInserite'] ?? unitaGiaInserite;
          listanodes = result['listanodes'] ?? listanodes;

          nodeGraphs[node] =
              lista; // Aggiorno nodeGraphs con la lista aggiornata
          proviamo[nomeGruppo] = pro2; // Aggiorno `proviamo` con `pro2`
        });
      }
    }
  }

  void deleteNode(Node node) {
    setState(() {
      // Funzione ricorsiva per rimuovere un nodo e i suoi discendenti
      void removeNodeAndDescendants(Node n) {
        // Controlla se il nodo ha figli
        if (listanodes.containsKey(n)) {
          List<Node> figli =
              List.from(listanodes[n]!); // Crea una copia dei figli

          // Rimuovi ricorsivamente ogni figlio
          for (Node figlio in figli) {
            removeNodeAndDescendants(
                figlio); // Rimuovi il figlio e i suoi discendenti
          }
        }

        // Rimuovi il nodo dal grafo e dalle strutture di dati
        if (graph.contains(node: n)) {
          graph.removeNode(n);
          unitaGiaInserite.remove(n.key!.value);
        }

        // Rimuovi il nodo dalla lista dei nodi
        listanodes.remove(n);
        listaNodeRole.remove(n); // Rimuovi eventuali ruoli associati al nodo
      }

      // Inizia l'eliminazione dal nodo principale
      removeNodeAndDescendants(node);

      // Se il nodo ha un padre, rimuovilo dalla lista dei figli del padre
      Node? dad;
      for (var entry in listanodes.entries) {
        Node key = entry.key;
        if (listanodes[key]?.contains(node) ?? false) {
          dad = key; // Trova il padre del nodo da eliminare
          listanodes[key]!.remove(node); // Rimuove il nodo dal padre
          break;
        }
      }

      // Se esiste un padre, ricollega i nodi figli al padre
      if (dad != null) {
        for (Node figlio in listanodes[dad]!) {
          graph.addEdge(dad, figlio); // Ricollega i figli al padre
        }
      } else {
        // Se non esiste un padre (è il nodo radice o un nodo isolato)
        listanodes.clear(); // Rimuovi il nodo dalla lista dei nodi
        unitaGiaInserite.clear(); // Pulisci eventuali unita già inserite
      }
    });

    //updateGraphDisplay(); // Aggiorna la visualizzazione se necessario
  }

  Future<void> _addNode(String position, {Node? node}) async {
    var newNode = Node.Id(position);
    bool nomeValido = await verificaNomeUnita(newNode);

    if (nomeValido) {
      setState(() {
        //dovrei comunicare con il back-end , in questo caso dovrei aggiungere l'

        //var newNode = Node.Id(position);

        if (node == null) {
          listanodes[newNode] = [];
          graph.addNode(newNode);
        } else {
          listanodes[newNode] = [];
          listanodes[node]!.add(newNode);
          graph.addEdge(node, newNode);
        }
      });
    } else {
      await _showEditDialog(node: node);
    }
  }

  Future<bool> verificaNomeUnita(Node node) async {
    if (unitaGiaInserite.contains(node.key!.value)) {
      bool? verifica = await showDialog<bool>(
        // lo showDialog è asincrono , pertanto devo impostarlo in questo modo e le modifiche devono essere apportate anche all'add.
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Errore Nome Unità'),
            content: Text('unità già presente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Ritorna "false" se c'è errore
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return verifica ?? false;
    }

    unitaGiaInserite.add(node.key!.value);
    return true; // Ritorna true se il nome è valido
  }

  // Funzione per mostrare il dialog dell'orientamento
  _showOrientationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifica Orientamento'),
          content: DropdownButton<int>(
            value: _orientation,
            items: const [
              DropdownMenuItem(
                value: BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM,
                child: Text('Top to Bottom'),
              ),
              DropdownMenuItem(
                value: BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT,
                child: Text('Left to Right'),
              ),
              DropdownMenuItem(
                value: BuchheimWalkerConfiguration.ORIENTATION_BOTTOM_TOP,
                child: Text('Bottom to Top'),
              ),
              DropdownMenuItem(
                value: BuchheimWalkerConfiguration.ORIENTATION_RIGHT_LEFT,
                child: Text('Right to Left'),
              ),
            ],
            onChanged: (int? newValue) {
              setState(() {
                _orientation = newValue!;
                _updateGraphConfig();
              });
              Navigator.of(context).pop(); // Chiudi il dialog
            },
          ),
        );
      },
    );
  }

  String nomeA = "nomeAzienda";

  // Metodo per mostrare il dialogo di modifica dei dati
  Future<void> _showEditDialog({Node? node}) async {
    String? nomeUnita; // Variabile per memorizzare l'unità selezionata
    String? nomeAzienda; // Variabile per memorizzare il nome dell'azienda

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifica Dati'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mostra TextField solo se node è nullo
              if (node == null)
                TextField(
                  decoration:
                      const InputDecoration(hintText: 'Inserisci Nome Azienda'),
                  onChanged: (value) {
                    setState(() {
                      nomeAzienda = value; // Aggiorna il nome dell'azienda
                    });
                  },
                ),
              const SizedBox(height: 10), // Spaziatura tra i campi
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(hintText: 'Seleziona Unità'),
                value: nomeUnita,
                items: widget.units.keys.map((unita) {
                  return DropdownMenuItem<String>(
                    value: unita,
                    child: Text(unita),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    nomeUnita = value; // Aggiorna l'unità selezionata
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nomeUnita != null) {
                  if (node == null &&
                      nomeAzienda != null &&
                      nomeAzienda!.isNotEmpty) {
                    // Se node è nullo e il nome dell'azienda è stato inserito
                    nomeA = nomeAzienda!;
                    print(nomeA);
                    await _addNode(nomeUnita!); // Passa il nome dell'azienda
                    Navigator.of(context).pop(); // Chiudi il dialog
                  } else if (node != null) {
                    // Se node non è nullo
                    await _addNode(nomeUnita!,
                        node: node); // Modifica il nodo esistente
                    Navigator.of(context).pop(); // Chiudi il dialog
                  } else {
                    // Se il nome dell'azienda non è stato inserito
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Errore'),
                          content: const Text(
                              'Inserisci il nome dell\'azienda prima di procedere.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Chiudi il dialog di errore
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } else {
                  // Se l'unità non è stata selezionata
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Errore'),
                        content: const Text(
                            'Seleziona un\'unità prima di procedere.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Chiudi il dialog di errore
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Salva'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );
  }

  // Funzione per mostrare il dialog della level separation
  void _showSeparationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifica Separazione dei Livelli'),
          content: Slider(
            value: _levelSeparation,
            min: 50,
            max: 300,
            divisions: 5,
            label: _levelSeparation.round().toString(),
            onChanged: (double value) {
              setState(() {
                _levelSeparation = value.roundToDouble();
                _updateGraphConfig();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Funzione per aggiornare la configurazione del grafo
  void _updateGraphConfig() {
    builderConfig
      ..siblingSeparation = 40
      ..levelSeparation = _levelSeparation.toInt()
      ..subtreeSeparation = 150
      ..orientation = _orientation;
  }
}

class CustomNode {
  final String position;

  CustomNode(this.position);

  Widget toText() {
    // Cambiato il tipo di ritorno in Widget
    return RichText(
      text: TextSpan(
        text: position, // Il testo da visualizzare
        style: TextStyle(
          fontSize: 18, // Dimensione del font
          fontWeight: FontWeight.bold, // Grassetto
          color: Colors.blue, // Colore del testo
          fontStyle: FontStyle.italic, // Stile corsivo
        ),
      ),
    );
  }
}

class Employer {
  String name;
  String surname;
  String role;
  String group;
  String? nomeUnita;

  Employer({
    required this.name,
    required this.surname,
    required this.role,
    required this.group,
    this.nomeUnita,
  });

  // Override del metodo == per confrontare correttamente gli oggetti Employer
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Employer &&
        other.name == name &&
        other.surname == surname &&
        other.group == group &&
        other.role == role;
  }

  // Override di hashCode per assicurarsi che gli oggetti con gli stessi campi siano considerati uguali
  @override
  int get hashCode =>
      name.hashCode ^ surname.hashCode ^ group.hashCode ^ role.hashCode;
}

Map<String, List<String>> organigramma = {
  'direzione generale': [
    'amministratore delegato',
    'direttore esecutivo',
    'direttore finanziario',
    'direttore operativo',
  ],
  'risorse umane': [
    'responsabile hr',
    'reclutatore',
    'specialista della formazione',
    'gestore delle risorse',
    'analista delle prestazioni',
  ],
  'marketing': [
    'direttore',
    'brand manager',
    'social media manager',
    'content strategist',
    'responsabile eventi',
  ],
  'vendite': [
    'direttore',
    'responsabile account',
    'sales representative',
    'sales analyst',
    'responsabile sviluppo commerciale',
  ],
  'produzione': [
    'direttore',
    'ingegnere di produzione',
    'responsabile qualità',
    'operatore di macchine',
    'coordinatore di produzione',
  ],
  'it': [
    'direttore',
    'sviluppatore software',
    'amministratore di sistema',
    'analista di sicurezza',
    'specialista di rete',
    'project manager IT',
  ],
  'ricerca e sviluppo': [
    'direttore',
    'ricercatore senior',
    'sviluppatore di prodotto',
    'analista di mercato',
    'responsabile innovazione',
  ],
  'legale': [
    'direttore',
    'avvocato interno',
    'compliance officer',
    'paralegale',
    'consulente legale',
  ],
  'consiglio di amministrazione': [
    'presidente',
    'direttore',
    'vicepresidente',
    'membro del consiglio',
  ],
  'comitato tecnico scientifico': [
    'presidente comitato',
    'esperto tecnico',
    'ricercatore senior',
    'analista di settore',
  ],
  'acquisti': [
    'responsabile acquisti',
    'direttore',
    'buyer',
    'analista di acquisti',
    'responsabile fornitura',
  ],
  'area vendite': [
    'responsabile area vendite',
    'sales manager',
    'agente di vendita',
    'assistente vendite',
  ],
  'marketing customer care': [
    'responsabile marketing e customer care',
    'specialista customer care',
    'analista di mercato',
    'responsabile della soddisfazione del cliente',
  ],
  'finanza': [
    'responsabile finanza',
    'analista finanziario',
    'contabile senior',
    'controller',
  ],
  'logistica': [
    'direttore logistica',
    'responsabile magazzino',
    'coordinatore di spedizione',
    'specialista in supply chain',
  ],
  'qualità': [
    'responsabile qualità',
    'auditor interno',
    'specialista controllo qualità',
    'analista di qualità',
  ],
  'sviluppo personale': [
    'responsabile sviluppo personale',
    'formazione e sviluppo',
    'coordinatore di formazione',
    'mentor aziendale',
  ],
  'comunicazione interna': [
    'responsabile comunicazione',
    'specialista comunicazione',
    'analista di comunicazione',
    'gestore di contenuti',
  ],
};

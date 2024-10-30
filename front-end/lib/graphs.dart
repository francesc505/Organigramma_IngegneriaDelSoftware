import 'package:flutter/material.dart';
import 'package:front_end_ing_software/model/DipendenteDTO.dart';
import 'package:front_end_ing_software/model/GruppoDTO.dart';
import 'package:front_end_ing_software/model/UnitaOrganizzativaDTO.dart';
import 'package:graphview/GraphView.dart';
import 'package:front_end_ing_software/main.dart';

class Graphs extends StatefulWidget {
  final Graph graphGrouph; // Aggiungi un attributo per il grafo
  final List<Employer>? groupEmployers;
  final Map<Node, List<Graph>> nodeGraphs;
  //strutture che utilizzo qua 
  //List<Employer> added = [];

  //elementi per mantenere lo stato attivo della pagina precedente:
  final Map<String, List<String>> units;
  final Graph graph; // della pagina precedente
  final BuchheimWalkerConfiguration builderConfig;
  final int orientation;
  final double levelSeparation;
  final List<String> unitaGiaInserite;
  final Map<Node, List<Node>> listanodes;
  final Map<Node, List<Employer>> listaNomiNodi;
  final Map<Node, List<String>> listaGroup;
  final Map<String, List<Employer>> groupEmp;
  final Map<Node, List<Node>> pro;
  final Map<String, List<DipendenteDTO>> gruppoDipendente;
  final Map<String, List<GruppoDTO>> unitaGruppo;
  final List<UnitaOrgnizzativaDTO> listaUnita;



   const Graphs({
    Key? key,
    required this.graphGrouph,
    required this.groupEmployers,
    required this.nodeGraphs,
    // da utilizzare qua
   // required this.added,
    //stato precedente:
    required this.graph,
    required this.units,
    required this.builderConfig,
    required this.orientation,
    required this.levelSeparation,
    required this.unitaGiaInserite,
    required this.listanodes,
    required this.listaNomiNodi,
    required this.listaGroup,
    required this.groupEmp,
    required this.pro,
    required this.gruppoDipendente,
    required this.unitaGruppo,
    required this.listaUnita,
  }) : super(key: key); // Richiedi il grafo nel costruttore

  @override
  _Graphs createState() => _Graphs();
}

//variabili da utilizzare in questa classe
late Graph graphGroup = Graph();
final BuchheimWalkerConfiguration builderConfig = BuchheimWalkerConfiguration();
double levelSeparation = 100.0;
int orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
late List<Employer>? groupEmployers = [];
//da utilizzare qua:
 List<Employer> added = [];
Map<Node, List<Node>> listaNodes = <Node, List<Node>>{};

// variabili della vecchia classe: (provare prima a passarle nel navigator.pop())....

class _Graphs extends State<Graphs> {
  @override
  void initState() {
    super.initState();
    builderConfig
      ..siblingSeparation = 40
      ..levelSeparation = levelSeparation.toInt()
      ..subtreeSeparation = 150
      ..orientation = orientation;
    graphGroup = widget.graphGrouph;
    groupEmployers = widget.groupEmployers;
    listaNodes = widget.pro;
   // added = widget.added;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          'graphGrouph': graphGroup,
          'groupEmployers': groupEmployers,
          'nodeGraphs': widget.nodeGraphs,
          //elementi della pagina precedente
          'units': widget.units,
          'graph': widget.graph,
          'builderConfig': widget.builderConfig,
          'orientation': widget.orientation,
          'levelSeparation': widget.levelSeparation,
          'unitaInserite': widget.unitaGiaInserite,
          'listanodes': widget.listanodes,
          'listaNomiNodi': widget.listaNomiNodi,
          'listaGroup': widget.listaGroup,
          'groupEmp': widget.groupEmp,
          'gruppoDipendente': widget.gruppoDipendente,
          'unitaGruppo': widget.unitaGruppo,
          'listaUnita': widget.listaUnita,


          //proviamo
          'pro': listaNodes,
        });

        return false; // Consente di tornare indietro
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Grafico: ${groupEmployers!.first.group}'), // Usa il nome del grafo
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              graphGroup.nodeCount() > 0
                  ? InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(100),
                      minScale: 0.01,
                      maxScale: 5.6,
                      child: GraphView(
                        graph: graphGroup,
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

              // Row per le tre icone nella parte bassa centrale
              Positioned(
                left: 0,
                right: 0,
                bottom: 2, // Posiziona le icone più in basso
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centro le icone
                  children: [
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
                    const SizedBox(width: 10), // Spazio tra le icone
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
            ],
          );
        },
      ),
    );
  }

 

  void _showEditDialog({Node? node}) {
    // Variabile per l'Employer selezionato
    Employer? selectedEmployer;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Usa StatefulBuilder per aggiornare il dialogo
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Modifica Nodo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<Employer>(
                    value: selectedEmployer,
                    hint: const Text('Seleziona Dipendente'),
                    items: groupEmployers?.map((Employer employer) {
                      return DropdownMenuItem<Employer>(
                        value: employer,
                        child: Text('${employer.name} ${employer.surname}'),
                      );
                    }).toList(),
                    onChanged: (Employer? newEmployer) {
                      setState(() {
                        selectedEmployer = newEmployer;
                      });
                    },
                  ),
                  const SizedBox(height: 20), // Spazio tra dropdown e testo
                  if (selectedEmployer != null &&
                      !added.contains(selectedEmployer))
                    Text(
                      'Ruolo: ${selectedEmployer!.role} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Chiudi il dialogo
                  },
                  child: const Text('Annulla'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedEmployer != null) {
                      added.add(selectedEmployer!);
                      _addNode(selectedEmployer!,
                          node:
                              node); // Richiama il metodo _addNode con l'Employer
                      Navigator.of(context).pop(); // Chiudi il dialogo
                    } else {
                      // Mostra un messaggio se l'Employer non è selezionato
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Seleziona un dipendente!')),
                      );
                    }
                  },
                  child: const Text('Salva'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Map<Node, List<Node>> listaNodes = <Node, List<Node>>{};

  List<Employer> employerList = [];

  void _addNode(Employer emp, {Node? node}) {
    // Crea un'istanza di CustomNode
    var customNode = CustomNode(emp.name, emp.surname, emp.role);

    // Genera il TextSpan per visualizzare il nodo
    var nodeTextSpan = customNode.toTextSpan();

    // Converti il TextSpan in un formato stringa per il nodo
    String nodeName = nodeTextSpan
        .toPlainText(); // Assicurati di avere un modo per convertire il TextSpan in stringa, oppure utilizza solo il testo per il nodo.

    var newNode = Node.Id(nodeName);
    setState(() {
      //var newNode = Node.Id(position);

      if (node == null) {
        listaNodes[newNode] = [];
        graphGroup.addNode(newNode);
      } else {
        listaNodes[newNode] = [];
        listaNodes[node]!.add(newNode);
        graphGroup.addEdge(node, newNode);
      }
    });
  }

  void deleteNode(Node node) {
    setState(() {
      // Funzione ricorsiva per rimuovere un nodo e i suoi discendenti
      void removeNodeAndDescendants(Node n) {
        // Controlla se il nodo ha figli
        if (listaNodes.containsKey(n)) {
          List<Node> figli =
              List.from(listaNodes[n]!); // Crea una copia dei figli

          // Rimuovi ricorsivamente ogni figlio
          for (Node figlio in figli) {
            removeNodeAndDescendants(
                figlio); // Rimuovi il figlio e i suoi discendenti
          }
        }

        // Rimuovi il nodo dal grafo e dalle strutture di dati
        if (graphGroup.contains(node: n)) {
          graphGroup.removeNode(n);
        }

        // Rimuovi il nodo dalla lista dei nodi
        listaNodes.remove(n);
        // listaNodeRole.remove(n); // Rimuovi eventuali ruoli associati al nodo
      }

      // Inizia l'eliminazione dal nodo principale
      removeNodeAndDescendants(node);

      // Se il nodo ha un padre, rimuovilo dalla lista dei figli del padre
      Node? dad;
      for (var entry in listaNodes.entries) {
        Node key = entry.key;
        if (listaNodes[key]?.contains(node) ?? false) {
          dad = key; // Trova il padre del nodo da eliminare
          listaNodes[key]!.remove(node); // Rimuove il nodo dal padre
          break;
        }
      }

      // Se esiste un padre, ricollega i nodi figli al padre
      if (dad != null) {
        for (Node figlio in listaNodes[dad]!) {
          graphGroup.addEdge(dad, figlio); // Ricollega i figli al padre
        }
      } else {
        // Se non esiste un padre (è il nodo radice o un nodo isolato)
        listaNodes.clear(); // Rimuovi il nodo dalla lista dei nodi
      }
    });

    //updateGraphDisplay(); // Aggiorna la visualizzazione se necessario
  }
}

class CustomNode {
  final String name;
  final String surname;
  final String role;

  CustomNode(this.name, this.surname, this.role);

  TextSpan toTextSpan() {
    return TextSpan(
      children: [
        TextSpan(
          text: '$name $surname\n',
          style: const TextStyle(
              fontSize: 16, color: Colors.blue), // Stile per nome e cognome
        ),
        TextSpan(
          text: role.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // Stile per il ruolo
            color: Colors.blue, // Colore del testo
          ),
        ),
      ],
    );
  }
}

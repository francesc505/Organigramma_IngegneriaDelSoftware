import 'package:flutter/material.dart';
import 'package:front_end_ing_software/model/DipendenteDTO.dart';
import 'package:front_end_ing_software/model/GruppoDTO.dart';
import 'package:front_end_ing_software/model/UnitaOrganizzativaDTO.dart';
import 'package:front_end_ing_software/model/User.dart';
import 'main.dart'; // Assicurati di importare MyHomePage
import 'package:graphview/GraphView.dart';

class InitialPage extends StatefulWidget {
  final bool flag;
  final User user;
  const InitialPage({
    Key? key,
    required this.flag,
    required this.user,
  }) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late bool flag = widget.flag;
  late User user = widget.user;

  final TextEditingController unitController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  Map<String, List<String>> units =
      {}; // Mappa per memorizzare le unità e i ruoli
  final List<String> roles = []; // Lista per memorizzare i ruoli
  int? editingIndex; // Indice dell'unità da modificare
  int? editingRoleIndex; // Indice del ruolo da modificare
  Map<Node, List<Employer>> listaNomiNodi = <Node, List<Employer>>{};
  Map<Node, List<String>> listaGroup = <Node, List<String>>{};
  Map<String, List<Employer>> groupEmp = <String, List<Employer>>{};
  List<String> unitaInserite = [];
  Map<Node, List<Node>> listanodes = <Node, List<Node>>{};
  Map<String, Map<Node, List<Node>>> proviamo =
      <String, Map<Node, List<Node>>>{};
  Map<Node, List<Graph>> nodeGraphs = <Node, List<Graph>>{};
  Map<String, List<DipendenteDTO>> gruppoDipendente = <String, List<DipendenteDTO>>{};
  Map<String, List<GruppoDTO>> unitaGruppo = <String, List<GruppoDTO>>{};
  List<UnitaOrgnizzativaDTO> listaUnita = [];

  Graph graph = Graph();
  BuchheimWalkerConfiguration builderConfig = BuchheimWalkerConfiguration();
  double levelSeparation = 100.0;
  int orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  @override
  void initState() {
    super.initState();
    builderConfig
      ..siblingSeparation = 40
      ..levelSeparation = levelSeparation.toInt()
      ..subtreeSeparation = 150
      ..orientation = orientation;
  }

  void addUnit() {
    if (unitController.text.isNotEmpty) {
      setState(() {
        if (editingIndex != null) {
          // Se si sta modificando un'unità esistente
          String oldUnit =
              units.keys.elementAt(editingIndex!); // Ottieni l'unità esistente
          units.remove(oldUnit); // Rimuovi l'unità esistente
          units[unitController.text] =
              List.from(roles); // Aggiorna l'unità con i ruoli
          editingIndex = null; // Resetta l'indice di modifica
        } else {
          // Aggiungi una nuova unità
          units[unitController.text] =
              List.from(roles); // Aggiungi la nuova unità con i ruoli
        }
        unitController.clear(); // Pulisci il campo di input dell'unità
        roles.clear(); // Pulisci la lista dei ruoli
      });
    } else {
      // Mostra un messaggio di errore se il campo unit è vuoto
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci un\'unità!')),
      );
    }
  }

  void addRole() {
    if (roleController.text.isNotEmpty) {
      setState(() {
        if (editingRoleIndex != null) {
          // Se si sta modificando un ruolo esistente
          roles[editingRoleIndex!] = roleController.text; // Aggiorna il ruolo
          editingRoleIndex = null; // Resetta l'indice di modifica
        } else {
          roles.add(roleController.text); // Aggiungi il ruolo alla lista
        }
        roleController.clear(); // Pulisci il campo di input del ruolo
      });
    } else {
      // Mostra un messaggio di errore se il campo ruolo è vuoto
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci un ruolo!')),
      );
    }
  }

  void editUnit(int index) {
    setState(() {
      editingIndex = index; // Imposta l'indice dell'unità da modificare
      String unitKey =
          units.keys.elementAt(index); // Ottieni la chiave dell'unità
      unitController.text = unitKey; // Carica l'unità nel campo
      roles.clear(); // Pulisci la lista dei ruoli
      roles.addAll(List<String>.from(units[unitKey]!)); // Carica i ruoli
    });
  }

  void editRole(int index) {
    setState(() {
      editingRoleIndex = index; // Imposta l'indice del ruolo da modificare
      roleController.text = roles[index]; // Carica il ruolo nel campo
    });
  }

  void _navigateToSecondPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          units: units,
          graph: graph,
          builderConfig: builderConfig,
          orientation: orientation,
          levelSeparation: levelSeparation,
          unitaInserite: unitaInserite,
          listanodes: listanodes,
          listaNomiNodi: listaNomiNodi,
          listaGroup: listaGroup,
          groupEmp: groupEmp,
          proviamo: proviamo,
          nodeGraphs: nodeGraphs,
          gruppoDipendente: gruppoDipendente,
          unitaGruppo: unitaGruppo,
          listaUnita: listaUnita,
          flag: flag,
          user: user,
        ),
      ),
    );

    // Aggiorna la lista solo se ci sono modifiche
    if (result != null) {
      setState(() {
        units = result['units'] ?? units; // Assicurati di usare 'units'
        graph = result['graph'] ?? graph; // Usa un valore di fallback
        builderConfig = result['builderConfig'] ??
            builderConfig; // Usa un valore di fallback
        orientation =
            result['orientation'] ?? orientation; // Usa un valore di fallback
        levelSeparation = result['levelSeparation'] ??
            levelSeparation; // Usa un valore di fallback
        unitaInserite = result['unitaInserite'] ?? unitaInserite;
        listanodes = result['listanodes'] ?? listanodes;
        listaNomiNodi = result['listaNomiNodi'] ?? listaNomiNodi;
        groupEmp = result['groupEmp'] ?? groupEmp;
        proviamo = result['proviamo'] ?? proviamo;
        nodeGraphs = result['nodeGraphs'] ?? nodeGraphs;
        gruppoDipendente = result['gruppoDipendente'] ?? gruppoDipendente;
        unitaGruppo = result['unitaGruppo'] ?? unitaGruppo;
        listaUnita = result['listaUnita'] ?? listaUnita;
        flag = result['flag'] ?? flag;
        user = result['user'] ?? user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Impostazioni Organigramma',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _navigateToSecondPage,
          ),
        ],
        leading: IconButton(
          // Aggiungi questo blocco per l'icona arrow_back
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              flag = false;
            });
            Navigator.pop(context); // Torna alla pagina precedente
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Inserisci Unità',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (flag)
                      TextField(
                        controller: roleController,
                        decoration: const InputDecoration(
                          labelText: 'Inserisci Ruolo',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    if (flag)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          backgroundColor: Colors.blue, // Colore principale
                          foregroundColor: Colors.white, // Colore del testo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: addRole,
                        child: const Text('Aggiungi Ruolo'),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (flag)
              Expanded(
                child: Card(
                  elevation: 4,
                  child: ListView.builder(
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(roles[index], style: TextStyle(fontSize: 18)),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editRole(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Center(
              // Centra il pulsante
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Colors.blue, // Colore principale
                  foregroundColor: Colors.white, // Colore del testo
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: addUnit,
                child: const Text('Aggiungi/Modifica Unità e Ruolo'),
              ),
            ),
            const SizedBox(height: 20),
            //if(flag)
            Expanded(
              child: Card(
                elevation: 4,
                child: ListView.builder(
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    String unitKey = units.keys.elementAt(index);
                    return ListTile(
                      title: Text(unitKey, style: TextStyle(fontSize: 18)),
                      subtitle: Text(
                        units[unitKey]!.join(', '),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => editUnit(index),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

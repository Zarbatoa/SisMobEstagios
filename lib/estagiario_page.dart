import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_mobile_estagios/utilidades.dart';
import 'package:sistema_mobile_estagios/constantes.dart' as constantes;

class EstagiarioPage extends StatefulWidget {
  
  const EstagiarioPage({ Key? key }) : super(key: key);

  @override
  State<EstagiarioPage> createState() => _EstagiarioPageState();
}

class _EstagiarioPageState extends State<EstagiarioPage> {
  List<ListItem> items = [];

  void getEstagiarioApi() async {
    var uri = Uri.parse('http://10.0.2.2:8000/estagiario');
    var response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Token 0f880f8d77951bc2664b5b315d1ae16f5bc99de8',
        'Content-type': 'application/json; charset=utf-8'
      }
    );

    List<dynamic> data = jsonDecode(response.body);
    List<LinkedHashMap<String,dynamic>> listaJsons = [];
    for (var d in data) {
      listaJsons.add(LinkedHashMap.from(d));
    }

    int qtdAtributos = 15;

    setState(() {
      items = List<ListItem>.generate(listaJsons.length*qtdAtributos, 
        (i) => i % qtdAtributos == 0 ? 
        HeadingItem('Estagiário ${i~/qtdAtributos + 1}') : 
        MessageItem(capsFirstLetter(listaJsons[i~/qtdAtributos].keys.elementAt(i%qtdAtributos)),
          (listaJsons[i~/qtdAtributos].keys.elementAt(i%qtdAtributos) == 'curso') ?
          resgatarNomeCurso(listaJsons[i~/qtdAtributos][listaJsons[i~/qtdAtributos].keys.elementAt(i%qtdAtributos)]) :
          (listaJsons[i~/qtdAtributos].keys.elementAt(i%qtdAtributos) == 'endereco') ?
          formatarEndereco(listaJsons[i~/qtdAtributos][listaJsons[i~/qtdAtributos].keys.elementAt(i%qtdAtributos)]):
          const Utf8Decoder().convert(listaJsons[i~/qtdAtributos][listaJsons[i~/qtdAtributos].keys.elementAt(i%qtdAtributos)].toString().codeUnits)
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estagiário'),
        backgroundColor: constantes.lightBlueTheme,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  child: Icon(Icons.supervised_user_circle_outlined,size: 56),
                  padding: EdgeInsets.only(top: 10, left: 10),
                ),
                myPadding('Sobre Estagiário:', const EdgeInsets.only(top: 20, left: 20))
              ],
            ),
            myPadding('O estagiário é o estudante ou universitário que almeja ter sua primeira oportunidade no mercado de trabalho ou exercer de forma íntegra o que está aprendendo em seu curso.',const EdgeInsets.all(25)),
            ElevatedButton(
              onPressed: (){}, 
              child: const Text('CADASTRAR'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color?>(constantes.darkBlueTheme),
                fixedSize: MaterialStateProperty.all(const Size(150, 35))
              ),
            ),
            ElevatedButton(
              onPressed: getEstagiarioApi, 
              child: const Text('LISTAR'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color?>(constantes.darkBlueTheme),
                fixedSize: MaterialStateProperty.all(const Size(150, 35))
              ),
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  items = [];
                });
              }, 
              child: const Text('LIMPAR'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color?>(constantes.darkBlueTheme),
                fixedSize: MaterialStateProperty.all(const Size(150, 35))
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // Let the ListView know how many items it needs to build.
              itemCount: items.length,
              // Provide a builder function. This is where the magic happens.
              // Convert each item into a widget based on the type of item it is.
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                );
              },
            ),
          ],
        ),
      )
    );
  }

  Widget myPadding(String texto, EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding, //const EdgeInsets.all(25),
      child: Text(
        texto,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 18,
          //fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}

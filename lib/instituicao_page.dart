import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_mobile_estagios/utilidades.dart';

class InstituicaoPage extends StatefulWidget {
  
  const InstituicaoPage({ Key? key }) : super(key: key);

  @override
  State<InstituicaoPage> createState() => _InstituicaoPageState();
}

class _InstituicaoPageState extends State<InstituicaoPage> {
  List<ListItem> items = [];
  // bool? _check = false;
  // String? _checkRadio = '';
  // bool valueSwitch = false;

  // double _valueSlider = 0;
  // String _labelSlider = '0';


  void get_instituicao_api() async {
    var uri = Uri.parse('http://10.0.2.2:8000/instituicaoEnsino');
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

    for (var k in listaJsons) {
      print(Utf8Decoder().convert(k.toString().codeUnits));
    }

    setState(() {
      items = List<ListItem>.generate(listaJsons.length*9, 
        (i) => i % 9 == 0 ? 
        HeadingItem('Instituicao ${i~/9}') : 
        MessageItem(listaJsons[i~/9].keys.elementAt(i%9),
          listaJsons[i~/9].keys.elementAt(i%9) != 'endereco' ?
          '${Utf8Decoder().convert( listaJsons[i~/9][listaJsons[i~/9].keys.elementAt(i%9)].toString().codeUnits )}' :
          Utilidades.formatarEndereco(listaJsons[i~/9][listaJsons[i~/9].keys.elementAt(i%9)])));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituição de Ensino'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  child: Icon(Icons.school,size: 56),
                  padding: EdgeInsets.only(top: 10, left: 10),
                ),
                myPadding('Sobre Instituição de Ensino:')
              ],
            ),
            myPadding('As instituições de ensino são importantes entes sociais (ou instituições sociais) que atuam na promoção da educação de crianças, jovens e adultos.'),
            ElevatedButton(
              onPressed: (){}, 
              child: const Text('CADASTRAR'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color?>(Colors.blue[900]),
              ),
            ),
            ElevatedButton(
              onPressed: get_instituicao_api, 
              child: const Text('LISTAR')
            ),
            ElevatedButton(
              onPressed: (){
                setState(() {
                  items = [];
                });
              }, 
              child: const Text('LIMPAR')
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
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
            // testes com inputs
            // CheckboxListTile(
            //   activeColor: Colors.green,
            //   checkColor: Colors.black,
            //   selected: false,
            //   secondary: const Icon(Icons.add_box),
            //   title: const Text('CheckBox'),
            //   subtitle: const Text('SubTitle'),
            //   value: _check,
            //   onChanged: (bool? valor) {
            //     setState(() {
            //     _check = valor;
            //     });
            //   }
            // ),
            // RadioListTile(
            //   secondary: Icon(Icons.woman),
            //   title: const Text('Feminio'),
            //   value: 'f',
            //   groupValue: _checkRadio,
            //   onChanged: (String? valor){
            //     setState(() {
            //       _checkRadio = valor;
            //     });
            //   }
            // ),
            // RadioListTile(
            //   secondary: Icon(Icons.man),
            //   title: const Text('Masculino'),
            //   subtitle: const Text('Escolha esta opção!'),
            //   value: 'm',
            //   groupValue: _checkRadio,
            //   onChanged: (String? valor){
            //     setState(() {
            //       _checkRadio = valor;
            //     });
            //   }
            // ),
            // SwitchListTile(
            //   value: valueSwitch,
            //   title: const Text('Switch'),
            //   secondary: const Icon(Icons.bike_scooter_rounded),
            //   onChanged: (bool value) {
            //     setState(() {
            //       valueSwitch = value;
            //     });
            //   }
            // ),
            // Slider(
            //   value: _valueSlider,
            //   min: 0,
            //   max: 10,
            //   divisions: 100,
            //   label: _labelSlider,
            //   activeColor: Colors.red,
            //   inactiveColor: Colors.green,
            //   onChanged: (double v){
            //     setState(() {
            //       _valueSlider = v;
            //       _labelSlider = v.toStringAsFixed(1); 
            //     });
            //   }
            // ),
            // myPadding('Teste botões'),
            // ElevatedButton(
            //   onPressed: (){},
            //   child: const Text('Botão Elevated')
            // ),
            // OutlinedButton(
            //   onPressed: (){}, 
            //   child: const Text('Botão Outlined')
            // ),
            // TextButton(
            //   onPressed: (){},
            //   child: const Text('Botão Text')
            // )
          ],
        ),
      )
    );
  }

  Widget myPadding(String texto) {
    return Padding(
      padding: const EdgeInsets.all(25),
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
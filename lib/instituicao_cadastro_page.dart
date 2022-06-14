
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sistema_mobile_estagios/constantes.dart' as constantes;
import 'package:http/http.dart' as http;
// pego a mascara para text field aqui: https://pub.dev/packages/mask_text_input_formatter
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InstituicaoCadastroPage extends StatefulWidget {
  const InstituicaoCadastroPage({ Key? key }) : super(key: key);

  @override
  State<InstituicaoCadastroPage> createState() => _InstituicaoCadastroPageState();
}

class _InstituicaoCadastroPageState extends State<InstituicaoCadastroPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = 'SC';
  String avisoCampoVazio = 'Por favor, não deixe este campo vazio!';
  String avisoPreencherTodoCampo = 'Por favor, preencha este campo completamente';
  EdgeInsets defaultPadding = const EdgeInsets.only(right: 10, left: 10, top: 10);

  // o ideal seria refatorar...
  String? _razaoSocial=null;
  String? _cnpj=null;
  String? _email=null;
  String? _representante=null;
  String? _telFixo=null;
  String? _telCel=null;
  String? _infoRelevante=null;

  String? _cep=null;
  String? _logradouro=null;
  String? _numero=null;
  String? _complemento=null;
  String? _bairro=null;
  String? _cidade=null;
  String? _uf=null;

  var cnpjMaskFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  var telFixoMaskFormatter = MaskTextInputFormatter(
    mask: '(##) ####-####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  var telCelMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  var cepMaskFormatter = MaskTextInputFormatter(
    mask: '#####-###', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  void printAtributosApi(){
    print('''
      RAZAO_SOCIAL = ${_razaoSocial},
      CNPJ = ${_cnpj},
      EMAIL = ${_email},
      REPRESENTANTE = ${_representante},
      TEL_FIXO = ${_telFixo},
      TEL_CEL = ${_telCel},
      INFO_REL = ${_infoRelevante},

      CEP = ${_cep},
      LOGRADOURO = ${_logradouro},
      NUMERO = ${_numero},
      COMPLEMENTO = ${_complemento},
      BAIRRO = ${_bairro},
      CIDADE = ${_cidade},
      UF = ${_uf},
    ''');
  }

  void get_cep(String? cep) async {
    var uri = Uri.parse('https://viacep.com.br/ws/${cep}/json/');
    var response = await http.get(uri);
    var data = jsonDecode(response.body);
    print(data);

  }

  void postInstituicaoApi() async {
    //printAtributosApi();


    var uriEnd = Uri.parse('http://10.0.2.2:8000/endereco/');

    var responseEnd = await http.post(
      uriEnd,
      headers: {
        HttpHeaders.authorizationHeader: 'Token 0f880f8d77951bc2664b5b315d1ae16f5bc99de8',
        'Content-type': 'application/json; charset=utf-8'
      }, body: jsonEncode(<String, String?>{
        'cep' : _cep,
        'logradouro' : _logradouro,
        'numero' : _numero,
        'complemento' :_complemento,
        'bairro' : _bairro,
        'cidade' : _cidade,
        'uf' : _uf,
      })
    );

    var dataEnd = jsonDecode(responseEnd.body);
    LinkedHashMap enderecoCadastrado = LinkedHashMap.from(dataEnd);

    var uriInst= Uri.parse('http://10.0.2.2:8000/instituicaoEnsino/');

    var response = await http.post(
      uriInst,
      headers: {
        HttpHeaders.authorizationHeader: 'Token 0f880f8d77951bc2664b5b315d1ae16f5bc99de8',
        'Content-type': 'application/json; charset=utf-8'
      }, body: jsonEncode(<String, String?>{
        'razao_social' : _razaoSocial,
        'cnpj' : _cnpj,
        'email' : _email,
        'representante' : _representante,
        'telefone_fixo' : _telFixo,
        'telefone_cel' :_telCel,
        'info_relevante' :_infoRelevante,

        'endereco' : '${enderecoCadastrado['id']}'
      })
    );

    print(response.body);

    // List<dynamic> data = jsonDecode(response.body);
    // List<LinkedHashMap<String,dynamic>> listaJsons = [];
    // for (var d in data) {
    //   listaJsons.add(LinkedHashMap.from(d));
    // }

    // int qtdAtributos = 9;

    // setState(() {
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instituição de Ensino'),
        backgroundColor: constantes.lightBlueTheme,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Cadastro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'RAZÃO SOCIAL'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _razaoSocial = value;
                  },
                )
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  inputFormatters: [cnpjMaskFormatter],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '12.345.678/9000-00',
                    labelText: 'CNPJ'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    if(value.length != 18){
                      return avisoPreencherTodoCampo;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _cnpj = value;
                  },
                )
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-MAIL'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    List<String> emailSplitted = value.split('@');
                    if(emailSplitted.length != 2 || emailSplitted[0].isEmpty || emailSplitted[1].isEmpty){
                      return 'E-mail inválido!';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _email = value;
                  },
                )
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'REPRESENTANTE'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _representante = value;
                  },
                )
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  inputFormatters: [telFixoMaskFormatter],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '(00) 0000-0000',
                    labelText: 'TELEFONE FIXO'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    if(value.length != 14) {
                      return avisoPreencherTodoCampo;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _telFixo = value;
                  },
                )
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  inputFormatters: [telCelMaskFormatter],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '(00) 00000-0000',
                    labelText: 'TELEFONE CELULAR'
                  ),
                  validator: (String? value) {
                    if(value != null && value.isNotEmpty && value.length != 15) {
                      return avisoPreencherTodoCampo;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _telCel = value;
                  },
                )
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'INFORMAÇÕES RELEVANTES'
                  ),
                  validator: (String? value) {
                    return null;
                  },
                  onSaved: (String? value) {
                    _infoRelevante = value;
                  },
                )
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Endereço',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  inputFormatters: [cepMaskFormatter],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '00000-000',
                    labelText: 'CEP'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    if(value.length != 9) {
                      return avisoPreencherTodoCampo;
                    }
                    return null;
                  },
                  // onChanged: (String? value){
                  //   if(value != null && value.length==9) {
                  //     get_cep(value);
                  //   }
                  // },
                  onSaved: (String? value) {
                    _cep = value;
                  },
                ),
              ),
              // Padding(
              //   padding: defaultPadding,
              //   child: ElevatedButton(
              //     onPressed: (){
              //       _formKey.currentState?.save();
              //     }, 
              //     child: const Text('BUSCAR CEP'),
              //     style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all<Color?>(constantes.darkBlueTheme),
              //       fixedSize: MaterialStateProperty.all(const Size(350, 35))
              //     ),
              //   )
              // ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'LOGRADOURO'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _logradouro = value;
                  },
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'NÚMERO'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }

                    if(value.length > 5) {
                      return 'O número tem que ser menor que 5 caracteres!';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _numero = value;
                  },
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'COMPLEMENTO'
                  ),
                  validator: (String? value) {
                    return null;
                  },
                  onSaved: (String? value) {
                    _complemento = value;
                  },
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'BAIRRO'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _bairro = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'CIDADE'
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return avisoCampoVazio;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _cidade = value;
                  },
                ),
              ),
              Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF676767),
                    width: 2.0,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))
                ),
                child: DropdownButtonFormField<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(
                    color: Color(0xFF676767),
                    //fontWeight: FontWeight.bold, 
                    fontSize: 20
                  ),
                  // underline: Container(
                  //   height: 3,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  onSaved: (String? value) {
                    _uf = value;
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['SC', 'RS', 'PR', 'SP', 'RJ']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      _formKey.currentState!.save();
                      postInstituicaoApi();
                    }
                  },
                  child: const Text('CADASTRAR'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color?>(constantes.darkBlueTheme),
                    fixedSize: MaterialStateProperty.all(const Size(350, 35))
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
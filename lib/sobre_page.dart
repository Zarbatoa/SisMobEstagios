import 'package:flutter/material.dart';
import 'package:sistema_mobile_estagios/constantes.dart' as constantes;

class SobrePage extends StatelessWidget {
  final String texto1 = '''
    Trata-se de um projeto de Sistemas de Controle de Estágios, em que uma instituição de ensino com perfil de administrador irá cadastrar formalmente um estagiário com a empresa, para que ele registre todas as informações que possui sobre o aluno no estágio, como: supervisor, horário do estágio, jornada semanal, remuneração, data de início, data de término, setor, tipo do estágio e outras informações.
    
    O administrador pode incluir o cadastro do estágio sob seu controle, para que possa pesquisar dados por nome ou CPF do estagiário, caso queira fazer alterações, como alterar o horário do estágio. 
    
    ''';
  final String texto2 = '''
    Outro ponto importante é a notificação, que é essencial para o administrador, pois esta notificação é um mês (30 dias) antes da data de vencimento de alguns documentos, por exemplo, o relatório assinado pelo estagiário.
    
    Através deste aviso no sistema, faz com que o administrador tenha um melhor controle e um manuseio melhor das atividades. 
    ''';


  const SobrePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o Sistema'),
        backgroundColor: constantes.lightBlueTheme,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            myPaddingBold('Sobre o Sistema:', const EdgeInsets.all(50)),
            Image.asset('images/top_pagina_sobre.png', fit: BoxFit.fitHeight),
            myPadding(texto1, const EdgeInsets.all(50)),
            SizedBox(
              height: 300,
              child:Image.asset('images/meio_pagina_sobre.png', fit: BoxFit.fitHeight)
            ),
            myPadding(texto2, const EdgeInsets.all(50))
          ]
        )
      )
    );
  }




  Widget imagePadding(String asset) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Image.asset(asset),
          //Text(description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
        ]
      )
    );
  }  
  
  Widget myPaddingBold(String texto, EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding, //const EdgeInsets.all(25),
      child: Text(
        texto,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
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
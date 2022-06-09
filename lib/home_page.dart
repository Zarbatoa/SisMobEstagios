import 'package:flutter/material.dart';
import 'package:sistema_mobile_estagios/instituicao_page.dart';
import 'package:sistema_mobile_estagios/constantes.dart' as constantes;

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema Controle de Estágios'),
        backgroundColor: constantes.lightBlueTheme,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  height: 180,
                  child: Image.asset('images/logo_sce.png', fit: BoxFit.fitHeight)
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imagePadding('images/sobre_logo.png', 'Sobre'),
                imageGestureDetector('images/instituicao_ensino_logo.png', 'Instituição', context, const InstituicaoPage())
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imagePadding('images/curso_logo.png', 'Curso'),
                imagePadding('images/estagiario_logo.png', 'Estagiário'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imagePadding('images/empresa_logo.png', 'Empresa'),
                imagePadding('images/estagio_logo.png', 'Estágio')
              ]
            )
          ]
        )
      ),
    );
  }

  Widget imageGestureDetector(String asset, String description, BuildContext context, Widget outraPagina) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: GestureDetector(
        onTap: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => outraPagina)
              );
          });
        },
        child: Column(
          children: [
            Image.asset(asset),
            Text(description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
          ]
        ),
      )
    );
  }

  Widget imagePadding(String asset, String description) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Image.asset(asset),
          Text(description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
        ]
      )
    );
  }

}
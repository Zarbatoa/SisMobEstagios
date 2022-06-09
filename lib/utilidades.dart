import 'dart:convert';
import 'dart:collection';

String formatarEndereco(LinkedHashMap<String,dynamic> endereco){
  String enderecoFormatado = '${endereco['logradouro']}, ${endereco['numero']}, ${endereco['complemento']}, ${endereco['bairro']}, ${endereco['cep']}, ${endereco['cidade']}, ${endereco['uf']}';
  enderecoFormatado = const Utf8Decoder().convert(enderecoFormatado.codeUnits);
  return enderecoFormatado;
}

String resgatarRazaoSocialInstituicao(LinkedHashMap<String,dynamic> instituicao){
  String razaoSocialFormatado = instituicao['razao_social'];
  razaoSocialFormatado = const Utf8Decoder().convert(razaoSocialFormatado.codeUnits);
  return razaoSocialFormatado;
}

String resgatarNomeCurso(LinkedHashMap<String,dynamic> curso){
  String cursoFormatado = curso['nome'];
  cursoFormatado = const Utf8Decoder().convert(cursoFormatado.codeUnits);
  return cursoFormatado;
}

String resgatarNomeEstagiario(LinkedHashMap<String,dynamic> estagiario){
  String estagiarioFormatado = estagiario['nome'];
  estagiarioFormatado = const Utf8Decoder().convert(estagiarioFormatado.codeUnits);
  return estagiarioFormatado;
}

String resgatarRazaoSocialEmpresa(LinkedHashMap<String,dynamic> empresa){
  String razaoSocialFormatado = empresa['razao_social'];
  razaoSocialFormatado = const Utf8Decoder().convert(razaoSocialFormatado.codeUnits);
  return razaoSocialFormatado;
}


String capsFirstLetter(String word){
  return '${word[0].toUpperCase()}${word.substring(1)}';
}
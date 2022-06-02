import 'dart:convert';
import 'dart:collection';

class Utilidades {
  static String formatarEndereco(LinkedHashMap<String,dynamic> endereco){
    String enderecoFormatado = '${endereco['logradouro']}, ${endereco['numero']}, ${endereco['complemento']}, ${endereco['bairro']}, ${endereco['cep']}, ${endereco['cidade']}, ${endereco['uf']}';
    enderecoFormatado = Utf8Decoder().convert(enderecoFormatado.codeUnits);
    return enderecoFormatado;
  }
}
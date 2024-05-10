part of 'package:hello_flutter/pages/page_data/bloc/data_block.dart';

abstract class MeuEstado {
  final int counter;
  const MeuEstado(this.counter);
}

//O bloc obriga ter um estado inicial, dai vc cria uma classe 
//para representar o estado inicial
class MeuEstadoInicial extends MeuEstado {
  MeuEstadoInicial() : super(0);
}

//No bloc o estado é imutável. Alterar estado significa prover nova instância
//Criamos a classe abaixo pois permite novos valores no atributo counter
//É esta classe que será instanciada e provida nos eventos 
class MeuEstadoAlterado extends MeuEstado {
  MeuEstadoAlterado(int counter) : super(counter);
}



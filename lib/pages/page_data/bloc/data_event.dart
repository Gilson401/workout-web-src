// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'package:hello_flutter/pages/page_data/bloc/data_block.dart';

//Aqui vc declara os tipos de eventos possíveis para teu state
//Declara abstract para ficar livre para usar qq uma de suas filhas
abstract class EventoDeEstado {}

//declare quantos eventos quiser conforme necessidade. 
//Parece funcionar como um enum
class IncrementaEstado extends EventoDeEstado {}
class DecrementaEstado extends EventoDeEstado {}

class EventoComParam extends EventoDeEstado {
  final int value;
  
  EventoComParam({
    required this.value,
  });
}


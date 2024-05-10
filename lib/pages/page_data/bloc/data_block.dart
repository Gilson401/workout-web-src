import 'package:bloc/bloc.dart';

part 'data_event.dart';
part 'data_state.dart';

//EventoDeEstado, MeuEstado devem ser abstract pois te liberam para usar
//diferentes filhos de cada um
class DataBloc extends Bloc<EventoDeEstado, MeuEstado> {
  DataBloc() : super(MeuEstadoInicial()) {
    //Aqui ocorre a subscrição nos eventos
    //Quando ocorrer evento tal chamará função dentro dos parenteses
    on<IncrementaEstado>(_increment);
    on<DecrementaEstado>(_decrement);
    on<EventoDeEstado>(_metodoComParamEvent);
  }

  //A função devet ter esta assinatura, respeitando os generics recebidos
  void _increment(IncrementaEstado event, Emitter<MeuEstado> emit) {
    //Aqui entregamos uma nova instancia de MeuEstado
    //que é MeuEstadoAlterado, filha de MeuEstado
    //Esta nova instância será adicionada ao Stream do bloc
    emit(MeuEstadoAlterado(state.counter + 1));
  }

  void _decrement(DecrementaEstado event, Emitter<MeuEstado> emit) {
    //state é fornecido pelo Bloc e é o estado anterior para o caso
    //de vc precisar do valor anterior para gerar o novo
    emit(MeuEstadoAlterado(state.counter - 1));
  }

  void _metodoComParamEvent(EventoDeEstado event, Emitter<MeuEstado> emit) {
    final evt = event as EventoComParam; 
    emit(MeuEstadoAlterado(state.counter + evt.value));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
part 'counter_cubit_state.dart';

//recebe apenas o stado no generic
class CounterCubit extends Cubit<CounterStateCubit> {

  //No cubit o construtor não recebe nem mapeia eventos
  CounterCubit() : super(CounterStateCubitInicial());

  //Os métodos não exigem evento nem o emitter
  void increment() {
    emit(CounterStateCubitAlterado(state.counter + 1));
  }

  //Os métodos não exigem evento nem o emitter
  void decrement() {
    emit(CounterStateCubitAlterado(state.counter - 1));
  }
}



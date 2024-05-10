part of 'package:hello_flutter/pages/cubit_page/cubit/counter_cubit.dart';

//A classe de estado no Cubit é exatamente igual ao bloc comum
abstract class CounterStateCubit {
  final int counter;
  const CounterStateCubit(this.counter);
}

class CounterStateCubitInicial extends CounterStateCubit {
  CounterStateCubitInicial() : super(0);
}

class CounterStateCubitAlterado extends CounterStateCubit {
  CounterStateCubitAlterado(int counter) : super(counter);
}



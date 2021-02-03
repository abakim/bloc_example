import 'package:bloc_example/bloc/bloc.dart'; 

// Como no es necesario pasarle datos (desde la capa de datos) al bloc, se crea un enum
enum CounterEvent {increment, decrement, reset}

class CounterBloc extends Bloc<CounterEvent,int>{
  // CounterBloc(int initialState) : super(initialState);

  @override
  int get initialState => 0;

  // funciona como Asynchronous Generator Function (mete los stream en el bloc)
  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    if (event == CounterEvent.increment){
      yield currentState + 1; // yield agrega un nuevo estado
    } else if(event == CounterEvent.decrement){
      yield currentState -1;
    } else if(event == CounterEvent.reset){
      yield 0;
    }
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

}


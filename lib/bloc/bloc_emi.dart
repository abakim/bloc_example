import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'transition.dart';
/* 
<< Clase abstracta para tener un bloc en común a todos los blocs >>

  Recordar que si se extiende de una clase principal se extiende de las subclases:
  
  Class A{}
   
  Class B extends A{}

  Class C extends A{}

  Class MyBloc2 extends Bloc<A,int>{}  //--> se puede usar como "eventos" o parámetro de entrada a las clases A,B y C
  
  Ese es el objetivo de utilizar el bloc abstracto
*/

// Para colocar parámetros genéricos en Dart, se usan los símbolos de menor y mayor (<>), también llamados angle brackets
// Entonces es posible llamar los datos del tipo que querramos, en este caso eventos y estados.
abstract class Bloc<Event, State> {

    ///////////////////////////////////////////////////////
   /*******  LÓGICA DE ENTRADA Y SALIDA DEL BLOC  *******/
  ///////////////////////////////////////////////////////
  
  /* PublicSubject y BehaviourSubject son StreamControllers que tienen un broadcast stream */
  
  // Permite escuchar y guardar eventos como entradas
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();

  // Guarda el último elemento que se agrega al stream y lo emite como primer elemento a cualquier oyente. Dicho elemento se utiliza como estado y se puede acceder de forma síncrona al último elemento del stream.
  BehaviorSubject<State> _stateSubject;

  // Estado inicial del bloc
  State get initialState;

  // Valor del estado actual
  State get currentState => _stateSubject.value;

  // Estado de salida (Stream)
  Stream<State> get state => _stateSubject.stream;

  // Constructor que le pasa el estado inicial al bloc
  Bloc() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
    _bindStateSubject();
  }
  
  // Se libera la memoria
  @mustCallSuper // si cuando se llama a la clase bloc se utiliza un dispose, este dispose puede ser reemplazado y no se liberará la memoria, entonces ponemos esta notación que nos alerta que tenemos que llamar a super.dispose
  void dispose(){
    _eventSubject.close();
    _stateSubject.close();
  }

  // A ser sobreescritos 
  void onTransition(Transition<Event, State> transition) => null; // para registrar cambios en el bloc (Ej: login)

  void onError( Object error, StackTrace stacktrace) => null;

  void onEvent(Event event) => null;

  // función que despacha (añade) las entradas al bloc
  void dispatch(Event event){
    try {
      _eventSubject.sink.add(event);
    } on Exception catch (error) {
      _handleError(error);
    }
  }
  
    ///////////////////////////////////////////////////////
   /*****************  LÓGICA DEL BLOC  *****************/
  ///////////////////////////////////////////////////////
  
  Stream<State> transform(
    Stream<Event> events,
    Stream<State> next(Event event),
  ){
    return events.asyncExpand(next);
  }

  // Mapea evento a un stream de estados. Cada estado es procesado uno por uno
  Stream<State> mapEventToState(Event event);

  // El método asyncExpand genera todos los streams de cada evento de entrada del bloc generados por mapEventToState
  // A cada stream de salida se le asigna un oyente que se encargará de agregar todos los estados al stateSubject a través de su sink para que el stream tenga tods los estados generados por cada evento. Es decir, hay un "oyente interno" que se encarga de pasar los stream al oyente final (ya que el oyente del bloc los tiene q recibir de la misma forma en que salieron) y este a su vez "espera" a que asyncExpand termine de procesar el evento siguiente.
  // https://youtu.be/c1liGPqrMlA?t=756

  void _bindStateSubject(){
    Event currentEvent;
    // Se mapea un evento de entrada a un estado
    transform(  // Se hace con transform para luego poder reescribirlo y posteriormente poder personalizar (cambiar) el comportamiento de cómo los eventos ingresan al bloc 
      _eventSubject,
      (Event event){
        currentEvent = event;
        return mapEventToState(currentEvent).handleError(_handleError);
        },
    ).forEach( // Se agregan oyentes
    (State nextState){
      // Si el próximo estado es igual al actual o si el stateSubject está cerrado no hay q procesar el estado
      if(currentState == nextState || _stateSubject.isClosed) return;
      final transition = Transition(
        currentState: currentState,
        event: currentEvent,
        nextState: nextState,
      );
      // Cada vez que ocurra un cambio se notifica en onTransition
      onTransition(transition);
      // Se agrega el siguiente estado a stateSubject
      _stateSubject.sink.add(nextState); 
      },
    );
  }


  void _handleError(Object error, [StackTrace stacktrace]) {
    // BlocSupervisor.delegate.onError(this, error, stacktrace);
    onError(error, stacktrace);
  }
}

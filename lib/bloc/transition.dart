import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Transition<Event,State> extends Equatable{
 final State currentState;
 final Event event;
 final State nextState;
 
 Transition ({
   @required this.currentState,
   @required this.event,
   @required this.nextState,
 }) : assert(currentState != null), // Se asegura que las variables no sean null
      assert(event !=null),
      assert(nextState != null);
  
  // Muestra el valor de las variables o propiedades
  @override
  String toString() {
  return 'Transition { currentState: $currentState, event: $event, nestState: $nextState}';
  }

  @override
  // TODO: implement props
  List<Object> get props => [currentState, event, nextState];

}
/* 
<< Clase abstracta para tener un bloc en común a todos los blocs >>
*/

// Para colocar parámetros genéricos en Dart, se usan los símbolos de menor y mayor (<>), también llamados angle brackets
// Entonces es posible llamar los datos del tipo que querramos, en este caso eventos y estados.
abstract class Bloc<Event, State> {}

/*
  Recordar que si se extiende de una clase principal se extiende de las subclases:
  
  Class A{}
   
  Class B extends A{}

  Class C extends A{}

  Class MyBloc2 extends Bloc<A,int>{}  //--> se puede usar como "eventos" o parámetro de entrada a las clases A,B y C
*/
class MyBloc extends Bloc <String, int> {}
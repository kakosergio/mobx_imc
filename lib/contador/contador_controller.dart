import 'package:mobx/mobx.dart';

class ContadorController {
  // Cria um observável do tipo int
  final _counter = Observable<int>(0);
  // Cria um observável de uma classe FullName
  final _fullName =
      Observable<FullName>(FullName(first: 'first', last: 'last'));
  // Cria uma ação que será inicializada no construtor
  late Action increment;
  // Cria um Computed, que é uma ação derivada de outra ação principal
  late Computed _greetings;

  ContadorController() {
    // Inicia a ação no construtor da classe
    increment = Action(_incrementCounter);
    // Inicia o Computed no construtor da classe
    // Ele nesse caso deriva de dois observáveis, então teria que ser um computed
    _greetings =
        Computed(() => 'Olá ${_fullName.value.first} ${_counter.value}');
  }

  // Método get para recuperar o valor do observável
  int get counter => _counter.value;
  FullName get fullName => _fullName.value;
  String get greetings => _greetings.value;

  // Função que realiza uma ação
  void _incrementCounter() {
    _counter.value++;
    //! Não pode fazer isso que não vai funcionar a atualização da action
    //! Pois dessa forma não altera o hashcode e o mobX não entende como atua-
    //! lização
    // _fullName.value.first = 'Sérgio';
    // _fullName.value.last = 'Teixeira';

    //? Isso aqui abaixo funciona, pois altera o hashcode (pois você cria um no-
    //? vo objeto)
    // _fullName.value = FullName(first: 'Sérgio', last: 'Teixeira');

    //? Ou então posso ainda usar os prototypes (que eu acho mais charmoso)
    //? Claro que se você for alterar todos os parâmetros da classe, às vezes
    //? fica menor e mais interessante criar um novo objeto, como acima.
    _fullName.value =
        _fullName.value.copyWith(first: 'Sérgio', last: 'Teixeira');
  }
}

class FullName {
  String first;
  String last;

  FullName({
    required this.first,
    required this.last,
  });

  FullName copyWith({
    String? first,
    String? last,
  }) {
    return FullName(
      first: first ?? this.first,
      last: last ?? this.last,
    );
  }
}

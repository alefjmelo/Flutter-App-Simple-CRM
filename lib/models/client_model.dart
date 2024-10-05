import 'package:flutter/foundation.dart';

@immutable
class Client {
  final int code;
  final String nome;
  final String numero;
  final String endereco;

  const Client({
    required this.code,
    required this.nome,
    required this.numero,
    required this.endereco,
  });

  // Create a copy of this Client but with the given fields replaced with new values
  Client copyWith({
    int? code,
    String? nome,
    String? numero,
    String? endereco,
  }) {
    return Client(
      code: code ?? this.code,
      nome: nome ?? this.nome,
      numero: numero ?? this.numero,
      endereco: endereco ?? this.endereco,
    );
  }

  // Convert a Client object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'nome': nome,
      'numero': numero,
      'endereco': endereco,
    };
  }

  // Extract a Client object from a Map object
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      code: map['code'] as int,
      nome: map['nome'] as String,
      numero: map['numero'] as String,
      endereco: map['endereco'] as String,
    );
  }

  // Implement toString for easy debugging
  @override
  String toString() {
    return 'Client(code: $code, nome: $nome, numero: $numero, endereco: $endereco)';
  }

  // Implement equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Client &&
        other.code == code &&
        other.nome == nome &&
        other.numero == numero &&
        other.endereco == endereco;
  }

  // Implement hashCode
  @override
  int get hashCode {
    return code.hashCode ^ nome.hashCode ^ numero.hashCode ^ endereco.hashCode;
  }
}

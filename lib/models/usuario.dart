// lib/models/usuario.dart
// Espelha o payload de usuario devolvido por POST /auth/login (ver
// AuthService.login no backend) para uma conta Tecnico.

class Funcionario {
  final String id;
  final String cargo;
  final String? telefone;
  final String status;

  const Funcionario({
    required this.id,
    required this.cargo,
    this.telefone,
    required this.status,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) => Funcionario(
        id: json['id'] as String,
        cargo: json['cargo'] as String,
        telefone: json['telefone'] as String?,
        status: json['status'] as String,
      );
}

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String papel;
  final String? empresaId;
  final Funcionario? funcionario;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.papel,
    this.empresaId,
    this.funcionario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] as String,
        nome: json['nome'] as String,
        email: json['email'] as String,
        papel: json['papel'] as String,
        empresaId: json['empresaId'] as String?,
        funcionario: json['funcionario'] != null
            ? Funcionario.fromJson(json['funcionario'] as Map<String, dynamic>)
            : null,
      );
}

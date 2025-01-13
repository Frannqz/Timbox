class CollaboratorModel {
  final String nombre;
  final String correo;
  final String rfc;
  final String domicilioFiscal;
  final String curp;
  final String nss;
  final String fechaInicioLaboral;
  final String tipoContrato;
  final String departamento;
  final String puesto;
  final double salarioDiario;
  final double salario;
  final int claveEntidad;
  final String estado;
  final int userId;

  CollaboratorModel({
    required this.nombre,
    required this.correo,
    required this.rfc,
    required this.domicilioFiscal,
    required this.curp,
    required this.nss,
    required this.fechaInicioLaboral,
    required this.tipoContrato,
    required this.departamento,
    required this.puesto,
    required this.salarioDiario,
    required this.salario,
    required this.claveEntidad,
    required this.estado,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'rfc': rfc,
      'domicilio_fiscal': domicilioFiscal,
      'curp': curp,
      'nss': nss,
      'fecha_inicio_laboral': fechaInicioLaboral,
      'tipo_contrato': tipoContrato,
      'departamento': departamento,
      'puesto': puesto,
      'salario_diario': salarioDiario,
      'salario': salario,
      'clave_entidad': claveEntidad,
      'estado': estado,
      'user_id': userId,
    };
  }
}

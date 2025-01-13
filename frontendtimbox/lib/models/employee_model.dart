class EmployeeModel {
  final int id;
  final String nombre;
  final String correo;
  final String rfc;
  final String domicilio_fiscal;
  final String curp;
  final String nss;
  final String fecha_inicio_laboral;
  final String tipo_contrato;
  final String departamento;
  final String puesto;
  final String salario_diario;
  final String salario;
  final int clave_entidad;
  final String estado;
  final int user_id;

  EmployeeModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rfc,
    required this.domicilio_fiscal,
    required this.curp,
    required this.nss,
    required this.fecha_inicio_laboral,
    required this.tipo_contrato,
    required this.departamento,
    required this.puesto,
    required this.salario_diario,
    required this.salario,
    required this.clave_entidad,
    required this.estado,
    required this.user_id,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
        id: json['id'],
        nombre: json['nombre'],
        correo: json['correo'],
        domicilio_fiscal: json['domicilio_fiscal'],
        rfc: json['rfc'],
        nss: json['nss'],
        curp: json['curp'],
        fecha_inicio_laboral: json['fecha_inicio_laboral'],
        departamento: json['departamento'],
        tipo_contrato: json['tipo_contrato'],
        puesto: json['puesto'],
        salario_diario: json['salario_diario'],
        salario: json['salario'],
        clave_entidad: json['clave_entidad'],
        estado: json['estado'],
        user_id: json['user_id']);
  }
}

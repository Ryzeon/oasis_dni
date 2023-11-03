class DNI {
  final String id;
  final String nombre_completo;
  final String nombres;
  final String apellido_paterno;
  final String apellido_materno;
  final String codigo_verificacion;
  final String fecha_nacimiento;
  final String sexo;
  final String estado_civil;
  final String departamento;
  final String provincia;
  final String distrito;
  final String direccion;
  final String direccion_completa;
  final String ubigeo_reniec;
  final String ubigeo_sunat;
  final Object ubigeo;

  DNI(
      this.id,
      this.nombre_completo,
      this.nombres,
      this.apellido_paterno,
      this.apellido_materno,
      this.codigo_verificacion,
      this.fecha_nacimiento,
      this.sexo,
      this.estado_civil,
      this.departamento,
      this.provincia,
      this.distrito,
      this.direccion,
      this.direccion_completa,
      this.ubigeo_reniec,
      this.ubigeo_sunat,
      this.ubigeo);

  int getAge() {
    final date = fecha_nacimiento.split("-");
    final birth = DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
    return DateTime.now().difference(birth).inDays ~/ 365;
  }

  String getNiceDirection() {
    if (direccion == null) return "N/A";
    if (direccion.isEmpty) return "N/A";
    if (direccion == "null") return "N/A";
    return direccion;
  }

  String getDNI() {
    return id;
  }

  factory DNI.fromJson(Map<String, dynamic> json) {
    return DNI(
      json["id"],
      json["nombre_completo"],
      json["nombres"],
      json["apellido_paterno"],
      json["apellido_materno"],
      json["codigo_verificacion"],
      json["fecha_nacimiento"],
      json["sexo"],
      json["estado_civil"],
      json["departamento"],
      json["provincia"],
      json["distrito"],
      json["direccion"],
      json["direccion_completa"],
      json["ubigeo_reniec"],
      json["ubigeo_sunat"],
      json["ubigeo"],
    );
  }
}
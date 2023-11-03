import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oasis_dni/lang.dart';
import 'package:oasis_dni/model/dni.dart';
import 'package:oasis_dni/request/request.dart';
import 'package:oasis_dni/request/request_container.dart';
import 'package:oasis_dni/utils/utils.dart';

class DNIScreen extends StatefulWidget {
  const DNIScreen({super.key});

  @override
  State<DNIScreen> createState() => _DNIScreenState();
}

class _DNIScreenState extends State<DNIScreen> with AutomaticKeepAliveClientMixin<DNIScreen>{
    @override
  bool get wantKeepAlive => true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  bool _information = false;

  bool get information => _information;

  String showInformation =
      "Sin información, por favor ingrese su número de documento";

  void renderDNI(DNI dni) {
    showInformation = """
    DNI: ${dni.id}
    Nombre: ${dni.nombres}
    Apellido: ${dni.apellido_paterno} ${dni.apellido_materno}
    Fecha de nacimiento: ${dni.fecha_nacimiento}
    Dirección: ${dni.direccion}
    Edad: ${dni.getAge()}
    Sexo: ${dni.sexo}
    Estado civil: ${dni.estado_civil}
""";
    setState(() {
      _information = true;
    });
  }

  void handleSubmitted() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      IRequest request = RequestContainer().getRequest("dni");
      try {
        DNI dni = await request.request(_textEditingController.text);
        renderDNI(dni);
      } catch (e) {
        Utils.showError(context, "Error al obtener el DNI");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          color: Lang.primaryColor.getColor(),
        ),
        child: SafeArea(
          child: Center(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // expand box to fit the screen
                Container(
                  height: 170,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 15, top: 15),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: Colors.black,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Ingresa el DNI",
                              hintText: 'XXXXXXXX',
                              labelStyle: TextStyle(color: Colors.black),
                            ),
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (value) async {
                              handleSubmitted();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor ingrese su numero de documento';
                              }
                              if (!Utils.validateDNI(value)) {
                                return 'Por favor ingrese un numero de documento valido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          handleSubmitted();
                        },
                        // disable buttion

                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: const Color.fromARGB(255, 129, 123, 210),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15)
                            // padding: EdgeInsets.only(
                            //     left: 120, right: 120, top: 20, bottom: 20),
                            ),
                        child: const Text(
                          "Buscar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: information,
                  replacement: SizedBox(
                    height: (MediaQuery.of(context).size.height / 2),
                  ),
                  child: Container(
                    height: (MediaQuery.of(context).size.height / 2.2),
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: SelectableText(
                          showInformation,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

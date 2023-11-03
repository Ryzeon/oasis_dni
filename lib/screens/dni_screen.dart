import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
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

class _DNIScreenState extends State<DNIScreen>
    with AutomaticKeepAliveClientMixin<DNIScreen> {
  @override
  bool get wantKeepAlive => true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  bool _information = false;

  bool _valid = true;

  bool get information => _information;

  bool _isLoaderVisible = false;

  String? _imageBytes;

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
      _imageBytes = "data:image/jpeg;base64,${dni.foto}";
    });
  }

  void handleSubmitted() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _valid = true;
      // reload view
      setState(() {});

      context.loaderOverlay.show();
      setState(() {
        _isLoaderVisible = context.loaderOverlay.visible;
      });

      IRequest request = RequestContainer().getRequest("dni");
      try {
        DNI dni = await request.request(_textEditingController.text);
        if (_isLoaderVisible) {
          context.loaderOverlay.hide();
        }
        setState(() {
          _isLoaderVisible = context.loaderOverlay.visible;
        });
        renderDNI(dni);
      } catch (e) {
        if (_isLoaderVisible) {
          context.loaderOverlay.hide();
        }
        setState(() {
          _isLoaderVisible = context.loaderOverlay.visible;
        });
        Utils.showError(context, "Error al obtener el DNI");
      }
    } else {
      _valid = false;
      setState(() {});
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
          child: Container(
              padding: const EdgeInsets.only(top: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 130 + (_valid ? 10 : 30),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
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
                                backgroundColor:
                                    const Color.fromARGB(255, 129, 123, 210),
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
                    const SizedBox(height: 10),
                    Visibility(
                      visible: information,
                      replacement: SizedBox(
                        height: (MediaQuery.of(context).size.height / 2),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Container(
                              height:
                                  (MediaQuery.of(context).size.height / 2.3),
                              width: MediaQuery.of(context).size.width / 1.1,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  // margin: const EdgeInsets.all(10),
                                  // add pading to top 10,
                                  padding: const EdgeInsets.only(top: 25),
                                  alignment: Alignment.center,
                                  child: SelectableText(
                                    // alidng text center
                                    showInformation,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 400,
                              width: 400,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: information
                                  ? _imageBytes != null
                                      ? Image.memory(
                                          Uri.parse(_imageBytes!.replaceAll(
                                                      RegExp(r'\s+'), ''))
                                                  .data
                                                  ?.contentAsBytes() ??
                                              Uint8List(0),
                                        )
                                      : const CircularProgressIndicator()
                                  : const Icon(
                                      Icons.person,
                                      size: 200,
                                    ),
                            ),
                            const SizedBox(height: 20),
                          ],
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

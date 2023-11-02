import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:oasis_dni/lang.dart';
import 'package:oasis_dni/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController_2 =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  String _reason = "";

  @override
  void dispose() {
    _textEditingController.clear();
    _textEditingController_2.clear();
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    Utils.isInternetAvailable().then((value) => {
          if (!value)
            {
              _reason = "No hay conexion a internet",
              MotionToast.error(
                      title: Text("Error!"),
                      description: Text(_reason),
                      position: MotionToastPosition.bottom)
                  .show(context)
            }
          else
            {
              Utils.isBackendOnline().then((value) => {
                    if (!value)
                      {
                        _reason = "El servidor no esta disponible",
                        MotionToast.error(
                                title: Text("Error!"),
                                description: Text(_reason),
                                position: MotionToastPosition.bottom)
                            .show(context)
                      }
                    else
                      {
                        LoginUtils.retrieveLogin().then((value) => {
                              if (value.isValid())
                                {
                                  value.isValidLogin().then((value) => {
                                        if (value)
                                          {
                                            MotionToast.success(
                                                    title: const Text(
                                                        "Bienvenido!"),
                                                    description: const Text(
                                                        'Iniciando sesion...'),
                                                    position:
                                                        MotionToastPosition
                                                            .bottom)
                                                .show(context),
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const TabsScreen()))
                                          }
                                      })
                                }
                            })
                      }
                  })
            }
        });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // <-- SEE HERE
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Lang.primaryColor.getColor(),
            image: DecorationImage(
              image: NetworkImage(Lang.oasisImg.getString()),
              opacity: 0.6,
            ),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2.3,
                    ),
                    const LoginScreenTitleWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 20),
                            child: Form(
                              key: _formKey2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                autofillHints: const [AutofillHints.username],
                                textInputAction: TextInputAction.go,
                                controller: _textEditingController,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  prefixIcon: Icon(
                                    Icons.contact_mail,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Numero de documento",
                                  hintText: 'XXXXXXXX',
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                obscuringCharacter: '*',
                                autofillHints: const [AutofillHints.password],
                                obscureText: true,
                                controller: _textEditingController_2,
                                decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Contraseña",
                                  hintText: '*********',
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor ingrese su contraseña';
                                  }
                                  if (value.isEmpty && value.length < 5) {
                                    return 'Por favor ingrese su contraseña';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // validate form
                              if (_formKey2.currentState!.validate() &&
                                  _formKey.currentState!.validate()) {
                                if (_reason.isNotEmpty) {
                                  MotionToast.error(
                                          title: const Text("Error!"),
                                          description: Text(_reason),
                                          position: MotionToastPosition.bottom)
                                      .show(context);
                                } else {
                                  String _dni = _textEditingController.text;
                                  String _password =
                                      _textEditingController_2.text;
                                  // login

                                  MotionToast.success(
                                          title: const Text("!"),
                                          description:
                                              const Text('Iniciando sesion...'),
                                          position: MotionToastPosition.bottom)
                                      .show(context);

                                  if (await LoginUtils.login(_dni, _password)) {
                                    TextInput.finishAutofillContext();
                                    LoginUtils.saveSession(_dni, _password);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TabsScreen()));
                                  } else {
                                    MotionToast.error(
                                            title: const Text('Error!'),
                                            description: const Text(
                                                'Verifique sus credenciales'),
                                            position:
                                                MotionToastPosition.bottom)
                                        .show(context);
                                  }
                                }
                              }
                            },
                            // ignore: sort_child_properties_last
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                backgroundColor: Colors.amber.shade100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 131, vertical: 20)
                                // padding: EdgeInsets.only(
                                //     left: 120, right: 120, top: 20, bottom: 20),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreenTitleWidget extends StatelessWidget {
  const LoginScreenTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Iniciar Sesion",
      style: GoogleFonts.lato(
        textStyle: const TextStyle(
          color: Color(0xFF212121),
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
      ),
    );
  }
}

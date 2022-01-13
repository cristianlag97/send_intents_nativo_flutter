import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'helper/SendDataConnector.dart';

class HomeScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  static const platform = const MethodChannel('going.native.for.userdata');

  var paymentMethod = [
    "---",
    "Tarjeta Crédito",
    "Tarjeta Débito",
  ];
  var defaultMethod = "---";

  var cardDebitoOptions = ["---", "Corriente", "Ahorros"];
  var defaultCard = "---";
  var defaultTransfer = "---";
  var keys = '';
  var instalments = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36
  ];
  var defaultInstalment = "";
  String merchantCode = "prueba";
  String valor = "";
  bool bandera = false;

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';

  TextEditingController _email      = TextEditingController();
  TextEditingController password    = TextEditingController();
  TextEditingController valorController  = TextEditingController();

  Future<void> SendDatatoKotlin(merchantCode, tipoTarjeta, valorDeTarjeta, valor, packageName,  email, password) async {
    var connector = SendDataConnector();
    connector.sendAllData(merchantCode, tipoTarjeta, valorDeTarjeta, valor, packageName, email, password);
  }

  Future<void> showInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  void initState() {
    super.initState();



    showInfo();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 //_body(),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.money),
                      hintText: 'por favor, ingrese un valor',
                      labelText: 'Valor a pagar *',
                    ),
                    controller: valorController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 10.0, left: 20.0, right: 20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Expanded(
                                    child: Text(
                                      "Seleccione tipo de cobro",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.left,
                                    )),
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.only(left: 15.0),
                              child: DropdownButton(
                                key: const Key('select_link'),
                                icon:
                                const Icon(Icons.keyboard_arrow_down_rounded),
                                isExpanded: true,
                                items: paymentMethod.map((String methodSelected) {
                                  return DropdownMenuItem(
                                      value: methodSelected,
                                      child: Text(
                                        methodSelected,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:16.0,
                                          color: Colors.black,
                                        ),
                                      ));
                                }).toList(),
                                onChanged: (_value) {
                                  setState(() {
                                    defaultMethod = _value.toString();

                                  });
                                },
                                hint: Text(
                                  defaultMethod,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          _checkoutOptions(defaultMethod),
                          const SizedBox(height: 1),
                        ])),
                ElevatedButton(
                    onPressed: (defaultCard != '---' || defaultInstalment != '') ? () => share(context, valorController.text.trim()) : null,
                    child: const Text('Cobrar')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startActivityForResult() async {

    const platform = const MethodChannel('intent');
    try {
      final int result = await platform.invokeMethod('startActivityForResult');
      print(result);
    } on PlatformException catch (e) {
      print('${e.message}');
    }
  }

  Container _checkoutOptions(String defaultMethod) {
    if (defaultMethod == "Tarjeta Crédito") {
      return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                _creditOption(defaultCard),
                const SizedBox(
                  height: 10,
                ),
              ]));
    }
    if (defaultMethod == "Efectivo") {}

    if (defaultMethod == "Tarjeta Débito") {
      return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.only(left: 15.0),
                    child: DropdownButton(
                      key: const Key('select_tarjeta'),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      isExpanded: true,
                      items: cardDebitoOptions.map((String cardSelected) {
                        return DropdownMenuItem(
                            value: cardSelected,
                            child: Text(
                              cardSelected,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ));
                      }).toList(),
                      onChanged: (_value) {
                        setState(() {
                          defaultCard = _value.toString();
                        });
                      },
                      hint: Text(
                        defaultCard,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
              ]));
    }
    return Container();
  }

  Container _creditOption(String defaultCard) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Número de cuotas",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              const Expanded(
                  child: SizedBox(
                    width: 1,
                  )),
              Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.only(left: 15.0),
                  child: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    isExpanded: true,
                    items: instalments.map((int instalmentsSelected) {
                      return DropdownMenuItem(
                          value: instalmentsSelected,
                          child: Text(
                            instalmentsSelected.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ));
                    }).toList(),
                    onChanged: (_value) {
                      setState(() {
                        defaultInstalment = _value.toString();
                      });
                    },
                    hint: Text(
                      defaultInstalment,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ))
            ]));
  }

  share(BuildContext context, controller) {
    if(controller.toString().isEmpty) {
      _showSnackbar(context, '¡Debes ingresar un valor... ;)');
    } else {
      if(defaultMethod != '---') {
        if(defaultMethod == "Tarjeta Débito") {
          setState(() {
            valor = defaultCard;
          });
          bandera = true;
        } else if(defaultMethod == "Tarjeta Crédito"){
          setState(() {
            valor = defaultInstalment;
          });
          bandera = true;
        } else {
          bandera = false;
        }
        List<String> datos = [merchantCode,controller,defaultMethod, valor, packageName];
        //String shareData = jsonEncode(datos);
        print(merchantCode);
        print(defaultMethod);
        print(valor);
        print(controller);
        print(packageName);

        _showModal(context, controller);

        //SendDatatoKotlin(merchantCode,defaultMethod,valor, controller, packageName);

        //RenderBox? box = context.findRenderObject() as RenderBox;
        //Share.share(shareData, subject: 'Descripción', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      }
    }

  }

  void _showSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      duration: Duration(seconds: 1),
      content: Text(message),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future<void> _showModal(BuildContext context, controller) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 150),
            title: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.close, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        iconSize: 25.0
                      )
                    ]
                  ),
                  Text('Por favor Completa estos datos para seguir con el proceso de pago',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black),
                      textAlign: TextAlign.center
                  ),
                ],
              ),
            ),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Escribe el correo"),
                  ),
                  SizedBox(height: 17.0),
                  TextField(
                    key: Key('email-adress'),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (valor){

                    },
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      // Added this
                      contentPadding: EdgeInsets.all(15), // Added this
                    ),
                    cursorColor: Colors.black,
                    controller: _email,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text("Escribe la contraseña"),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (valor){

                    },
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      // Added this
                      contentPadding: EdgeInsets.all(15), // Added this
                    ),
                    cursorColor: Colors.black,
                    textCapitalization: TextCapitalization.words,
                    controller: password,
                  )
                ],
              ),
            ),
            actions: [
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    Expanded( child: SizedBox(width: 1)),
                    ElevatedButton(
                      onPressed: () {
                        if(_email.text.length != 0) {

                          SendDatatoKotlin(merchantCode,defaultMethod , valor, controller, packageName, _email.text.trim(), password.text.trim());
                        } else {
                          _showSnackbar(context ,"Debes escribir el correo y/o la contraseña");
                        }

                      },
                      child: Text("Enviar Pago")
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
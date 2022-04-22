// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:payzy/payzy/models/transaction_response.dart';
import 'package:payzy/payzy/payzy.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payzy Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Payzy Global Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  String get phoneNumber => _phoneNumberController.text;

  PayzyProvider _provider = PayzyProvider.tmoney;

  PayzyProvider get provider => _provider;

  set provider(PayzyProvider value) {
    setState(() {
      _provider = value;
    });
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TransactionResponse? _responseMethod1;

  bool _initializing1 = false;

  bool get initializing1 => _initializing1;

  set initializing1(bool value) {
    setState(() {
      _initializing1 = value;
    });
  }

  set responseMethod1(TransactionResponse? value) {
    setState(() {
      _responseMethod1 = value;
    });
  }

  TransactionResponse? _transaction1;

  bool _verifying1 = false;

  bool get verifying1 => _verifying1;

  set verifying1(bool value) {
    setState(() {
      _verifying1 = value;
    });
  }

  set transaction1(TransactionResponse value) {
    setState(() {
      _transaction1 = value;
    });
  }

  @override
  void initState() {
    Payzy.init(apiKey: "KWE6Y1VMN14F04K0X6PH9QJMWR13");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(height: 15),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        PaymentProviderSelector(
                          color: Colors.white,
                          selectedColor: const Color(0xFFE20206),
                          icon: const Image(
                            image: AssetImage("assets/tmoney.png"),
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: (value) {
                            provider = value;
                          },
                          provider: PayzyProvider.tmoney,
                          providerSelected: provider,
                        ),
                        const SizedBox(width: 4),
                        PaymentProviderSelector(
                          color: Colors.white,
                          selectedColor: const Color(0xFFF86A0E),
                          icon: const Image(
                            image: AssetImage("assets/moov_money.png"),
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: (value) {
                            provider = value;
                          },
                          provider: PayzyProvider.flooz,
                          providerSelected: provider,
                        ),
                      ],
                    ),
                  ),
                  elevation: 5,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _key,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.phone),
                    ),
                    validator: (_) {
                      return (phoneNumber).isNotEmpty && phoneNumber.length >= 8
                          ? null
                          : "Please enter a phone number.";
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Divider(
                    height: 15,
                    thickness: 3,
                  ),
                ),
                initializing1
                    ? const CircularLoader()
                    : RaisedButton(
                        child: const Text('Pay Method'),
                        onPressed: () {
                          if (_key.currentState?.validate() ?? false) {
                            responseMethod1 = null;
                            _transaction1 = null;
                            initializing1 = true;
                            Payzy.createTransaction(
                              code: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              commandeId: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              pays: "TOGO",
                              tel: phoneNumber,
                              provider: provider,
                              amount: 1,
                              description:
                                  "Test Payment Method 1 : flutter_paygateglobal",
                            ).then((response) {
                              if (response.status ==
                                  TransactionResponseStatus.success) {
                                responseMethod1 = response;

                                toast(
                                  context,
                                  "You will receive a dial dialog confirmation on your mobile phone.",
                                );
                              } else {
                                responseMethod1 = null;
                                toast(context, response.message);
                              }
                              initializing1 = false;
                            });
                          }
                        },
                      ),
                _TransactionResponseResume(_responseMethod1),
                const Divider(height: 15),
                (_responseMethod1 == null)
                    ? const SizedBox.shrink()
                    : (verifying1
                        ? const CircularLoader()
                        : ElevatedButton(
                            onPressed: () async {
                              _transaction1 = null;
                              verifying1 = true;
                              transaction1 = await Payzy.verifyTransaction(
                                sender: "",
                                transactionId: "",
                                amount: 1,
                                sms: "",
                                receiver: "",
                                type: "",
                              );
                              verifying1 = false;
                            },
                            child: const Text('Verify Transaction 1'),
                          )),
                _TransactionResume(_transaction1),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Divider(
                    height: 15,
                    thickness: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionResponseResume extends StatelessWidget {
  const _TransactionResponseResume(
    this.transaction, {
    Key? key,
  }) : super(key: key);

  final TransactionResponse? transaction;

  @override
  Widget build(BuildContext context) {
    return transaction == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Transaction Init Response",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Divider(height: 18),
                if ((transaction?.transactionId ?? "").isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Status: '),
                        Text(
                          transaction!.status.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction!.status ==
                                    TransactionResponseStatus.success
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                if ((transaction?.ussd ?? "").isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('USSD: '),
                        Text(
                          transaction!.ussd ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction!.status ==
                                    TransactionResponseStatus.success
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 15),
                Row(
                  children: [
                    const Text('Identifier: '),
                    Text(
                      transaction!.transactionId ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction!.status ==
                                TransactionResponseStatus.success
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class _TransactionResume extends StatelessWidget {
  const _TransactionResume(
    this.transaction, {
    Key? key,
  }) : super(key: key);

  final TransactionResponse? transaction;

  @override
  Widget build(BuildContext context) {
    return transaction == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Transaction Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Divider(height: 18),
                if (transaction?.status != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Status: '),
                        Text(
                          transaction!.status.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (transaction?.status ??
                                        TransactionResponseStatus
                                            .transactionError) ==
                                    TransactionResponseStatus.success
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                if ((transaction?.receiver ?? "").isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Receiver: '),
                        Text(
                          transaction!.receiver!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (transaction?.name != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Name: '),
                        Text(
                          transaction!.name!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction!.status ==
                                    TransactionResponseStatus.success
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 15),
              ],
            ),
          );
  }
}

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}

class PaymentProviderSelector extends StatelessWidget {
  const PaymentProviderSelector({
    required this.provider,
    required this.providerSelected,
    Key? key,
    required this.color,
    required this.selectedColor,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final PayzyProvider provider;

  final PayzyProvider providerSelected;

  final Color color;

  final Color selectedColor;

  final Function(PayzyProvider) onTap;

  bool get selected => provider == providerSelected;

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onTap(provider);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selected ? selectedColor : color,
            width: 2,
          ),
        ),
        height: size.height * 0.15,
        width: size.width * 0.3,
        child: Padding(
          padding: EdgeInsets.all(selected ? 15 : 2),
          child: icon,
        ),
      ),
    );
  }
}

void toast(
  BuildContext context,
  String message, {
  int duration = 3,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  void Function()? action,
  String actionText = "Ok",
  Widget? leading,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: behavior,
      content: leading == null
          ? Text(message)
          : Row(
              children: [
                leading,
                const SizedBox(width: 20),
                Expanded(child: Text(message)),
              ],
            ),
      duration: Duration(seconds: duration),
      action: action == null
          ? null
          : SnackBarAction(
              label: actionText,
              onPressed: action,
            ),
    ),
  );
}

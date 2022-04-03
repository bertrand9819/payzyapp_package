class TransactionResponse {
  TransactionResponseStatus get status => name == null
      ? TransactionResponseStatus.success
      : statusFromString(name!);

  bool get test => type == "test";

  final String? name;

  final String message;

  final String? transactionId;

  final String? receiver;

  final String? type;

  final String? ussd;

  final double? amount;

  TransactionResponse({
    this.name,
    required this.message,
    this.transactionId,
    this.receiver,
    this.type,
    this.ussd,
    this.amount,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      name: json['name'] as String,
      message: json['message'] as String,
      transactionId: json['trx_id'] as String?,
      receiver: json['receveur'] as String?,
      type: json['type'] as String?,
      ussd: json['ussd'] as String?,
      amount: json['montant'] as double?,
    );
  }
}

TransactionResponseStatus statusFromString(String name) {
  try {
    return TransactionResponseStatus.values.firstWhere(
        (element) => element.name.toLowerCase() == name.toLowerCase());
  } catch (e) {
    return TransactionResponseStatus.internalError;
  }
}

enum TransactionResponseStatus {
  success,

  ///Le Format est Authorization: Bearer [apikey].
  authorizationFormat,

  ///Aucune Authorization trouver.
  authorizationHeader,

  ///Apikey invalide .
  invalidToken,

  ///Le code sms n'a été envoyer
  sendSmsError,

  ///La transaction est introuvable
  transactionError,

  ///La transaction est introuvable
  paymentError,

  ///Aucun compte retrouver
  noAccountError,

  ///Les paramètres envoyés sont invalide.
  dataVerificationError,

  ///Montant invalide.
  amountError,

  ///ID unique de la commande exite déjà ou invalide.
  commandeIdError,

  ///L'opératuer n'est pas supporté
  numeroNotSupport,

  ///Le marchand n'est plus abonnées
  invalidAbonement,

  ///Le marchand ne supporte pas le moyen de paiement choisie
  numerosError,

  ///Nous ne reconnaisons pas cette entreprise
  entrepriseError,

  ///Service web Payzy indisponible
  internalError
}

enum PayzyProvider {
  FLOOZ,
  TMONEY,
}

String? mobile__money(PayzyProvider? provider) {
switch (provider) {
case PayzyProvider.FLOOZ:
return "FLOOZ";
case PayzyProvider.TMONEY:
return "TMONEY";

default:
return null;
}
}
class TransactionStatusRequest {
  TransactionStatusRequest({
    required this.sender,
    required this.transactionId,
    required this.amount,
    required this.sms,
    required this.receiver,
    required this.type,
  });

  final String sender;

  final String transactionId;

  final double amount;

  final String sms;

  final String receiver;

  final String type;

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'trx_id': transactionId,
        'montant': amount,
        'sms': sms,
        'receveur': receiver,
        'type': type,
      };
}

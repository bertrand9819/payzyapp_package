import '../payzy.dart';
import 'transaction_response.dart';

class NewTransactionRequest {
  NewTransactionRequest({
    required this.description,
    required this.pays,
    required this.provider,
    required this.commandeId,
    required this.code,
    required this.tel,
    required this.amount,
  });

  final String description;

  final String pays;

  final PayzyProvider? provider;

  final String commandeId;

  final String code;

  final String tel;

  final double amount;

  Map<String, dynamic> toJson() => {
        'description': description,
        'pays': pays,
        'mobile_money': mobile__money(provider),
        'commande_id': commandeId,
        'code': code,
        'tel': tel,
        'amount': amount,
      };

  Future<TransactionResponse> create() {
    return Payzy.createTransaction(
      description: description,
      pays: pays,
      provider: provider,
      commandeId: commandeId,
      code: code,
      tel: tel,
      amount: amount,
    );
  }
}

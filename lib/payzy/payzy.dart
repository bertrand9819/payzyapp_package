import 'dart:convert';

import 'config/payzey_config.dart';

import 'package:http/http.dart' as http;

import 'models/new_transaction_request.dart';
import 'models/transaction_response.dart';
import 'models/transaction_status_request.dart';

class Payzy {
  static void init({
    required String apiKey,
  }) {
    PayzyConfig.apiKey = apiKey;
  }

  static String get _token => PayzyConfig.token;

  ///Cette fonction vous permet de demander un paiement en passant les
  ///paramètres requis et d'en recevoir les informations pour lancer le
  ///code ussd . Pour se faire envoyer un simple appel HTTP de type Post vers
  /// le service web de PAYZY . En cas de méssage de succès vous recevrez les
  /// informations pour lancer le code ussd .Une fois le code ussd effectuer
  /// vous devez confirmer la transaction en appelant un autre api.
  static Future<TransactionResponse> createTransaction({
    required String description,
    required String pays,
    required PayzyProvider? provider,
    required String commandeId,
    required String code,
    required String tel,
    required double amount,
  }) async {
    try {
      http.Response post = await http.post(
        Uri.https(
          "payzyapp.com",
          "/api/v1/transactions/mobile/demande/paiement",
        ),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer ${PayzyConfig.apiKey}",
          "Accept": "application/json"
        },
        body: NewTransactionRequest(
          description: description,
          pays: pays,
          provider: provider,
          commandeId: commandeId,
          code: code,
          tel: tel,
          amount: amount,
        ).toJson(),
      );

      if (post.statusCode == 200) {
        return TransactionResponse.fromJson(jsonDecode(post.body));
      } else {
        return TransactionResponse(
          message: jsonDecode(post.body)["message"],
        );
      }
    } catch (e) {
      return TransactionResponse(message: e.toString());
    }
  }

  ///Cette fonction vous permet de confirmer un paiement en passant les
  /// paramètres requis et d'en recevoir une confirmation . Pour se faire
  ///  envoyer un simple appel HTTP de type Post vers le service web de PAYZY
  /// . En cas de méssage de succès vous direz au client que son paiement est
  /// confimer
  static Future<TransactionResponse> verifyTransaction({
    required String sender,
    required String transactionId,
    required double amount,
    required String sms,
    required String receiver,
    required String type,
  }) async {
    try {
      http.Response post = await http.post(
        Uri.https(
          "payzyapp.com",
          "/api/v1/transactions/mobile/payment",
        ),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer ${PayzyConfig.apiKey}",
          "Accept": "application/json"
        },
        body: TransactionStatusRequest(
          amount: amount,
          sender: sender,
          transactionId: transactionId,
          sms: sms,
          receiver: receiver,
          type: type,
        ).toJson(),
      );

      if (post.statusCode == 200) {
        return TransactionResponse.fromJson(jsonDecode(post.body));
      } else {
        return TransactionResponse(
          message: jsonDecode(post.body)["message"],
        );
      }
    } catch (e) {
      return TransactionResponse(message: e.toString());
    }
  }
}

import 'dart:convert';

WalletBalanceModel walletBalanceModelFromJson(String str) =>
    WalletBalanceModel.fromJson(json.decode(str));

String walletBalanceModelToJson(WalletBalanceModel data) =>
    json.encode(data.toJson());

class WalletBalanceModel {
  WalletBalanceModel({
    this.walletTransation = const [],
    this.walletBalance,
  });

  List<WalletTransation> walletTransation;
  double? walletBalance;

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) =>
      WalletBalanceModel(
        walletTransation: json["wallet_transation"] == null
            ? []
            : List<WalletTransation>.from(json["wallet_transation"]
                .map((x) => WalletTransation.fromJson(x))),
        walletBalance: json["wallet_balance"] == null
            ? null
            : json["wallet_balance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "wallet_transation":
            List<dynamic>.from(walletTransation.map((x) => x.toJson())),
        "wallet_balance": walletBalance,
      };
}

class WalletTransation {
  WalletTransation({
    this.transactionAlias,
    this.amount,
    this.createdAt,
    this.transactions = const [],
  });

  String? transactionAlias;
  double? amount;
  DateTime? createdAt;
  List<Transaction> transactions;

  factory WalletTransation.fromJson(Map<String, dynamic> json) =>
      WalletTransation(
        transactionAlias: json["transaction_alias"],
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        transactions: json["transactions"] == null
            ? []
            : List<Transaction>.from(
                json["transactions"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transaction_alias": transactionAlias,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    this.id,
    this.providerId,
    this.transactionId,
    this.transactionAlias,
    this.transactionDesc,
    this.type,
    this.amount,
    this.openBalance,
    this.closeBalance,
    this.paymentMode,
    this.createdAt,
  });

  int? id;
  int? providerId;
  int? transactionId;
  String? transactionAlias;
  String? transactionDesc;
  String? type;
  double? amount;
  double? openBalance;
  double? closeBalance;
  String? paymentMode;
  DateTime? createdAt;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        providerId: json["provider_id"],
        transactionId: json["transaction_id"],
        transactionAlias: json["transaction_alias"],
        transactionDesc: json["transaction_desc"],
        type: json["type"],
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        openBalance: json["open_balance"] == null
            ? null
            : json["open_balance"].toDouble(),
        closeBalance: json["close_balance"] == null
            ? null
            : json["close_balance"].toDouble(),
        paymentMode: json["payment_mode"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "transaction_id": transactionId,
        "transaction_alias": transactionAlias,
        "transaction_desc": transactionDesc,
        "type": type,
        "amount": amount,
        "open_balance": openBalance,
        "close_balance": closeBalance,
        "payment_mode": paymentMode,
        "created_at": createdAt?.toIso8601String(),
      };
}

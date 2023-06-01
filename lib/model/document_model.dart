import 'dart:convert';

DocumentModel documentModelFromJson(String str) => DocumentModel.fromJson(json.decode(str));

String documentModelToJson(DocumentModel data) => json.encode(data.toJson());

class DocumentModel {
  DocumentModel({
    this.documents = const [],
  });

  List<Document> documents;

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
    documents: json["documents"] == null?[]:List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
  };
}

class Document {
  Document({
    this.id,
    this.name,
    this.type,
    this.imagePath,
    this.providerDocuments,
  });

  int? id;
  String? name;
  String? type;
  String? imagePath;
  Providerdocuments? providerDocuments;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    imagePath: json["image_path"],
    providerDocuments: json["providerdocuments"] == null?null:Providerdocuments.fromJson(json["providerdocuments"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "image_path": imagePath,
    "providerdocuments": providerDocuments?.toJson(),
  };
}

class Providerdocuments {
  Providerdocuments({
    this.url,
    this.status,
    this.documentId,
  });

  String? url;
  String? status;
  String? documentId;

  factory Providerdocuments.fromJson(Map<String, dynamic> json) => Providerdocuments(
    url: json["url"],
    status: json["status"],
    documentId: json["document_id"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "status": status,
    "document_id": documentId,
  };
}

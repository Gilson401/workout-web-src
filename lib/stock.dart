class Stock {
  String asset;
  String setor;

  Stock({required this.asset, required this.setor});
  
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
        asset: json['asset'] as String, setor: json['setor'] as String);
  }

   @override
  String toString() => 'asset é $asset , setor é $setor';
}

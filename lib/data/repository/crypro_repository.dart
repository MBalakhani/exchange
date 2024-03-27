import 'package:sarafy/data/datasource/dio_provider.dart';
import 'package:sarafy/data/model/crypto_model/all_crypto_model.dart';

class CryptoDataRepository {
  var response;
  ApiProvider apiProvider = ApiProvider();
  late AllCryptoModel dataFuture;

  Future<AllCryptoModel> getTopGainerData() async {
    response = await apiProvider.getTopGainerData();
    dataFuture = AllCryptoModel.fromJson(response.data);

    return dataFuture;
  }
}

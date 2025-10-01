import 'package:fam_assignment/data/network/network_api_services.dart';
import 'package:fam_assignment/models/card_model.dart';
import 'package:fam_assignment/res/app_url.dart';

class FeedRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<List<HcGroups>> fetchFeedGroups() async {
    final dynamic json = await _apiService.getGetApiResponse(AppUrl.baseUrl);
    final List<dynamic> dataList =
        json is Map<String, dynamic> && json['data'] is List
            ? (json['data'] as List)
            : (json is List ? json : []);

    final List<HcGroups> groups = [];
    for (final item in dataList) {
      try {
        final model = CardModel.fromJson(
          item is Map<String, dynamic> ? item : <String, dynamic>{},
        );
        if (model.hcGroups != null) {
          groups.addAll(model.hcGroups!);
        }
      } catch (_) {}
    }
    return groups;
  }
}

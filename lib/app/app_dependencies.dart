import 'package:ksta/config/app_config.dart';
import 'package:ksta/data/utils/api.dart';
import 'package:ksta/features/news/data/news_repository.dart';

late final Api api;
late final NewsRepository newsRepository;

void initializeAppDependencies() {
  api = Api(
    getAccessToken: () async => null,
    baseUrl: AppConfig.baseUrl.value,
  );

  newsRepository = NewsRepository(api);
}

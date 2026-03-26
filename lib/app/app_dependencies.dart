import 'package:ksta/app/app_repository_globals.dart';
import 'package:ksta/config/app_config.dart';
import 'package:ksta/data/news/homepage_repository.dart';
import 'package:ksta/data/news/stores/article_preview_store.dart';
import 'package:ksta/data/news/stores/author_store.dart';
import 'package:ksta/data/utils/api.dart';
import 'package:ksta/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModePreferenceKey = 'theme_mode';

class AppDependencies {
  const AppDependencies({required this.themeManager});

  final ThemeManager themeManager;
}

Future<AppDependencies> initializeAppDependencies() async {
  api = Api(getAccessToken: () async => null, baseUrl: AppConfig.baseUrl.value);

  homepageRepository = HomepageRepository(api);
  authorStore = AuthorStore();
  articlePreviewStore = ArticlePreviewStore();

  final sharedPreferences = await SharedPreferences.getInstance();
  final themeManager = ThemeManager(
    getString: sharedPreferences.getString,
    setString: (key, value) async {
      await sharedPreferences.setString(key, value);
    },
    themeKey: _themeModePreferenceKey,
  );

  return AppDependencies(themeManager: themeManager);
}

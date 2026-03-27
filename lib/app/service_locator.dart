import 'package:get_it/get_it.dart';
import 'package:ksta/config/app_config.dart';
import 'package:ksta/data/news/stores/article_preview_store.dart';
import 'package:ksta/data/news/stores/author_store.dart';
import 'package:ksta/data/utils/api.dart';
import 'package:ksta/theme/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModePreferenceKey = 'theme_mode';

Future<void> setupServiceLocator() async {
  final getIt = GetIt.instance;

  if (getIt.isRegistered<ThemeManager>()) return;

  final preferences = await SharedPreferences.getInstance();

  getIt
    ..registerSingleton<SharedPreferences>(preferences)
    ..registerLazySingleton<Api>(() => Api(getAccessToken: () async => null, baseUrl: AppConfig.baseUrl.value))
    ..registerLazySingleton<AuthorStore>(() => AuthorStore(api))
    ..registerLazySingleton<ArticlePreviewStore>(() => ArticlePreviewStore(api: api, authorStore: authorStore))
    ..registerLazySingleton<ThemeManager>(
      () => ThemeManager(
        getString: sharedPreferences.getString,
        setString: (key, value) async {
          await sharedPreferences.setString(key, value);
        },
        themeKey: _themeModePreferenceKey,
      ),
    );
}

Api get api => GetIt.instance<Api>();

AuthorStore get authorStore => GetIt.instance<AuthorStore>();

ArticlePreviewStore get articlePreviewStore => GetIt.instance<ArticlePreviewStore>();

SharedPreferences get sharedPreferences => GetIt.instance<SharedPreferences>();

ThemeManager get themeManager => GetIt.instance<ThemeManager>();

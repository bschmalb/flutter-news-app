import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ksta/app/app_repository_globals.dart';
import 'package:ksta/data/news/models/news_homepage_response_model.dart';
import 'package:ksta/data/news/utils/homepage_block_mapper.dart';
import 'package:ksta/data/utils/api_exception.dart';
import 'package:ksta/pages/home/controllers/homepage_block_controller.dart';

class HomepageController extends ChangeNotifier {
  HomepageController();

  NewsHomepageResponseModel? get homepage => _homepage;
  NewsHomepageResponseModel? _homepage;

  List<HomepageBlockController> get blockControllers => _blockControllers;
  List<HomepageBlockController> _blockControllers = const [];

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;

  bool get hasContent => _homepage != null;
  String get pageTitle => _homepage?.analytics.pageName ?? 'Homepage';

  Future<void> load() async {
    // Avoid duplicate requests.
    if (_isLoading) return;

    await _fetchHomepage();
  }

  Future<void> reload() async => _fetchHomepage(refreshArticles: true);

  Future<void> _fetchHomepage({bool refreshArticles = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final homepage = await homepageRepository.fetchHomepage();
      // Rebuild the block controllers from the latest homepage response so each
      // section gets its own loading and article resolution state.
      final blockControllers = homepage
          .toHomepageBlocks()
          .map(
            (block) => HomepageBlockController(
              block: block,
              refreshOnFirstLoad: refreshArticles,
            ),
          )
          .toList(growable: false);

      _disposeBlockControllers();
      _homepage = homepage;
      _blockControllers = blockControllers;
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();

      // The splash screen should disappear after the first homepage request
      // completes, even if that request ends in an error state.
      FlutterNativeSplash.remove();
    }
  }

  void _disposeBlockControllers() {
    for (final controller in _blockControllers) {
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeBlockControllers();
    super.dispose();
  }
}

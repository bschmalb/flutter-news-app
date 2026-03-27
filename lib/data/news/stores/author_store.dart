import 'dart:developer';
import 'package:ksta/data/news/homepage_repository.dart';
import 'package:ksta/data/news/models/author_profile_model.dart';
import 'package:ksta/data/utils/api.dart';

class AuthorStore {
  AuthorStore(Api api) : _repository = HomepageRepository(api);

  final HomepageRepository _repository;

  final Map<int, AuthorProfileModel> _cache = {};
  final Map<int, Future<AuthorProfileModel?>> _inFlight = {};

  AuthorProfileModel? peek(int authorId) => _cache[authorId];

  Map<int, AuthorProfileModel?> peekMany(Iterable<int> authorIds) {
    return {for (final authorId in authorIds) authorId: _cache[authorId]};
  }

  Future<AuthorProfileModel?> fetch(int authorId, {bool refresh = false}) {
    if (!refresh) {
      final cached = _cache[authorId];
      if (cached != null) {
        return Future.value(cached);
      }

      final inFlight = _inFlight[authorId];
      if (inFlight != null) {
        return inFlight;
      }
    }

    final future = () async {
      try {
        final author = await _repository.fetchAuthorProfile(authorId);
        _cache[authorId] = author;
        return author;
      } catch (error, stackTrace) {
        log('Failed to fetch author profile for $authorId: $error', stackTrace: stackTrace);
        return null;
      } finally {
        _inFlight.remove(authorId);
      }
    }();

    _inFlight[authorId] = future;
    return future;
  }

  Future<Map<int, AuthorProfileModel?>> fetchMany(Iterable<int> authorIds, {bool refresh = false}) async {
    final uniqueAuthorIds = authorIds.toSet().toList(growable: false);
    final results = await Future.wait(
      uniqueAuthorIds.map((authorId) async => MapEntry(authorId, await fetch(authorId, refresh: refresh))),
    );

    return Map<int, AuthorProfileModel?>.fromEntries(results);
  }
}

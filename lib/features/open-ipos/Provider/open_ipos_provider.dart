import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ipo_lens/core/services/crashlytics_service.dart';
import 'package:ipo_lens/core/services/performance_service.dart';
import 'package:ipo_lens/features/open-ipos/Models/open_ipo_models.dart';

class OpenIposProvider extends ChangeNotifier {
  final http.Client _client;
  final String _baseUrl;

  OpenIposProvider({required http.Client client, required String baseUrl})
    : _client = client,
      _baseUrl = baseUrl;

  // Open IPOs
  bool _isLoading = false;
  String? _error;
  List<IpoItem> _items = const [];
  DateTime? _lastUpdated;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<IpoItem> get items => _items;
  DateTime? get lastUpdated => _lastUpdated;

  // Upcoming IPOs
  bool _isLoadingUpcoming = false;
  String? _errorUpcoming;
  List<IpoItem> _upcomingItems = const [];
  DateTime? _lastUpdatedUpcoming;

  bool get isLoadingUpcoming => _isLoadingUpcoming;
  String? get errorUpcoming => _errorUpcoming;
  List<IpoItem> get upcomingItems => _upcomingItems;
  DateTime? get lastUpdatedUpcoming => _lastUpdatedUpcoming;

  // Closed/Listed IPOs
  bool _isLoadingClosed = false;
  String? _errorClosed;
  List<IpoItem> _closedItems = const [];
  DateTime? _lastUpdatedClosed;

  bool get isLoadingClosed => _isLoadingClosed;
  String? get errorClosed => _errorClosed;
  List<IpoItem> get closedItems => _closedItems;
  DateTime? get lastUpdatedClosed => _lastUpdatedClosed;

  Future<void> fetch({bool force = false}) async {
    if (_isLoading) return;
    if (!force && _items.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final payload = await PerformanceService().traceApiCall(
        'open_ipos',
        () => _fetchIpos(category: 'open', limit: 50),
        parameters: {'category': 'open', 'limit': '50'},
      );
      _items = payload.data ?? [];
      _lastUpdated = DateTime.now();
      
      // Log successful fetch
      await CrashlyticsService().log('Fetched ${_items.length} open IPOs');
    } catch (e) {
      _error = e.toString();
      
      // Log error to Crashlytics
      await CrashlyticsService().logError(
        e,
        StackTrace.current,
        reason: 'Failed to fetch open IPOs',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetch(force: true);
  }

  Future<void> fetchUpcoming({bool force = false}) async {
    if (_isLoadingUpcoming) return;
    if (!force && _upcomingItems.isNotEmpty) return;

    _isLoadingUpcoming = true;
    _errorUpcoming = null;
    notifyListeners();

    try {
      final payload = await PerformanceService().traceApiCall(
        'upcoming_ipos',
        () => _fetchIpos(category: 'upcoming', limit: 50),
        parameters: {'category': 'upcoming', 'limit': '50'},
      );
      _upcomingItems = payload.data ?? [];
      _lastUpdatedUpcoming = DateTime.now();
      
      // Log successful fetch
      await CrashlyticsService().log('Fetched ${_upcomingItems.length} upcoming IPOs');
    } catch (e) {
      _errorUpcoming = e.toString();
      
      // Log error to Crashlytics
      await CrashlyticsService().logError(
        e,
        StackTrace.current,
        reason: 'Failed to fetch upcoming IPOs',
      );
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  Future<void> refreshUpcoming() async {
    await fetchUpcoming(force: true);
  }

  Future<void> fetchClosed({bool force = false}) async {
    if (_isLoadingClosed) return;
    if (!force && _closedItems.isNotEmpty) return;

    _isLoadingClosed = true;
    _errorClosed = null;
    notifyListeners();

    try {
      final payload = await PerformanceService().traceApiCall(
        'listed_ipos',
        () => _fetchIpos(category: 'listed', limit: 50),
        parameters: {'category': 'listed', 'limit': '50'},
      );
      _closedItems = payload.data ?? [];
      _lastUpdatedClosed = DateTime.now();
      
      // Log successful fetch
      await CrashlyticsService().log('Fetched ${_closedItems.length} listed IPOs');
    } catch (e) {
      _errorClosed = e.toString();
      
      // Log error to Crashlytics
      await CrashlyticsService().logError(
        e,
        StackTrace.current,
        reason: 'Failed to fetch listed IPOs',
      );
    } finally {
      _isLoadingClosed = false;
      notifyListeners();
    }
  }

  Future<void> refreshClosed() async {
    await fetchClosed(force: true);
  }

  IpoItem? getById(String id) {
    // Search in all lists
    for (final item in _items) {
      if (item.id == id) return item;
    }
    for (final item in _upcomingItems) {
      if (item.id == id) return item;
    }
    for (final item in _closedItems) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<IpoOpenPayload> _fetchIpos({required String category, required int limit}) async {
    final uri = Uri.parse('$_baseUrl/ipo/$category?limit=$limit');
    final res = await _client.get(
      uri,
      headers: const {'accept': 'application/json'},
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      // Log HTTP error to Crashlytics
      await CrashlyticsService().logHttpError(
        endpoint: '/ipo/$category',
        statusCode: res.statusCode,
        errorMessage: 'HTTP ${res.statusCode}',
        response: res.body,
      );
      
      throw Exception('IPO API ($category) failed: HTTP ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      await CrashlyticsService().logError(
        Exception('Invalid JSON response'),
        StackTrace.current,
        reason: 'IPO API ($category): invalid JSON',
      );
      throw Exception('IPO API ($category): invalid JSON');
    }

    final api = IpoOpenResponse.fromJson(decoded);
    if (api.success != true) {
      await CrashlyticsService().logBusinessError(
        operation: 'fetch_ipos',
        error: api.message ?? 'Unknown error',
        context: {'category': category, 'limit': limit},
      );
      
      throw Exception(
        api.message != null && api.message!.isNotEmpty ? api.message : 'IPO API ($category): failed',
      );
    }

    final payload = api.data;
    if (payload == null) {
      await CrashlyticsService().logError(
        Exception('Missing data in response'),
        StackTrace.current,
        reason: 'IPO API ($category): missing data',
      );
      throw Exception('IPO API ($category): missing data');
    }
    return payload;
  }
}
    


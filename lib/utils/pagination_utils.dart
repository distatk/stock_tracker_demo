import 'package:async/async.dart';
import 'package:stock_tracker_demo/constants/configs.dart';
import 'package:stock_tracker_demo/data_models/pagination_model.dart';

/// Utilities for pagination apis
class PaginationUtils<T> {
  /// To use this utils, you must create an instance of this utils by
  /// ```
  /// final instance = PaginationUtils(
  ///   list: list of object to be display,
  ///   callback: function to be called when getting data from server,
  /// )
  /// ```
  ///
  /// When you want to load data for the first time,
  /// calls `await instance.firstFetch()`.
  ///
  /// When you want to load more data if it is possible,
  /// calls `await instance.loadMore()`
  PaginationUtils({required this.list, required this.callback});

  /// list of objects that store all data
  final List<T> list;

  /// callback function to be called
  ///
  /// callback must return [PaginationModel]
  final Future<PaginationModel<T>> Function(int? start) callback;

  int _currentPage = 0;
  int _totalDataCount = 1;
  int _dataCount = 0;

  // singleton fetching
  CancelableOperation<List<T>>? _firstFetchingSingleton;

  /// remove duplicated item(s) from [list]
  void removeDuplicatedItemsFromList() {
    final uniqueSet = Set.from(list);
    list.retainWhere(uniqueSet.remove);
  }

  /// can we load more information from callback
  bool canLoadMore = false;

  /// is pagination utils is fetching data
  bool isFetching = false;

  /// fetch data for the first time
  /// clear all data and fetch
  Future<void> firstFetch({int? start}) async {
    if (_firstFetchingSingleton != null) {
      await _firstFetchingSingleton!.cancel();
    }

    // reset current page
    _currentPage = start ?? 0;
    _firstFetchingSingleton = CancelableOperation.fromFuture(
      _fetchData(pageToLoad: start),
      onCancel: () {
        return [];
      },
    );

    final data = await _firstFetchingSingleton?.value ?? [];

    list
      ..clear()
      ..addAll(data);
    removeDuplicatedItemsFromList();
  }

  /// load more data from server
  Future<void> loadMore() async {
    if (_dataCount == _totalDataCount) {
      final data = await _fetchData(pageToLoad: _currentPage);
      list.addAll(data);
    } else {
      final data = await _fetchData(pageToLoad: _currentPage + 1);
      list.addAll(data);
    }
    _dataCount = list.length;
    print('_dataCount: $_dataCount, _totalDataCount: $_totalDataCount');
    canLoadMore = _dataCount < _totalDataCount;
    _currentPage = _dataCount ~/ Configs.defaultPageSize;
    removeDuplicatedItemsFromList();
  }

  /// fetch data from callback
  Future<List<T>> _fetchData({int? pageToLoad}) async {
    isFetching = true;
    if (pageToLoad != null) {
      _currentPage = pageToLoad;
    }
    final result = await callback.call(_currentPage);
    _totalDataCount = result.totalDataCount;
    isFetching = false;
    return result.objectList;
  }

  /// get count of all data
  int getCount() {
    return _dataCount;
  }

  /// clear items in list
  void clearList() {
    list.clear();
  }
}

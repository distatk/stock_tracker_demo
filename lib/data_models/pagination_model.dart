// coverage:ignore-file
import 'package:equatable/equatable.dart';

/// Pagination data model for pagination apis
///
/// where T is the data type of object in the list
class PaginationModel<T> extends Equatable {
  /// constructor
  const PaginationModel({
    required this.objectList,
    required this.totalDataCount,
    this.dataCount,
  });

  /// object list of response
  final List<T> objectList;

  /// total length of data
  final int totalDataCount;

  /// current length of data
  final int? dataCount;

  @override
  List<Object?> get props => [objectList, totalDataCount];

  /// default model for error from server
  static PaginationModel defaultModel() => PaginationModel(
        objectList: [],
        totalDataCount: 1,
        dataCount: 0,
      );
}

/// Pagination models for handling paginated API responses
///
/// Provides utilities for managing paginated data throughout the application.
library;

/// Pagination information for API responses
class Pagination {
  /// Current page number (1-based)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of items across all pages
  final int totalItems;

  /// Number of items per page
  final int itemsPerPage;

  /// Whether there are more pages after the current one
  final bool hasNextPage;

  /// Whether there are pages before the current one
  final bool hasPreviousPage;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  /// Create pagination from basic parameters
  factory Pagination.fromParams({
    required int currentPage,
    required int totalItems,
    required int itemsPerPage,
  }) {
    final totalPages = (totalItems / itemsPerPage).ceil();

    return Pagination(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      itemsPerPage: itemsPerPage,
      hasNextPage: currentPage < totalPages,
      hasPreviousPage: currentPage > 1,
    );
  }

  /// Create empty pagination (no items)
  factory Pagination.empty() {
    return const Pagination(
      currentPage: 1,
      totalPages: 0,
      totalItems: 0,
      itemsPerPage: 0,
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }

  /// Create from JSON map
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 0,
      totalItems: json['totalItems'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  /// Get the next page number (null if no next page)
  int? get nextPage => hasNextPage ? currentPage + 1 : null;

  /// Get the previous page number (null if no previous page)
  int? get previousPage => hasPreviousPage ? currentPage - 1 : null;

  /// Get the starting item index for the current page (0-based)
  int get startIndex => (currentPage - 1) * itemsPerPage;

  /// Get the ending item index for the current page (0-based, exclusive)
  int get endIndex => startIndex + itemsPerPage;

  /// Check if this is the first page
  bool get isFirstPage => currentPage == 1;

  /// Check if this is the last page
  bool get isLastPage => currentPage == totalPages;

  /// Check if there are any items
  bool get hasItems => totalItems > 0;

  /// Get a range of page numbers around the current page
  List<int> getPageRange({int radius = 2}) {
    if (totalPages == 0) return [];

    final start = (currentPage - radius).clamp(1, totalPages);
    final end = (currentPage + radius).clamp(1, totalPages);

    return List.generate(end - start + 1, (index) => start + index);
  }

  /// Create a copy with updated values
  Pagination copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? itemsPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  @override
  String toString() {
    return 'Pagination(currentPage: $currentPage, totalPages: $totalPages, totalItems: $totalItems, itemsPerPage: $itemsPerPage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pagination &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.totalItems == totalItems &&
        other.itemsPerPage == itemsPerPage &&
        other.hasNextPage == hasNextPage &&
        other.hasPreviousPage == hasPreviousPage;
  }

  @override
  int get hashCode {
    return currentPage.hashCode ^
        totalPages.hashCode ^
        totalItems.hashCode ^
        itemsPerPage.hashCode ^
        hasNextPage.hashCode ^
        hasPreviousPage.hashCode;
  }
}

/// Paginated data wrapper that combines data with pagination info
class PaginatedData<T> {
  /// The list of items for the current page
  final List<T> items;

  /// Pagination information
  final Pagination pagination;

  const PaginatedData({
    required this.items,
    required this.pagination,
  });

  /// Create empty paginated data
  factory PaginatedData.empty() {
    return PaginatedData<T>(
      items: const [],
      pagination: Pagination.empty(),
    );
  }

  /// Create from items and pagination parameters
  factory PaginatedData.fromParams({
    required List<T> items,
    required int currentPage,
    required int totalItems,
    required int itemsPerPage,
  }) {
    return PaginatedData<T>(
      items: items,
      pagination: Pagination.fromParams(
        currentPage: currentPage,
        totalItems: totalItems,
        itemsPerPage: itemsPerPage,
      ),
    );
  }

  /// Check if there are any items
  bool get hasItems => items.isNotEmpty;

  /// Check if this is empty
  bool get isEmpty => items.isEmpty;

  /// Get the number of items in the current page
  int get itemCount => items.length;

  /// Create a copy with updated values
  PaginatedData<T> copyWith({
    List<T>? items,
    Pagination? pagination,
  }) {
    return PaginatedData<T>(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  String toString() {
    return 'PaginatedData(items: ${items.length}, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginatedData<T> &&
        other.items == items &&
        other.pagination == pagination;
  }

  @override
  int get hashCode {
    return items.hashCode ^ pagination.hashCode;
  }
}

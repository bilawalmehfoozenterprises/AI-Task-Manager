/// The two refresh animations being compared.
enum RefreshVariant {
  tornado('Task Tornado Refresh'),
  buddy('Task Buddy Refresh');

  const RefreshVariant(this.artboard);

  /// Artboard name inside `task_refresh_comparison.riv`.
  final String artboard;
}

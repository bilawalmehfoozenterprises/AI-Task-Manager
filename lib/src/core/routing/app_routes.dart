/// Every screen in the app. Navigate by name, e.g.
/// `context.pushNamed(AppRoute.taskDetails.name, pathParameters: ...)`,
/// so features never import each other's screens.
enum AppRoute {
  home,
  newTask,
  taskDetails,
  editTask,
  aiAssistant;

  /// Path parameter holding a task id, used by [taskDetails] and [editTask].
  static const taskIdParam = 'id';
}

enum NotesView {
  small(1, 'Small'),
  split(2, 'Split'),
  large(3, 'Large');

  const NotesView(this.notesViewId, this.notesViewName);
  final int notesViewId;
  final String notesViewName;
}

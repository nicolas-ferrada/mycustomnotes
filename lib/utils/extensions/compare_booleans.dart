// Compare booleans, used to order them.
extension CompareBooleans on bool {
  static int compareBooleans(bool a, bool b) {
    if (a == b) {
      return 0;
    }
    return a ? -1 : 1;
  }
}

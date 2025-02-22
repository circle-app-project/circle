extension TextCase on String {
  String toTitleCase() {
    return split(" ")
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .join(" ");
  }
}

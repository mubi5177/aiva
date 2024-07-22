extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this; // Return the original string if it's empty
    } else {
      return this[0].toUpperCase() + substring(1);
    }
  }
}

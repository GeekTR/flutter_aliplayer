class FormatterUtils {
  static String getFileSizeDescription(int size) {
    StringBuffer bytes = new StringBuffer();
    if (size >= 1024 * 1024 * 1024) {
      double i = (size / (1024.00 * 1024.00 * 1024.00));
      bytes..write(i.toStringAsFixed(2))..write("G");
    } else if (size >= 1024 * 1024) {
      double i = (size / (1024.00 * 1024.00));
      bytes..write(i.toStringAsFixed(2))..write("M");
    } else if (size >= 1024) {
      double i = (size / (1024.00));
      bytes..write(i.toStringAsFixed(2))..write("K");
    } else if (size < 1024) {
      if (size <= 0) {
        bytes.write("0B");
      } else {
        bytes..write(size)..write("B");
      }
    }
    return bytes.toString();
  }
}

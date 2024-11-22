

// Or with comma separators (less precise)
String getFancyNumber(double number) {
  // Split into integer and decimal parts
  String numberString = number.toStringAsFixed(2);
  List<String> parts = numberString.split('.');

  // Format integer part in Indian style
  String integerPart = parts[0];
  String formattedInteger = integerPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{2})+(\d{1})(?!\d))'),
          (Match m) => '${m[0]},'
  );

  // Combine back with decimal part
  return '$formattedInteger.${parts[1]}';
}
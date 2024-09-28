class TextUtils {
  static String sectorNameToId(String sectorName) {
    final upperCaseSectorName = sectorName.toUpperCase();
    final sectorId = upperCaseSectorName.replaceAll(' ', '_');
    return sectorId;
  }
}

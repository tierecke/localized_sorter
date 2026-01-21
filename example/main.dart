import 'package:localized_sorter/localized_sorter.dart';

void main() {
  // Example 1: Spanish (Ñ is a distinct letter between N and O)
  List<String> spanishWords = ['oscar', 'niño', 'nino'];
  spanishWords.sort((a, b) => LocalizedSorter.compare(a, b, 'es'));
  print('Spanish: $spanishWords');
  // Result: [nino, niño, oscar]

  // Example 2: Swedish (Å, Ä, Ö are at the very end of the alphabet)
  List<String> swedishWords = ['Örebro', 'Zürich', 'Åland'];
  swedishWords.sort((a, b) => LocalizedSorter.compare(a, b, 'sv'));
  print('Swedish: $swedishWords');
  // Result: [Zürich, Åland, Örebro]

  // Example 3: Estonian (Z and Ž follow S)
  List<String> estonianWords = ['vaba', 'zambia', 'saar'];
  estonianWords.sort((a, b) => LocalizedSorter.compare(a, b, 'et'));
  print('Estonian: $estonianWords');
  // Result: [saar, zambia, vaba]
}

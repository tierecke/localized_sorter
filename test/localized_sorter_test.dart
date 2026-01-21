import 'package:flutter_test/flutter_test.dart';
import 'package:localized_sorter/localized_sorter.dart';

void main() {
  group('LocalizedSorter - Support & Logic Validation', () {
    test('isSupported check', () {
      expect(LocalizedSorter.isSupported('en'), true);
      expect(LocalizedSorter.isSupported('es_ES'), true);
      expect(LocalizedSorter.isSupported('hu'), true);
      expect(LocalizedSorter.isSupported('ja'), false);
    });

    test('Spanish (es) - Niño follows Nino and precedes Oscar', () {
      final list = ['oscar', 'niño', 'nino'];
      list.sort((a, b) => LocalizedSorter.compare(a, b, 'es'));
      expect(list, ['nino', 'niño', 'oscar']);
    });

    test('Estonian (et) - Z correctly follows S/Š and precedes V', () {
      final list = ['vaba', 'zambia'];
      list.sort((a, b) => LocalizedSorter.compare(a, b, 'et'));
      expect(list, ['zambia', 'vaba']);
    });

    test('German (de) - Normalization strips accents correctly', () {
      final list = ['Árvíz', 'Åland', 'Ägypten'];
      list.sort((a, b) => LocalizedSorter.compare(a, b, 'de'));
      expect(list, ['Ägypten', 'Åland', 'Árvíz']);
    });

    test('Dutch (nl) - Basic Latin sorting (j < z)', () {
      final list = ['izák', 'ijs'];
      list.sort((a, b) => LocalizedSorter.compare(a, b, 'nl'));
      expect(list, ['ijs', 'izák']);
    });
  });
}

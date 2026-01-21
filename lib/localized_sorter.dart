/// Package: com.tierecke.library_sorted
/// Copyright (c) 2026 Tierecke. All rights reserved.
/// Licensed under the MIT License.
///
/// A high-performance, zero-allocation localized sorter for Dart and Flutter.
///
/// This library provides linguistic-aware string comparison. It is designed
/// to be memory-efficient by avoiding String allocations (like substring or split)
/// during sorting, which prevents Garbage Collection spikes in large lists.
class LocalizedSorter {
  /// Multi-character letters (digraphs/trigraphs) treated as single units.
  /// Tokens are matched "Greedily" (longest first) to ensure 'dzs' beats 'dz'.
  static final Map<String, List<String>> _digraphs = {
    'hu': ['dzs', 'dz', 'cs', 'gy', 'ly', 'ny', 'sz', 'ty', 'zs'],
    'nl': ['ij'],
    'cs': ['ch'],
    'sk': ['ch', 'dz', 'dž'],
  };

  /// Locales where accents are decorations. Primary sort is on the base Latin letter.
  /// Dutch (nl) is handled here for simplicity (sorting i-j as separate characters).
  static const Set<String> _normalizedLanguages = {
    'en',
    'de',
    'fr',
    'it',
    'pt',
    'nl'
  };

  /// Custom alphabet weights defining the precise linguistic order of each locale.
  static const Map<String, List<String>> _alphabetWeights = {
    'sv': [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      'å',
      'ä',
      'ö'
    ],
    'fi': [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      'å',
      'ä',
      'ö'
    ],
    // Estonian: S, Š, Z, Ž are grouped together. Z/Ž come BEFORE T, U, V.
    'et': [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      'š',
      'z',
      'ž',
      't',
      'u',
      'v',
      'w',
      'õ',
      'ä',
      'ö',
      'ü',
      'x',
      'y'
    ],
    // Spanish: 'ñ' is a distinct letter between 'n' and 'o'.
    'es': [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'ñ',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ],
    'is': [
      'a',
      'á',
      'b',
      'c',
      'd',
      'ð',
      'e',
      'é',
      'f',
      'g',
      'h',
      'i',
      'í',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'ú',
      'v',
      'w',
      'x',
      'y',
      'ý',
      'z',
      'þ',
      'æ',
      'ö'
    ],
    'pl': [
      'a',
      'ą',
      'b',
      'c',
      'ć',
      'd',
      'e',
      'ę',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'ł',
      'm',
      'n',
      'ń',
      'o',
      'ó',
      'p',
      'r',
      's',
      'ś',
      't',
      'u',
      'w',
      'y',
      'z',
      'ź',
      'ż'
    ],
    'hu': [
      'a',
      'á',
      'b',
      'c',
      'cs',
      'd',
      'dz',
      'dzs',
      'e',
      'é',
      'f',
      'g',
      'gy',
      'h',
      'i',
      'í',
      'j',
      'k',
      'l',
      'ly',
      'm',
      'n',
      'ny',
      'o',
      'ó',
      'ö',
      'ő',
      'p',
      'q',
      'r',
      's',
      'sz',
      't',
      'ty',
      'u',
      'ú',
      'ü',
      'ű',
      'v',
      'w',
      'x',
      'y',
      'z',
      'zs'
    ],
    'cs': [
      'a',
      'á',
      'b',
      'c',
      'č',
      'd',
      'ď',
      'e',
      'é',
      'ě',
      'f',
      'g',
      'h',
      'ch',
      'i',
      'í',
      'j',
      'k',
      'l',
      'm',
      'n',
      'ň',
      'o',
      'ó',
      'p',
      'q',
      'r',
      'ř',
      's',
      'š',
      't',
      'ť',
      'u',
      'ú',
      'ů',
      'v',
      'w',
      'x',
      'y',
      'ý',
      'z',
      'ž'
    ],
    'sk': [
      'a',
      'á',
      'ä',
      'b',
      'c',
      'č',
      'd',
      'ď',
      'dz',
      'dž',
      'e',
      'é',
      'f',
      'g',
      'h',
      'ch',
      'i',
      'í',
      'j',
      'k',
      'l',
      'ĺ',
      'ľ',
      'm',
      'n',
      'ň',
      'o',
      'ó',
      'ô',
      'p',
      'q',
      'r',
      'ŕ',
      's',
      'š',
      't',
      'ť',
      'u',
      'ú',
      'v',
      'w',
      'x',
      'y',
      'ý',
      'z',
      'ž'
    ],
  };

  /// Lookup tables for real-time accent-to-base-letter conversion.
  static const String _accents =
      'áàâäãåąćčçďðéèêëěęíìîïłĺľńňñóòôöőõøŕřśšťþúùûüůűýźžżæ';
  static const String _bases =
      'aaaaaaacccddeeeeeeeiiiilllnnnooooooorrsssttuuuuuuyzzza';

  /// Returns true if the sorter has custom linguistic rules for the provided [localeCode].
  static bool isSupported(String localeCode) {
    final String lang = localeCode.split('_')[0].toLowerCase();
    return _normalizedLanguages.contains(lang) ||
        _alphabetWeights.containsKey(lang);
  }

  /// The main comparison logic. Uses pointers to compare strings without allocating memory.
  static int compare(String a, String b, String locale) {
    if (identical(a, b)) return 0; // Reference equality check.

    final String lang = locale.split('_')[0].toLowerCase();
    final String s1 = a.toLowerCase();
    final String s2 = b.toLowerCase();

    // Strategy 1: Normalized Path (Strip-Only)
    if (_normalizedLanguages.contains(lang)) {
      return _compareByStripping(s1, s2);
    }

    // Strategy 2: Weighted Path (Native Weights & Digraphs)
    if (_alphabetWeights.containsKey(lang)) {
      return _compareByWeight(s1, s2, lang);
    }

    return s1.compareTo(s2);
  }

  /// Internal: Compares by folding accents into base letters (O(N) time, O(1) memory).
  static int _compareByStripping(String a, String b) {
    int i = 0, j = 0;
    while (i < a.length && j < b.length) {
      final int codeA = _getBaseCharCode(a.codeUnitAt(i));
      final int codeB = _getBaseCharCode(b.codeUnitAt(j));
      if (codeA != codeB) return codeA.compareTo(codeB);
      i++;
      j++;
    }
    return a.compareTo(b);
  }

  /// Internal: Weighted comparison using pointers and greedy digraph detection.
  static int _compareByWeight(String a, String b, String lang) {
    final List<String> weights = _alphabetWeights[lang]!;
    final List<String> digraphs = _digraphs[lang] ?? [];

    int i = 0, j = 0;
    while (i < a.length && j < b.length) {
      final String tokenA = _peekNextToken(a, i, digraphs, weights);
      final String tokenB = _peekNextToken(b, j, digraphs, weights);

      if (tokenA != tokenB) {
        final int w1 = weights.indexOf(tokenA);
        final int w2 = weights.indexOf(tokenB);

        if (w1 != -1 && w2 != -1) return w1.compareTo(w2);
        if (w1 != -1) return -1;
        if (w2 != -1) return 1;
        return tokenA.compareTo(tokenB);
      }
      i += tokenA.length;
      j += tokenB.length;
    }
    return a.compareTo(b);
  }

  /// Helper: Converts accented char codes to base Latin codes.
  static int _getBaseCharCode(int codeUnit) {
    if (codeUnit == 223) return 115; // ß -> s
    final String char = String.fromCharCode(codeUnit);
    final int index = _accents.indexOf(char);
    return (index == -1) ? codeUnit : _bases.codeUnitAt(index);
  }

  /// Helper: Greedily identifies the next unit (digraph, native weight, or base letter).
  static String _peekNextToken(
      String s, int pos, List<String> digraphs, List<String> weights) {
    for (final String d in digraphs) {
      if (s.startsWith(d, pos)) return d;
    }
    final String char = s[pos];
    if (weights.contains(char)) return char;
    final int accentIdx = _accents.indexOf(char);
    if (accentIdx != -1) {
      final String base = _bases[accentIdx];
      if (weights.contains(base)) return base;
    }
    return char;
  }
}

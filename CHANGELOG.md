# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2026-01-21

### Added
- Initial beta release of `localized_sorter`.
- High-performance linguistic sorting for 17+ languages.
- **Zero-allocation** comparison algorithm using `codeUnitAt`.
- Support for **Spanish (Ñ)**, **Estonian (Z/Ž)**, and **Nordic (Å, Ä, Ö)** specific alphabet rules.
- Support for **Hungarian, Czech, and Slovak digraphs** (e.g., `ch`, `dzs`, `sz`).
- Smart normalization strategy for English, German, and French (stripping accents on-the-fly).
- Fallback mechanism for standard Unicode sorting on unsupported locales.
- Comprehensive `README.md` with usage examples and linguistic explanations.

### Changed
- Refined `LocalizedSorter.compare` to utilize pointers for O(1) memory overhead.

### Fixed
- Resolved incorrect sorting of Spanish words where 'Ñ' was appearing after 'Z'.
- Fixed Estonian 'Z' positioning to correctly follow 'S'.
# 🌍 localized_sorter

[![pub package](https://img.shields.io/badge/pub-v0.1.0-blue.svg)](https://pub.dev/packages/localized_sorter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**High-performance, zero-allocation, linguistic string comparison for Flutter and Dart.**

---

## 🧐 The Problem

In a global application, standard string sorting (`list.sort()`) relies on **Unicode codepoint values**. This creates "alphabetical bugs" where words appear in the wrong order according to a user's native language.

* In **Spanish**, *Niño* often appears incorrectly after *Oscar* because the Unicode value of `Ñ` is higher than `O`.
* In **Estonian**, *Zambia* appears incorrectly at the end of the list, even though `Z` is the 19th letter of the alphabet (between `S` and `T`).
* In **Swedish**, `Ä` is often mixed in with `A`, despite being a completely distinct letter at the end of the alphabet.



## 💡 The Solution

`localized_sorter` solves this by implementing specific **Linguistic Rules** for 17+ languages.

It is optimized for mobile performance using a **Zero-Allocation** strategy. Instead of creating new string objects (which triggers Garbage Collection and frame drops), the algorithm uses pointers to compare character codes directly in memory.

---

## 🛠️ Installation

Add the latest version of `localized_sorter` to your `pubspec.yaml`:

```yaml
dependencies:
  localized_sorter: ^latest
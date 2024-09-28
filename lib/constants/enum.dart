import 'package:flutter/material.dart';

enum Market {
  th,
  us,
  sg,
  vn,
  hk,
  uk,
  jp,
  cn,
  tw,
  ind,
  au,
  de,
  ca,
  fr,
  kr,
  ru,
}

extension MarketExtension on Market {
  String get requestValue {
    switch (this) {
      case Market.th:
        return 'TH';
      case Market.us:
        return 'US';
      case Market.sg:
        return 'SG';
      case Market.vn:
        return 'VN';
      case Market.hk:
        return 'HK';
      case Market.uk:
        return 'UK';
      case Market.jp:
        return 'JP';
      case Market.cn:
        return 'CN';
      case Market.tw:
        return 'TW';
      case Market.ind:
        return 'IN';
      case Market.au:
        return 'AU';
      case Market.de:
        return 'DE';
      case Market.ca:
        return 'CA';
      case Market.fr:
        return 'FR';
      case Market.kr:
        return 'KR';
      case Market.ru:
        return 'RU';
    }
  }

  String get label {
    switch (this) {
      case Market.th:
        return 'Thailand';
      case Market.us:
        return 'United States';
      case Market.sg:
        return 'Singapore';
      case Market.vn:
        return 'Vietnam';
      case Market.hk:
        return 'Hong Kong';
      case Market.uk:
        return 'United Kingdom';
      case Market.jp:
        return 'Japan';
      case Market.cn:
        return 'China';
      case Market.tw:
        return 'Taiwan';
      case Market.ind:
        return 'India';
      case Market.au:
        return 'Australia';
      case Market.de:
        return 'Germany';
      case Market.ca:
        return 'Canada';
      case Market.fr:
        return 'France';
      case Market.kr:
        return 'Korea';
      case Market.ru:
        return 'Russia';
    }
  }

  DropdownMenuEntry<Market> get dropdownMenuEntry {
    return DropdownMenuEntry<Market>(
      label: label,
      value: this,
    );
  }
}

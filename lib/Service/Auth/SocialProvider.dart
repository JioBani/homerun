enum SocialProvider {
  kakao,
  naver,
  other,
}

extension SocialProviderExtension on SocialProvider {
  static SocialProvider fromString(String provider) {
    switch (provider) {
      case 'kakao':
        return SocialProvider.kakao;
      case 'naver':
        return SocialProvider.naver;
      case 'other':
        return SocialProvider.other;
      default:
        throw Exception('Unknown social provider: $provider');
    }
  }

  String toEnumString() {
    switch (this) {
      case SocialProvider.kakao:
        return "kakao";
      case SocialProvider.naver:
        return "naver";
      case SocialProvider.other:
        return "other";
      default:
        throw Exception('Unknown social provider: $this');
    }
  }
}
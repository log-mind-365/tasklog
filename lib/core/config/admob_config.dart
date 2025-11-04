/// AdMob 광고 ID 설정
///
/// 테스트 ID는 Google에서 제공하는 테스트용 광고 ID입니다.
/// 실제 배포 시에는 아래 ID를 실제 AdMob에서 발급받은 ID로 교체하세요.
class AdMobConfig {
  // AdMob 앱 ID
  // Android: AndroidManifest.xml에도 추가 필요
  // iOS: Info.plist에도 추가 필요
  static const String appId = 'ca-app-pub-3940256099942544~1458002511';

  // 배너 광고 ID
  static String get bannerAdUnitId {
    return 'ca-app-pub-3940256099942544/2435281174';
  }

  // 전면 광고 ID (필요시 사용)
  static String get interstitialAdUnitId {
    return 'ca-app-pub-3940256099942544/1033173712'; // 테스트 전면 광고 ID
  }

  // 보상형 광고 ID (필요시 사용)
  static String get rewardedAdUnitId {
    return 'ca-app-pub-3940256099942544/5224354917'; // 테스트 보상형 광고 ID
  }
}

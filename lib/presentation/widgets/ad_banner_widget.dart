import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/config/admob_config.dart';
import '../../core/constants/app_constants.dart';

/// 배너 광고 위젯
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isLoaded) {
      // 로딩 중일 때 스켈레톤 UI 표시
      return Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: AppConstants.alphaStrong,
          ),
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: AppConstants.borderWidthThin,
            ),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    // 광고 로드 완료 시 배너 광고 표시
    return Container(
      height: _bannerAd!.size.height.toDouble(),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: AppConstants.borderWidthThin,
          ),
        ),
      ),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

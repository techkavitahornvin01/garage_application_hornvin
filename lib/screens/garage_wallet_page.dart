import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hornvin/widgets/app_theme.dart.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class GarageWalletPage extends StatefulWidget {
  const GarageWalletPage({super.key});

  @override
  State<GarageWalletPage> createState() => _GarageWalletPageState();
}

class _GarageWalletPageState extends State<GarageWalletPage> {
  static final List<_StaticQrCoupon> _staticCoupons = [
    _StaticQrCoupon(
      code: 'HVN-QR-2026-1001',
      productName: 'Hornvin Engine Oil 10W30',
      batchNo: 'EO-10W30-B24',
      points: 20,
      status: _CouponMockStatus.valid,
    ),
    _StaticQrCoupon(
      code: 'HVN-QR-2026-1002',
      productName: 'Hornvin Brake Pad',
      batchNo: 'BP-4421',
      points: 35,
      status: _CouponMockStatus.valid,
    ),
    _StaticQrCoupon(
      code: 'HVN-QR-2026-OLD',
      productName: 'Hornvin Coolant',
      batchNo: 'CL-OLD-01',
      points: 15,
      status: _CouponMockStatus.expired,
    ),
    _StaticQrCoupon(
      code: 'HVN-QR-2026-USED',
      productName: 'Hornvin Air Filter',
      batchNo: 'AF-7781',
      points: 25,
      status: _CouponMockStatus.used,
    ),
  ];

  final List<_WalletScan> _scans = [
    _WalletScan(
      couponCode: 'HVN-QR-2026-0891',
      productName: 'Hornvin Engine Oil 20W40',
      batchNo: 'EO-20W40-B18',
      date: DateTime(2026, 6, 17),
      points: 20,
      eligibleDate: DateTime(2026, 7, 17),
      status: _WalletStatus.pendingApproval,
      redemptionStatus: 'Not eligible',
      adminRemark: 'Waiting for admin pre-approval',
    ),
    _WalletScan(
      couponCode: 'HVN-QR-2026-0730',
      productName: 'Hornvin Brake Pad',
      batchNo: 'BP-4408',
      date: DateTime(2026, 5, 12),
      points: 50,
      eligibleDate: DateTime(2026, 6, 11),
      status: _WalletStatus.approved,
      redemptionStatus: 'Ready',
      adminRemark: 'Approved by admin',
    ),
    _WalletScan(
      couponCode: 'HVN-QR-2026-0612',
      productName: 'Hornvin Air Filter',
      batchNo: 'AF-7602',
      date: DateTime(2026, 4, 2),
      points: 30,
      eligibleDate: DateTime(2026, 5, 2),
      status: _WalletStatus.redeemed,
      redemptionStatus: 'Paid',
      adminRemark: 'Redeemed in last payout',
    ),
    _WalletScan(
      couponCode: 'HVN-QR-2026-0517',
      productName: 'Hornvin Coolant',
      batchNo: 'CL-2201',
      date: DateTime(2026, 3, 22),
      points: 10,
      eligibleDate: DateTime(2026, 4, 21),
      status: _WalletStatus.rejected,
      redemptionStatus: 'Rejected',
      adminRemark: 'Coupon not mapped to this garage',
    ),
  ];

  bool _hasRequestedRedemption = false;
  String? _lastScanMessage;

  int get _pendingPoints => _sumByStatus(_WalletStatus.pendingApproval);
  int get _availablePoints => _sumByStatus(_WalletStatus.approved);
  int get _redeemedPoints => _sumByStatus(_WalletStatus.redeemed);
  int get _rejectedPoints => _sumByStatus(_WalletStatus.rejected);

  int _sumByStatus(_WalletStatus status) {
    return _scans
        .where((scan) => scan.status == status)
        .fold(0, (sum, scan) => sum + scan.points);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffold,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 114),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildPageHeader(),
          const SizedBox(height: 10),
          _buildHeroCard(),
          const SizedBox(height: 10),
          _buildScanActionCard(),
          const SizedBox(height: 10),
          _buildCompactPointsGrid(),
          const SizedBox(height: 10),
          _buildPreApprovalCard(),
          const SizedBox(height: 10),
          _buildRedeemCard(),
          const SizedBox(height: 12),
          _sectionTitle('QR Coupon History'),
          const SizedBox(height: 8),
          ..._scans.map(_buildScanTile),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      width: double.infinity,
      height: 46,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 21,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'QR Coupon Wallet',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'QR Coupon Wallet',
                  style: GoogleFonts.lato(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Scan coupon, send pre-approval, then redeem approved points',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '$_availablePoints pts',
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  'Approved for redemption',
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.74),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _openStaticQrScanner,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primary,
                size: 42,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanActionCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QR Coupon Scanner',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Camera se QR scan kare. API ke bina abhi demo points add honge',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _openStaticQrScanner,
                icon: const Icon(Icons.qr_code_scanner_rounded, size: 17),
                label: const Text('Scan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(84, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          if (_lastScanMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5EAF2)),
              ),
              child: Text(
                _lastScanMessage!,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  height: 1.35,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactPointsGrid() {
    final items = [
      _WalletStat(
        title: 'Pre-Approval',
        value: _pendingPoints,
        subtitle: 'Admin pending',
        icon: Icons.pending_actions_rounded,
        color: Colors.orange.shade700,
      ),
      _WalletStat(
        title: 'Approved',
        value: _availablePoints,
        subtitle: 'Can redeem',
        icon: Icons.account_balance_wallet_rounded,
        color: Colors.green.shade700,
      ),
      _WalletStat(
        title: 'Redeemed',
        value: _redeemedPoints,
        subtitle: 'Paid',
        icon: Icons.verified_rounded,
        color: AppColors.primary,
      ),
      _WalletStat(
        title: 'Rejected',
        value: _rejectedPoints,
        subtitle: 'Not valid',
        icon: Icons.cancel_rounded,
        color: Colors.red.shade700,
      ),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.75,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value.toString(),
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreApprovalCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-Approval Flow',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Scanned coupon pehle admin pending me jayega. Approval ke baad points redeem honge.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemCard() {
    final canRedeem = _availablePoints > 0 && !_hasRequestedRedemption;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.currency_rupee_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hasRequestedRedemption
                      ? 'Redemption request sent'
                      : 'Wallet Redemption Request',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  canRedeem
                      ? 'Approved points redeem ke liye apply kare'
                      : 'Admin approval ke baad request enable hogi',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: canRedeem ? _requestRedemption : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.lightGrey,
              disabledForegroundColor: AppColors.textSecondary,
              elevation: 0,
              minimumSize: const Size(72, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _hasRequestedRedemption ? 'Sent' : 'Apply',
              style: GoogleFonts.lato(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildScanTile(_WalletScan scan) {
    final statusColor = _statusColor(scan.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(Icons.qr_code_2_rounded, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        scan.couponCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _StatusPill(label: _statusLabel(scan.status), color: statusColor),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${scan.productName} | ${scan.points} points',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Batch: ${scan.batchNo} | Scan: ${_formatDate(scan.date)} | Eligible: ${_formatDate(scan.eligibleDate)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Admin: ${scan.adminRemark} | Redemption: ${scan.redemptionStatus}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openStaticQrScanner() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _QrCouponScannerPage()),
    );

    if (!mounted || scannedValue == null || scannedValue.trim().isEmpty) {
      return;
    }

    _handleStaticCouponScan(scannedValue);
  }

  void _handleStaticCouponScan(String rawQrValue) {
    final parsedCoupon = _parseQrCoupon(rawQrValue);
    final normalizedCode = parsedCoupon.code.trim().toUpperCase();
    if (normalizedCode.isEmpty) return;

    final now = DateTime.now();
    final existingScan = _scans.any(
      (scan) => scan.couponCode.toUpperCase() == normalizedCode,
    );
    final coupon = _staticCoupons
        .where((item) => item.code == normalizedCode)
        .cast<_StaticQrCoupon?>()
        .firstOrNull;

    if (existingScan || coupon?.status == _CouponMockStatus.used) {
      _addScanResult(
        _WalletScan(
          couponCode: normalizedCode,
          productName:
              coupon?.productName ?? parsedCoupon.productName ?? 'Unknown QR Coupon',
          batchNo: coupon?.batchNo ?? 'N/A',
          date: now,
          points: coupon?.points ?? parsedCoupon.points,
          eligibleDate: now,
          status: _WalletStatus.rejected,
          redemptionStatus: 'Rejected',
          adminRemark: 'Duplicate coupon scan detected',
        ),
        'Duplicate QR coupon. Request rejected.',
      );
      return;
    }

    final expiredCoupon = coupon;
    if (expiredCoupon != null &&
        expiredCoupon.status == _CouponMockStatus.expired) {
      _addScanResult(
        _WalletScan(
          couponCode: normalizedCode,
          productName: expiredCoupon.productName,
          batchNo: expiredCoupon.batchNo,
          date: now,
          points: expiredCoupon.points,
          eligibleDate: now,
          status: _WalletStatus.rejected,
          redemptionStatus: 'Rejected',
          adminRemark: 'Coupon expired before scan',
        ),
        'Expired QR coupon. Request rejected.',
      );
      return;
    }

    final points = coupon?.points ?? parsedCoupon.points;
    final productName =
        coupon?.productName ?? parsedCoupon.productName ?? 'Scanned QR Coupon';
    final batchNo = coupon?.batchNo ?? parsedCoupon.batchNo ?? 'QR-SCAN';

    _addScanResult(
      _WalletScan(
        couponCode: coupon?.code ?? normalizedCode,
        productName: productName,
        batchNo: batchNo,
        date: now,
        points: points,
        eligibleDate: now.add(const Duration(days: 30)),
        status: _WalletStatus.pendingApproval,
        redemptionStatus: 'Not eligible',
        adminRemark: 'Pre-approval request sent to admin',
      ),
      '${coupon?.code ?? normalizedCode} scanned successfully.\n'
      '$points points moved to pre-approval.\n'
      'Admin approval ke baad points wallet me available honge.',
    );
  }

  _ParsedQrCoupon _parseQrCoupon(String rawQrValue) {
    final raw = rawQrValue.trim();
    const defaultPoints = 20;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final code = _firstPayloadText(decoded, [
          'coupon_code',
          'couponCode',
          'code',
          'qr_code',
          'qrCode',
          'coupon',
        ]);
        final productName = _firstPayloadText(decoded, [
          'product_name',
          'productName',
          'product',
          'item',
        ]);
        final batchNo = _firstPayloadText(decoded, [
          'batch_no',
          'batchNo',
          'batch',
        ]);
        return _ParsedQrCoupon(
          code: code ?? raw,
          productName: productName,
          batchNo: batchNo,
          points: _firstPayloadInt(decoded, [
            'points',
            'point',
            'reward_points',
            'rewardPoints',
            'value',
          ]) ?? defaultPoints,
        );
      }
    } catch (_) {}

    final pointsMatch = RegExp(
      r'(?:points?|pts|reward)[\s:=\-]+(\d+)',
      caseSensitive: false,
    ).firstMatch(raw);
    final points = int.tryParse(pointsMatch?.group(1) ?? '') ?? defaultPoints;

    final codeMatch = RegExp(
      r'(?:code|coupon|qr)[\s:=\-]+([A-Za-z0-9_\-\/]+)',
      caseSensitive: false,
    ).firstMatch(raw);

    return _ParsedQrCoupon(
      code: codeMatch?.group(1) ?? raw,
      points: points,
    );
  }

  String? _firstPayloadText(Map<dynamic, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty && text != 'null') return text;
    }
    return null;
  }

  int? _firstPayloadInt(Map<dynamic, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is int) return value;
      final parsed = int.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return null;
  }

  void _addScanResult(_WalletScan scan, String message) {
    setState(() {
      _scans.insert(0, scan);
      _lastScanMessage = message;
      _hasRequestedRedemption = false;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_statusSnackText(scan.status)),
        behavior: SnackBarBehavior.floating,
      ),
    );

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            _statusDialogTitle(scan.status),
            style: GoogleFonts.lato(fontWeight: FontWeight.w900),
          ),
          content: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5EAF2)),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.35,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.lato(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }

  void _requestRedemption() {
    if (_availablePoints <= 0 || _hasRequestedRedemption) return;

    final requestedPoints = _availablePoints;
    setState(() {
      for (var index = 0; index < _scans.length; index++) {
        final scan = _scans[index];
        if (scan.status == _WalletStatus.approved) {
          _scans[index] = scan.copyWith(
            redemptionStatus: 'Request pending',
            adminRemark: 'Redemption request submitted',
          );
        }
      }
      _hasRequestedRedemption = true;
    });

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Redemption request submitted',
                        style: GoogleFonts.lato(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$requestedPoints approved points redemption ke liye admin ko request bhej di gayi hai.',
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.lato(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(_WalletStatus status) {
    switch (status) {
      case _WalletStatus.approved:
        return Colors.green.shade700;
      case _WalletStatus.redeemed:
        return AppColors.primary;
      case _WalletStatus.rejected:
        return Colors.red.shade700;
      case _WalletStatus.pendingApproval:
        return Colors.orange.shade700;
    }
  }

  String _statusLabel(_WalletStatus status) {
    switch (status) {
      case _WalletStatus.pendingApproval:
        return 'Pre-Approval';
      case _WalletStatus.approved:
        return 'Approved';
      case _WalletStatus.redeemed:
        return 'Redeemed';
      case _WalletStatus.rejected:
        return 'Rejected';
    }
  }

  String _statusSnackText(_WalletStatus status) {
    switch (status) {
      case _WalletStatus.pendingApproval:
        return 'QR scanned. Pre-approval request sent.';
      case _WalletStatus.rejected:
        return 'QR coupon rejected.';
      case _WalletStatus.approved:
        return 'QR coupon approved.';
      case _WalletStatus.redeemed:
        return 'QR coupon redeemed.';
    }
  }

  String _statusDialogTitle(_WalletStatus status) {
    switch (status) {
      case _WalletStatus.pendingApproval:
        return 'Pre-Approval Sent';
      case _WalletStatus.rejected:
        return 'QR Rejected';
      case _WalletStatus.approved:
        return 'QR Approved';
      case _WalletStatus.redeemed:
        return 'QR Redeemed';
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

enum _WalletStatus { pendingApproval, approved, redeemed, rejected }

enum _CouponMockStatus { valid, used, expired }

class _StaticQrCoupon {
  final String code;
  final String productName;
  final String batchNo;
  final int points;
  final _CouponMockStatus status;

  const _StaticQrCoupon({
    required this.code,
    required this.productName,
    required this.batchNo,
    required this.points,
    required this.status,
  });
}

class _WalletStat {
  final String title;
  final int value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _WalletStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class _WalletScan {
  final String couponCode;
  final String productName;
  final String batchNo;
  final DateTime date;
  final int points;
  final DateTime eligibleDate;
  final _WalletStatus status;
  final String redemptionStatus;
  final String adminRemark;

  const _WalletScan({
    required this.couponCode,
    required this.productName,
    required this.batchNo,
    required this.date,
    required this.points,
    required this.eligibleDate,
    required this.status,
    required this.redemptionStatus,
    required this.adminRemark,
  });

  _WalletScan copyWith({
    String? couponCode,
    String? productName,
    String? batchNo,
    DateTime? date,
    int? points,
    DateTime? eligibleDate,
    _WalletStatus? status,
    String? redemptionStatus,
    String? adminRemark,
  }) {
    return _WalletScan(
      couponCode: couponCode ?? this.couponCode,
      productName: productName ?? this.productName,
      batchNo: batchNo ?? this.batchNo,
      date: date ?? this.date,
      points: points ?? this.points,
      eligibleDate: eligibleDate ?? this.eligibleDate,
      status: status ?? this.status,
      redemptionStatus: redemptionStatus ?? this.redemptionStatus,
      adminRemark: adminRemark ?? this.adminRemark,
    );
  }
}

class _ParsedQrCoupon {
  final String code;
  final String? productName;
  final String? batchNo;
  final int points;

  const _ParsedQrCoupon({
    required this.code,
    this.productName,
    this.batchNo,
    required this.points,
  });
}

class _QrCouponScannerPage extends StatefulWidget {
  const _QrCouponScannerPage();

  @override
  State<_QrCouponScannerPage> createState() => _QrCouponScannerPageState();
}

class _QrCouponScannerPageState extends State<_QrCouponScannerPage> {
  late final MobileScannerController _controller;
  bool _isHandlingScan = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.black,
        elevation: 0,
        title: Text(
          'Scan QR Coupon',
          style: GoogleFonts.lato(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on_rounded),
            tooltip: 'Flash',
          ),
          IconButton(
            onPressed: () => _controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch_rounded),
            tooltip: 'Switch camera',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: _handleDetectedBarcode,
            errorBuilder: (context, error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Camera open nahi ho pa raha. Permission check kare ya Test Code use kare.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _QrScanFramePainter()),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 28,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    'QR ko frame ke andar rakhe. Scan hote hi points wallet pre-approval me add honge.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openTestCodeDialog,
                    icon: const Icon(Icons.keyboard_rounded),
                    label: const Text('Test Code'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDetectedBarcode(BarcodeCapture capture) {
    if (_isHandlingScan) return;

    final rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .firstOrNull;

    if (rawValue == null) return;

    _isHandlingScan = true;
    Navigator.pop(context, rawValue);
  }

  Future<void> _openTestCodeDialog() async {
    final controller = TextEditingController(text: 'HVN-QR-2026-1001');
    final code = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Test QR Code',
            style: GoogleFonts.lato(fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              hintText: 'HVN-QR-2026-1001',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Use'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (!mounted || code == null || code.trim().isEmpty) return;
    Navigator.pop(context, code.trim());
  }
}

class _QrScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.48)
      ..style = PaintingStyle.fill;
    final frameSize = (size.width * 0.72).clamp(220.0, 310.0);
    final frameRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.42),
      width: frameSize,
      height: frameSize,
    );
    final fullPath = Path()..addRect(Offset.zero & size);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(frameRect, const Radius.circular(22)),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, fullPath, cutoutPath),
      overlayPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(
      RRect.fromRectAndRadius(frameRect, const Radius.circular(22)),
      borderPaint,
    );

    final cornerPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    const cornerLength = 34.0;
    final corners = [
      (frameRect.topLeft, 1, 1),
      (frameRect.topRight, -1, 1),
      (frameRect.bottomLeft, 1, -1),
      (frameRect.bottomRight, -1, -1),
    ];
    for (final corner in corners) {
      final point = corner.$1;
      final horizontalDirection = corner.$2;
      final verticalDirection = corner.$3;
      canvas.drawLine(
        point,
        point + Offset(cornerLength * horizontalDirection, 0),
        cornerPaint,
      );
      canvas.drawLine(
        point,
        point + Offset(0, cornerLength * verticalDirection),
        cornerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

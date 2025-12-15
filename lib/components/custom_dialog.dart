import 'package:flutter/material.dart';
import 'package:scan_qr_member/screens/scanner_screen.dart';

class CustomDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String? description;
  final bool isFormatted;

  final String? productName;
  final String? serialNumber;
  final String? formattedPackagingDate;
  final String? formattedActivePeriod;
  final String? textScan;

  final VoidCallback onOk;
  final VoidCallback onCancel;

  const CustomDialog({
    super.key,
    required this.type,
    required this.title,
    this.description,
    required this.isFormatted,
    this.productName,
    this.serialNumber,
    this.formattedPackagingDate,
    this.formattedActivePeriod,
    this.textScan,
    required this.onOk,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = type == DialogType.success
        ? const Color(0xFF00C853)
        : const Color(0xFFFF5252);
    final IconData mainIcon = type == DialogType.success
        ? Icons.check
        : Icons.close_rounded;

    const double dialogRadius = 25.0;
    const double iconSize = 80.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dialogRadius),
      ),
      backgroundColor: Colors.white,
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', fit: BoxFit.contain),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: isFormatted
                      ? _buildFormattedContent()
                      : _buildGenericContent(),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5252),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Color(0xFFFF5252),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: onOk,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00C853),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 28,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Color(0xFF00C853),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: -iconSize / 2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: iconSize + 16,
                height: iconSize + 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: iconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(mainIcon, size: 55, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close, color: Colors.black54, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoText('Nama Produk: $productName'),
        const SizedBox(height: 4),
        _buildInfoText('Nomor Seri: $serialNumber'),
        const SizedBox(height: 4),
        _buildInfoText('Tanggal Pengemasan: $formattedPackagingDate'),
        const SizedBox(height: 4),
        _buildInfoText('Masa Berlaku: $formattedActivePeriod'),
        const SizedBox(height: 20),
        _buildInfoText('Scan: $textScan', fontWeight: FontWeight.w600),
      ],
    );
  }

  Widget _buildInfoText(
    String text, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: fontWeight,
        height: 1.5,
      ),
    );
  }

  Widget _buildGenericContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          textAlign: TextAlign.center,
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          textAlign: TextAlign.center,
          description ?? 'Terjadi kesalahan tidak diketahui.',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

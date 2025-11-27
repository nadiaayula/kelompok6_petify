import 'package:flutter/material.dart';

class RewardStatusDialog extends StatelessWidget {
  final bool isSuccess;

  const RewardStatusDialog({
    Key? key,
    required this.isSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cat illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: isSuccess ? Colors.yellow[50] : Colors.pink[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Image.asset(
                  isSuccess ? 'assets/cat_success.png' : 'assets/cat_failed.png',
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      isSuccess ? Icons.check_circle : Icons.error,
                      size: 100,
                      color: isSuccess ? Colors.green : Colors.red,
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: isSuccess ? 'Yeiy!' : 'Yah!',
                    style: const TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                  const TextSpan(
                    text: ', Penukaran\nrewardmu ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: isSuccess ? 'berhasil' : 'belum berhasil',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              isSuccess 
                ? 'Reward sudah berhasil ditukarkan. Kamu bisa cek detailnya di halaman riwayat reward. Terima kasih sudah berpartisipasi!'
                : 'Terjadi kendala saat menukarkan rewardmu. Coba ulangi beberapa saat lagi atau pastikan koneksi kamu stabil, ya.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Close dialog and go back to rewards page
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Back to rewards page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Static method untuk memudahkan pemanggilan
  static void show(BuildContext context, {required bool isSuccess}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RewardStatusDialog(isSuccess: isSuccess),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isLocationError;

  const ErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.isLocationError = false,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final accentColor = isLocationError
        ? const Color(0xFFf5a623) // warm amber for location
        : const Color(0xFFe05c5c); // muted red for errors

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, topPad, 24, 40),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon circle
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withOpacity(0.12),
                    border: Border.all(
                      color: accentColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    isLocationError
                        ? Icons.location_off_rounded
                        : Icons.cloud_off_rounded,
                    color: accentColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isLocationError ? 'Location needed' : 'Something went wrong',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.55),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Location settings button
                if (isLocationError) ...[
                  _buildButton(
                    label: 'Open settings',
                    icon: Icons.settings_rounded,
                    color: accentColor,
                    onTap: () async {
                      try {
                        await Geolocator.openLocationSettings();
                      } catch (_) {}
                    },
                  ),
                  const SizedBox(height: 10),
                ],

                // Retry button
                _buildButton(
                  label: 'Try again',
                  icon: Icons.refresh_rounded,
                  color: Colors.white,
                  onTap: onRetry,
                  outlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool outlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withOpacity(outlined ? 0.4 : 0.25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
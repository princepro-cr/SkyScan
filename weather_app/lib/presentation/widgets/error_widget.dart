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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLocationError ? Icons.location_off : Icons.error_outline,
              color: isLocationError ? Colors.orange : Colors.red,
              size: 64,
            ),
            const SizedBox(height: 20),
            Text(
              isLocationError ? 'Location Required' : 'Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isLocationError ? Colors.orange : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            
            if (isLocationError) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await Geolocator.openLocationSettings();
                  } catch (e) {
                    // Ignore
                  }
                },
                icon: const Icon(Icons.settings),
                label: const Text('Open Location Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
            ],
            
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
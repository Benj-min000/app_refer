import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rider_provider.dart';
import '../widgets/job_request_sheet.dart';
import '../utils/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RiderProvider>();
    final pendingJob = provider.pendingJob;

    // Automatyczne pokazywanie zlecenia, gdy się pojawi
    if (pendingJob != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showJobRequest(context, provider);
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(provider.isOnline ? 'Jesteś Online' : 'Jesteś Offline'),
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: provider.isOnline,
              onChanged: (_) => provider.toggleOnline(),
              activeColor: AppTheme.accent,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Tło (Mapa / Placeholder)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.background,
            child: Center(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  provider.isOnline ? Icons.map_rounded : Icons.map_outlined,
                  size: 120,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),

          // Status bar / Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _StatusCard(provider: provider),
                ],
              ),
            ),
          ),

          // Przycisk powrotu do aktywnego zamówienia
          if (provider.appState == RiderAppState.onJob)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigator.push do ekranu aktywnej dostawy
                },
                icon: const Icon(Icons.directions_bike_rounded),
                label: const Text('Wróć do aktywnej dostawy'),
              ),
            ),
        ],
      ),
    );
  }

  void _showJobRequest(BuildContext context, RiderProvider provider) {
    final job = provider.pendingJob;
    if (job == null) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) => JobRequestSheet(
        job: job,
        onAccept: () async {
          Navigator.pop(ctx);
          await provider.acceptJob(job.id);
        },
        onReject: () async {
          Navigator.pop(ctx);
          await provider.rejectJob(job.id);
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final RiderProvider provider;
  const _StatusCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: provider.isOnline ? AppTheme.accent : AppTheme.danger,
                boxShadow: [
                  if (provider.isOnline)
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.isOnline ? 'Szukam zleceń...' : 'Jesteś poza zasięgiem',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    provider.isOnline 
                      ? 'Pozostań w tej okolicy, aby otrzymywać oferty' 
                      : 'Przełącz status na online, aby zarabiać',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
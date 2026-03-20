// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/rider_provider.dart';
// import '../utils/app_theme.dart';
// import '../widgets/common_widgets.dart';
// import '../widgets/job_request_sheet.dart';
// import '../widgets/earnings_widget.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       body: Consumer<RiderProvider>(
//         builder: (context, provider, _) {
//           // Show job request if pending
//           if (provider.pendingJob != null) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               _showJobRequest(context, provider);
//             });
//           }

//           return CustomScrollView(
//             slivers: [
//               _buildAppBar(context, provider),
//               SliverPadding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate([
//                     const SizedBox(height: 8),
//                     _StatusToggle(provider: provider),
//                     const SizedBox(height: 24),
//                     _EarningsCard(provider: provider),
//                     const SizedBox(height: 24),
//                     _StatsRow(provider: provider),
//                     const SizedBox(height: 24),
//                     _RecentActivity(),
//                   ]),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   SliverAppBar _buildAppBar(BuildContext context, RiderProvider provider) {
//     return SliverAppBar(
//       expandedHeight: 0,
//       floating: true,
//       backgroundColor: AppTheme.surface,
//       title: Row(
//         children: [
//           Container(
//             width: 36,
//             height: 36,
//             decoration: BoxDecoration(
//               color: AppTheme.primary.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Icon(Icons.delivery_dining,
//                 color: AppTheme.primary, size: 20),
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 provider.rider?.name ?? 'Rider',
//                 style: const TextStyle(
//                   color: AppTheme.textPrimary,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     width: 7,
//                     height: 7,
//                     decoration: BoxDecoration(
//                       color: provider.isOnline
//                           ? AppTheme.primary
//                           : AppTheme.textSecondary,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     provider.isOnline ? 'Online' : 'Offline',
//                     style: TextStyle(
//                       color: provider.isOnline
//                           ? AppTheme.primary
//                           : AppTheme.textSecondary,
//                       fontSize: 11,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.person_outline, color: AppTheme.textPrimary),
//           onPressed: () => Navigator.pushNamed(context, '/profile'),
//         ),
//       ],
//     );
//   }

//   void _showJobRequest(BuildContext context, RiderProvider provider) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       isDismissible: false,
//       enableDrag: false,
//       backgroundColor: Colors.transparent,
//       builder: (_) => JobRequestSheet(
//         job: provider.pendingJob!,
//         onAccept: () {
//           Navigator.pop(context);
//           provider.acceptJob(provider.pendingJob!['id']);
//         },
//         onReject: () {
//           Navigator.pop(context);
//           provider.rejectJob(provider.pendingJob!['id']);
//         },
//       ),
//     );
//   }
// }

// class _StatusToggle extends StatelessWidget {
//   final RiderProvider provider;
//   const _StatusToggle({required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: provider.isOnline
//             ? AppTheme.primary.withOpacity(0.1)
//             : AppTheme.cardBg,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: provider.isOnline
//               ? AppTheme.primary.withOpacity(0.3)
//               : AppTheme.divider,
//         ),
//       ),
//       child: Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 provider.isOnline ? 'You\'re Online' : 'You\'re Offline',
//                 style: TextStyle(
//                   color: provider.isOnline
//                       ? AppTheme.primary
//                       : AppTheme.textPrimary,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 provider.isOnline
//                     ? 'Ready to receive orders'
//                     : 'Go online to receive orders',
//                 style: const TextStyle(
//                     color: AppTheme.textSecondary, fontSize: 13),
//               ),
//             ],
//           ),
//           const Spacer(),
//           Transform.scale(
//             scale: 1.2,
//             child: Switch.adaptive(
//               value: provider.isOnline,
//               onChanged: provider.isLoading ? null : (_) => provider.toggleOnline(),
//               activeColor: AppTheme.primary,
//               trackColor: MaterialStateProperty.resolveWith((states) {
//                 if (states.contains(MaterialState.selected)) {
//                   return AppTheme.primary.withOpacity(0.3);
//                 }
//                 return AppTheme.surfaceLight;
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _EarningsCard extends StatelessWidget {
//   final RiderProvider provider;
//   const _EarningsCard({required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppTheme.primary.withOpacity(0.2),
//             AppTheme.primary.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Today's Earnings",
//               style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'zł 0.00',
//                 style: const TextStyle(
//                   color: AppTheme.textPrimary,
//                   fontSize: 32,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const Spacer(),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     '${provider.rider?.totalDeliveries ?? 0}',
//                     style: const TextStyle(
//                       color: AppTheme.primary,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   const Text('total deliveries',
//                       style: TextStyle(
//                           color: AppTheme.textSecondary, fontSize: 11)),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatsRow extends StatelessWidget {
//   final RiderProvider provider;
//   const _StatsRow({required this.provider});

//   @override
//   Widget build(BuildContext context) {
//     final rating = provider.rider?.rating ?? 5.0;
//     return Row(
//       children: [
//         _StatCard(
//           label: 'Rating',
//           value: '${rating.toStringAsFixed(1)} ★',
//           color: AppTheme.warning,
//         ),
//         const SizedBox(width: 12),
//         _StatCard(
//           label: 'Vehicle',
//           value: _vehicleLabel(provider.rider?.vehicleType ?? 'SCOOTER'),
//           color: AppTheme.info,
//         ),
//         const SizedBox(width: 12),
//         _StatCard(
//           label: 'Status',
//           value: provider.isOnline ? 'Active' : 'Idle',
//           color:
//               provider.isOnline ? AppTheme.primary : AppTheme.textSecondary,
//         ),
//       ],
//     );
//   }

//   String _vehicleLabel(String type) {
//     switch (type) {
//       case 'BIKE':
//         return '🚲 Bike';
//       case 'SCOOTER':
//         return '🛵 Scooter';
//       case 'CAR':
//         return '🚗 Car';
//       default:
//         return type;
//     }
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;
//   const _StatCard(
//       {required this.label, required this.value, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//         decoration: BoxDecoration(
//           color: AppTheme.cardBg,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           children: [
//             Text(value,
//                 style: TextStyle(
//                     color: color,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700)),
//             const SizedBox(height: 4),
//             Text(label,
//                 style: const TextStyle(
//                     color: AppTheme.textSecondary, fontSize: 11)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _RecentActivity extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Recent Activity',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               fontSize: 16,
//             )),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: AppTheme.cardBg,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: const Center(
//             child: Column(
//               children: [
//                 Icon(Icons.history, color: AppTheme.textSecondary, size: 36),
//                 SizedBox(height: 8),
//                 Text('No recent deliveries',
//                     style: TextStyle(
//                         color: AppTheme.textSecondary, fontSize: 14)),
//                 SizedBox(height: 4),
//                 Text('Go online to start receiving jobs',
//                     style: TextStyle(
//                         color: AppTheme.textSecondary, fontSize: 12)),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 80),
//       ],
//     );
//   }
// }

// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/rider_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/job_request_sheet.dart';
// Removed the broken earnings_widget import, since _EarningsCard is at the bottom of this file!

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<RiderProvider>(
        builder: (context, provider, _) {
          // Show job request if pending
          if (provider.pendingJob != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showJobRequest(context, provider);
            });
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, provider),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    _StatusToggle(provider: provider),
                    const SizedBox(height: 24),
                    _EarningsCard(provider: provider),
                    const SizedBox(height: 24),
                    _StatsRow(provider: provider),
                    const SizedBox(height: 24),
                    _RecentActivity(),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, RiderProvider provider) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      backgroundColor: AppTheme.surface,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delivery_dining,
                color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.rider?.name ?? 'Rider',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: provider.isOnline
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: provider.isOnline
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }

  // void _showJobRequest(BuildContext context, RiderProvider provider) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     enableDrag: false,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       // Safely map the DispatchJob object to a Dictionary/Map to satisfy the JobRequestSheet
  //       Map<String, dynamic> jobData;
  //       try {
  //         jobData = (provider.pendingJob as dynamic).toMap();
  //       } catch (_) {
  //         jobData = {'id': provider.pendingJob!.id};
  //       }

  //       return JobRequestSheet(
  //         job: DispatchJob.fromJson(jobData),
  //         onAccept: () {
  //           Navigator.pop(context);
  //           provider
  //               .acceptJob(provider.pendingJob!.id); // Fixed syntax error here
  //         },
  //         onReject: () {
  //           Navigator.pop(context);
  //           provider
  //               .rejectJob(provider.pendingJob!.id); // Fixed syntax error here
  //         },
  //       );
  //     },
  //   );
  // }

  void _showJobRequest(BuildContext context, RiderProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => JobRequestSheet(
        job: provider.pendingJob!,
        onAccept: () {
          Navigator.pop(context);
          provider.acceptJob(provider.pendingJob!.id);
        },
        onReject: () {
          Navigator.pop(context);
          provider.rejectJob(provider.pendingJob!.id);
        },
      ),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  final RiderProvider provider;
  const _StatusToggle({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: provider.isOnline
            ? AppTheme.primary.withOpacity(0.1)
            : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: provider.isOnline
              ? AppTheme.primary.withOpacity(0.3)
              : AppTheme.divider,
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.isOnline ? 'You\'re Online' : 'You\'re Offline',
                style: TextStyle(
                  color: provider.isOnline
                      ? AppTheme.primary
                      : AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                provider.isOnline
                    ? 'Ready to receive orders'
                    : 'Go online to receive orders',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Transform.scale(
            scale: 1.2,
            child: Switch.adaptive(
              value: provider.isOnline,
              onChanged:
                  provider.isLoading ? null : (_) => provider.toggleOnline(),
              activeColor: AppTheme.primary,
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppTheme.primary.withOpacity(0.3);
                }
                return AppTheme.surfaceLight;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final RiderProvider provider;
  const _EarningsCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withOpacity(0.2),
            AppTheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Earnings",
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'zł 0.00',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${provider.rider?.totalDeliveries ?? 0}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('total deliveries',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final RiderProvider provider;
  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    final rating = provider.rider?.rating ?? 5.0;
    return Row(
      children: [
        _StatCard(
          label: 'Rating',
          value: '${rating.toStringAsFixed(1)} ★',
          color: AppTheme.warning,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: 'Vehicle',
          value: _vehicleLabel(provider.rider?.vehicleType ?? 'SCOOTER'),
          color: AppTheme.info,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: 'Status',
          value: provider.isOnline ? 'Active' : 'Idle',
          color: provider.isOnline ? AppTheme.primary : AppTheme.textSecondary,
        ),
      ],
    );
  }

  String _vehicleLabel(String type) {
    switch (type) {
      case 'BIKE':
        return '🚲 Bike';
      case 'SCOOTER':
        return '🛵 Scooter';
      case 'CAR':
        return '🚗 Car';
      default:
        return type;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                )),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Column(
              children: [
                Icon(Icons.history, color: AppTheme.textSecondary, size: 36),
                SizedBox(height: 8),
                Text('No recent deliveries',
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                SizedBox(height: 4),
                Text('Go online to start receiving jobs',
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

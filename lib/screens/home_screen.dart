import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rider_provider.dart';
import '../widgets/job_request_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isShowingJob = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<RiderProvider>().addListener(_listener);
  }

  void _listener() {
    final provider = context.read<RiderProvider>();
    final job = provider.pendingJob;

    if (job != null && !_isShowingJob) {
      _isShowingJob = true;

      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (_) => JobRequestSheet(
          job: job,
          onAccept: () async {
            await provider.acceptJob(job.id);
            Navigator.pop(context);
            _isShowingJob = false;
          },
          onReject: () async {
            await provider.rejectJob(job.id);
            Navigator.pop(context);
            _isShowingJob = false;
          },
        ),
      ).whenComplete(() {
        _isShowingJob = false;
      });
    }
  }

  @override
  void dispose() {
    context.read<RiderProvider>().removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(),
    );
  }
}
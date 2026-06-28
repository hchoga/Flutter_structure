import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:touch/core/services/connectivity_service.dart';

/// Widget that displays an overlay notification when connectivity changes
/// Shows at the top of the screen when user goes offline or comes back online
class ConnectivityOverlay extends StatefulWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final ConnectivityService _connectivityService = ConnectivityService();
  List<ConnectivityResult>? _previousResult;
  bool _isShowingOverlay = false;
  bool _isFirstCheck = true;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeConnectivity();
    _listenToConnectivityChanges();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  Future<void> _initializeConnectivity() async {
    final result = await _connectivityService.checkConnectivity();
    _previousResult = result;
  }

  void _listenToConnectivityChanges() {
    _connectivityService.connectivityStream.listen((results) {
      // Skip showing overlay on first check
      if (_isFirstCheck) {
        _isFirstCheck = false;
        _previousResult = results;
        return;
      }

      // Only show overlay when connectivity status changes
      if (results != _previousResult) {
        _previousResult = results;
        _showConnectivityOverlay(results);
      }
    });
  }

  void _showConnectivityOverlay(List<ConnectivityResult> results) {
    if (_isShowingOverlay) return;

    setState(() {
      _isShowingOverlay = true;
    });
    _animationController.forward();

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _isShowingOverlay = false;
            });
          }
        });
      }
    });
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isShowingOverlay)
          SlideTransition(
            position: _slideAnimation,
            child: FutureBuilder<List<ConnectivityResult>>(
              future: _connectivityService.checkConnectivity(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();

                final results = snapshot.data!;
                final isOnline = _isOnline(results);

                return _ConnectivityOverlayBar(
                  isOnline: isOnline,
                  message: _connectivityService.getStatusMessage(results),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// The actual overlay bar that displays the connectivity status
class _ConnectivityOverlayBar extends StatelessWidget {
  final bool isOnline;
  final String message;

  const _ConnectivityOverlayBar({
    required this.isOnline,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green.shade600 : Colors.red.shade600,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

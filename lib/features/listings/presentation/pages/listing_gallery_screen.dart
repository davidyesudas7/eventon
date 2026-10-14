import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/listing_detail_model.dart';

class ListingGalleryScreen extends StatefulWidget {
  final List<MediaAssetModel> items;
  final int initialIndex;
  final String? title;

  const ListingGalleryScreen({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.title,
  });

  @override
  State<ListingGalleryScreen> createState() => _ListingGalleryScreenState();
}

class _ListingGalleryScreenState extends State<ListingGalleryScreen> {
  late final PageController _pageController;
  late final ScrollController _thumbnailScrollController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.items.isEmpty ? 0 : widget.items.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
    _thumbnailScrollController = ScrollController();

    // Scroll to active thumbnail after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToThumbnail(_currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbnailScrollController.dispose();
    super.dispose();
  }

  void _scrollToThumbnail(int index) {
    if (!_thumbnailScrollController.hasClients) return;
    const itemWidth = 60.0 + 8.0; // width + margin
    final targetOffset = (index * itemWidth) - (MediaQuery.of(context).size.width / 2) + (itemWidth / 2);
    _thumbnailScrollController.animateTo(
      targetOffset.clamp(0.0, _thumbnailScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _scrollToThumbnail(index);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
        ),
        body: const Center(
          child: Text('No media available', style: TextStyle(color: Colors.white70)),
        ),
      );
    }

    final currentItem = widget.items[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            // Media ViewPager
            GestureDetector(
              onTap: _toggleControls,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.items.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isCurrent = index == _currentIndex;
                  if (item.isVideo) {
                    return _GalleryVideoItem(
                      item: item,
                      isCurrentPage: isCurrent,
                    );
                  } else {
                    return _GalleryImageItem(item: item);
                  }
                },
              ),
            ),

            // Top App Bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: _showControls ? 0 : -100,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  right: 16,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.title != null && widget.title!.isNotEmpty)
                            Text(
                              widget.title!,
                              style: AppTextStyles.labelMd.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            '${_currentIndex + 1} of ${widget.items.length}',
                            style: AppTextStyles.labelSm.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Caption & Thumbnails
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              bottom: _showControls ? 0 : -160,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                  top: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Caption
                    if (currentItem.caption != null && currentItem.caption!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          currentItem.caption!,
                          style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],

                    // Thumbnails Strip
                    if (widget.items.length > 1) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: ListView.separated(
                          controller: _thumbnailScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: widget.items.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final isSelected = index == _currentIndex;
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.white24,
                                  width: isSelected ? 2.5 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (item.thumbnailUrl != null)
                                      Image.network(
                                        item.thumbnailUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey[850],
                                          child: const Icon(Icons.image_not_supported, color: Colors.white38, size: 20),
                                        ),
                                      )
                                    else if (item.isVideo)
                                      Container(
                                        color: AppColors.dividerDark,
                                        child: const Center(
                                          child: Icon(Icons.videocam_rounded, color: Colors.white70, size: 20),
                                        ),
                                      )
                                    else
                                      Image.network(
                                        item.url,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: Colors.grey[850],
                                          child: const Icon(Icons.image_not_supported, color: Colors.white38, size: 20),
                                        ),
                                      ),
                                    if (item.isVideo)
                                      Container(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryImageItem extends StatelessWidget {
  final MediaAssetModel item;

  const _GalleryImageItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 4.0,
      child: Center(
        child: Image.network(
          item.url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined, color: Colors.white54, size: 48),
                SizedBox(height: 8),
                Text('Could not load image', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryVideoItem extends StatefulWidget {
  final MediaAssetModel item;
  final bool isCurrentPage;

  const _GalleryVideoItem({
    required this.item,
    required this.isCurrentPage,
  });

  @override
  State<_GalleryVideoItem> createState() => _GalleryVideoItemState();
}

class _GalleryVideoItemState extends State<_GalleryVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(fn);
      }
    });
  }

  void _initVideo() {
    runZonedGuarded(() async {
      try {
        final uri = Uri.parse(widget.item.url);
        final controller = VideoPlayerController.networkUrl(uri);
        _controller = controller;

        controller.addListener(_onControllerUpdate);
        await controller.initialize();
        await controller.setLooping(true);

        _safeSetState(() {
          _isInitialized = true;
        });
        if (widget.isCurrentPage) {
          controller.play();
        }
      } catch (_) {
        _safeSetState(() {
          _hasError = true;
        });
      }
    }, (error, stackTrace) {
      _safeSetState(() {
        _hasError = true;
      });
    });
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    if (_controller?.value.hasError ?? false) {
      if (!_hasError) {
        _safeSetState(() {
          _hasError = true;
        });
      }
    } else {
      _safeSetState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant _GalleryVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isCurrentPage && _controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.item.thumbnailUrl != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.45,
                  child: Image.network(
                    widget.item.thumbnailUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.videocam_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Video',
                          style: AppTextStyles.labelMd.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Video playback unavailable in this preview',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _isInitialized = false;
                      });
                      _initVideo();
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Try Again', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized || _controller == null || !_controller!.value.isInitialized) {
      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.item.thumbnailUrl != null)
              Image.network(
                widget.item.thumbnailUrl!,
                fit: BoxFit.contain,
              ),
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      );
    }

    final isPlaying = _controller!.value.isPlaying;
    final rawRatio = _controller!.value.aspectRatio;
    final aspectRatio = (rawRatio > 0) ? rawRatio : (16 / 9);

    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),

            // Big Center Play/Pause button
            GestureDetector(
              onTap: _togglePlayPause,
              child: AnimatedOpacity(
                opacity: isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

            // Video scrubber bar at bottom of the video
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller!,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                colors: const VideoProgressColors(
                  playedColor: AppColors.primary,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

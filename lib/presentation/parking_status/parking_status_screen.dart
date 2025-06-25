import 'package:ai_parking/presentation/community/community_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_parking/data/data_source/parking_status_api.dart';
import 'package:ai_parking/data/model/parking_status_response.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:async';

class ParkingStatusScreen extends StatefulWidget {
  final String dong;
  final int available;
  final int total;
  final String buildingId;

  const ParkingStatusScreen({
    super.key,
    required this.dong,
    required this.available,
    required this.total,
    required this.buildingId,
  });

  @override
  State<ParkingStatusScreen> createState() => _ParkingStatusScreenState();
}

class _ParkingStatusScreenState extends State<ParkingStatusScreen> {
  late Future<ParkingStatusResponse> _future;
  final ParkingStatusApi api = ParkingStatusApi();

  @override
  void initState() {
    super.initState();
    _future = api.fetchParkingStatus(widget.buildingId);
  }

  void _refresh() {
    setState(() {
      _future = api.fetchParkingStatus(widget.buildingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF454545)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.dong,
          style: GoogleFonts.inter(
            color: const Color(0xFF454545),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF454545),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommunityScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<ParkingStatusResponse>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('주차 상태 정보를 불러올 수 없습니다.'));
                  }
                  final data = snapshot.data;
                  final current = data?.currentStatus;
                  final predict = data?.prediction30min;

                  // API에서 받아온 값이 있으면 그 값으로만 계산
                  final int availableSpaces =
                      current?.availableSpaces ?? widget.available;
                  final int totalSpaces = current?.totalSpaces ?? widget.total;
                  final double progress = totalSpaces > 0
                      ? availableSpaces / totalSpaces
                      : 0.0;
                  final String percentage = (progress * 100).toStringAsFixed(0);

                  // 30분 후 예측 데이터가 없거나 값이 0이면 기본값 사용
                  final bool hasPrediction =
                      predict != null &&
                      (predict.predictedAvailable + predict.predictedOccupied) >
                          0;
                  final int predictedAvailable = hasPrediction
                      ? predict.predictedAvailable
                      : 0;
                  final int predictedTotal = hasPrediction
                      ? (predict.predictedAvailable + predict.predictedOccupied)
                      : 0;
                  final double predictedProgress = predictedTotal > 0
                      ? predictedAvailable / predictedTotal
                      : 0.0;
                  final String predictedPercent = (predictedProgress * 100)
                      .toStringAsFixed(0);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재 주차 상태',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF454545),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '남은 공간 $availableSpaces / 총 $totalSpaces ($percentage%)',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF454545),
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFF5F5F5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF0066CC),
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '현재 주차 상태',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF454545),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ParkingImageWithBoxes(
                          imageUrl: current?.imageUrl,
                          boxes: current?.spaceDetails,
                          isPrediction: false,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '30분 후 예측',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF454545),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '남은 공간 $predictedAvailable / 총 $predictedTotal ($predictedPercent%)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: predictedProgress,
                          backgroundColor: const Color(0xFFF5F5F5),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF0066CC),
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 8),
                        _ParkingImageWithBoxes(
                          imageUrl: hasPrediction ? current?.imageUrl : null,
                          boxes: hasPrediction
                              ? predict.spacePredictions
                              : null,
                          isPrediction: true,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  '새로고침',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParkingImageWithBoxes extends StatefulWidget {
  final String? imageUrl;
  final dynamic boxes;
  final bool isPrediction;
  const _ParkingImageWithBoxes({
    this.imageUrl,
    this.boxes,
    this.isPrediction = false,
  });

  @override
  State<_ParkingImageWithBoxes> createState() => _ParkingImageWithBoxesState();
}

class _ParkingImageWithBoxesState extends State<_ParkingImageWithBoxes> {
  ui.Image? _image;
  bool _loading = false;

  @override
  void didUpdateWidget(covariant _ParkingImageWithBoxes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _image = null;
      _loadImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) return;
    setState(() {
      _loading = true;
    });
    final completer = Completer<ui.Image>();
    final networkImage = NetworkImage(widget.imageUrl!);
    final stream = networkImage.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    final img = await completer.future;
    if (mounted) {
      setState(() {
        _image = img;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> boxList = widget.boxes is List ? widget.boxes : [];
    if (_loading) {
      return _placeholder();
    }
    if (_image == null) {
      return _placeholder();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final imageRatio = _image!.height.toDouble() / _image!.width.toDouble();
    final displayWidth = screenWidth;
    final displayHeight = displayWidth * imageRatio;

    // 1. 원본 크기로 CustomPaint 생성
    final paintedImage = CustomPaint(
      size: Size(_image!.width.toDouble(), _image!.height.toDouble()),
      painter: _ParkingImageWithBoxesPainter(
        _image!,
        boxList,
        widget.isPrediction,
      ),
    );

    // 2. FittedBox로 화면 width에 맞게 축소/확대
    return Center(
      child: SizedBox(
        width: displayWidth,
        height: displayHeight,
        child: FittedBox(fit: BoxFit.fill, child: paintedImage),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.image, color: Colors.grey, size: 60),
      ),
    );
  }
}

class _ParkingImageWithBoxesPainter extends CustomPainter {
  final ui.Image image;
  final List<dynamic> boxes;
  final bool isPrediction;
  _ParkingImageWithBoxesPainter(this.image, this.boxes, this.isPrediction);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 이미지 그리기 (원본 크기 그대로)
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      ),
      image: image,
      fit: BoxFit.fill,
    );

    // 2. 박스 그리기
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    for (final b in boxes) {
      final bbox = b['bbox'];
      if (bbox is List && bbox.length == 4) {
        if (isPrediction ? b['predicted_state'] == 1 : b['state'] == 1) {
          final rect = Rect.fromLTWH(
            bbox[0].toDouble(),
            bbox[1].toDouble(),
            (bbox[2] - bbox[0]).toDouble(),
            (bbox[3] - bbox[1]).toDouble(),
          );
          canvas.drawRect(rect, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

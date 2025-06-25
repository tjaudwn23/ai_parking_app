import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_parking/data/model/building.dart';
import 'package:ai_parking/data/data_source/building_api.dart';
import 'package:ai_parking/data/data_source/board_api.dart';
import 'package:provider/provider.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  List<Building> _buildings = [];
  Building? _selectedBuilding;
  bool _isLoading = true;
  String? _errorMessage;
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {});
    });
    _fetchBuildings();
  }

  Future<void> _fetchBuildings() async {
    try {
      final buildings = await BuildingApi().fetchAllBuildings();
      setState(() {
        _buildings = buildings;
        if (_buildings.isNotEmpty) {
          _selectedBuilding ??= _buildings.first;
        }
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '동 목록을 불러오지 못했습니다. 네트워크를 확인하거나 다시 시도해 주세요.';
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF454545)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '글쓰기',
          style: GoogleFonts.inter(
            color: const Color(0xFF454545),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Column(
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      _fetchBuildings();
                    },
                    child: const Text('다시 시도'),
                  ),
                ],
              )
            else
              DropdownButtonFormField<Building>(
                value: _selectedBuilding,
                items: _buildings
                    .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                    .toList(),
                onChanged: (b) {
                  setState(() {
                    _selectedBuilding = b;
                  });
                },
                decoration: InputDecoration(
                  labelText: '동 선택',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _titleController,
              hintText: '제목을 입력하세요',
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Stack(
                children: [
                  _buildTextField(
                    controller: _contentController,
                    hintText: '내용을 입력하세요',
                    maxLines: null,
                    expands: true,
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 40),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Text(
                      '${_contentController.text.length}/1000',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildImageAttachment(),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            if (_titleController.text.trim().isEmpty ||
                                _contentController.text.trim().isEmpty ||
                                _selectedBuilding == null ||
                                user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('모든 필드를 입력해 주세요.'),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              _isSubmitting = true;
                            });
                            try {
                              await BoardApi().createPost(
                                title: _titleController.text.trim(),
                                content: _contentController.text.trim(),
                                apartmentId: _selectedBuilding!.apartmentId,
                                buildingId: _selectedBuilding!.buildingId,
                                userId: user.id,
                                images: _images,
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('게시글이 등록되었습니다.'),
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('등록 실패: $e')),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isSubmitting = false;
                                });
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            '등록',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAttachment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == _images.length) {
                // + 버튼
                return GestureDetector(
                  onTap: _onPickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: const Color(0xFFCCCCCC)),
                    ),
                    child: const Center(
                      child: Text(
                        '＋',
                        style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                // 이미지 썸네일 + 삭제 버튼
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.file(
                        _images[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onPickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() {
        _images.add(File(picked.path));
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int? maxLines = 1,
    bool expands = false,
    EdgeInsets? contentPadding,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      expands: expands,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF999999),
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(color: Color(0xFF0066CC)),
        ),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF454545)),
    );
  }
}

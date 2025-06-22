import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
                    onPressed: () {
                      // TODO: 등록 기능 구현
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
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
    return GestureDetector(
      onTap: () {
        // TODO: 이미지 선택 기능 구현
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: Center(
          child: Text(
            '＋',
            style: GoogleFonts.inter(
              fontSize: 24,
              color: const Color(0xFFCCCCCC),
            ),
          ),
        ),
      ),
    );
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

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class BoardApi {
  Future<void> createPost({
    required String title,
    required String content,
    required String apartmentId,
    required String buildingId,
    required String userId,
    required List<File> images,
  }) async {
    final uri = Uri.parse('http://localhost:8000/api/board/posts');
    final request = http.MultipartRequest('POST', uri);
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['apartment_id'] = apartmentId;
    request.fields['building_id'] = buildingId;
    request.fields['user_id'] = userId.toString();

    for (final image in images) {
      final mimeType = 'image/${image.path.split('.').last}';
      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('게시글 등록 실패: ${response.body}');
    }
  }
}

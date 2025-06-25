import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/post.dart';

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

  /// buildingId(동)로 게시글 목록을 조회하는 함수입니다.
  /// [buildingId] : 동(건물) 고유 ID
  /// 반환값 : Post 객체 리스트
  Future<List<Post>> fetchPostsByBuilding(String buildingId) async {
    final uri = Uri.parse(
      'http://localhost:8000/api/board/posts',
    ).replace(queryParameters: {'building_id': buildingId});
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('게시글 목록을 불러오지 못했습니다: \\${response.body}');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/post.dart';

const String BASE_URL = 'http://localhost:8000';

class BoardApi {
  Future<void> createPost({
    required String title,
    required String content,
    required String apartmentId,
    required String buildingId,
    required String userId,
    required List<File> images,
  }) async {
    final uri = Uri.parse('$BASE_URL/api/board/posts');
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
  Future<List<Post>> fetchPostsByBuilding(
    String buildingId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final uri = Uri.parse('$BASE_URL/api/board/posts').replace(
      queryParameters: {
        'building_id': buildingId,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );
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

  Future<Post> fetchPostDetail(dynamic postId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/api/board/post/${postId.toString()}'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final postJson = data['post'] as Map<String, dynamic>;
      postJson['comments'] = data['comments'];
      print(postJson);
      return Post.fromJson(postJson);
    } else {
      throw Exception('게시글 상세 정보를 불러오지 못했습니다.');
    }
  }

  Future<void> createComment({
    required int postId,
    required String userId,
    required String body,
  }) async {
    final uri = Uri.parse('$BASE_URL/api/board/comment');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'post_id': postId, 'user_id': userId, 'body': body}),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('댓글 등록 실패: \\${response.body}');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final uri = Uri.parse('$BASE_URL/api/board/comment/$commentId');
    final response = await http.delete(uri);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('댓글 삭제 실패: \\${response.body}');
    }
  }

  Future<void> updatePost({
    required int postId,
    required String title,
    required String content,
    required String apartmentId,
    required String buildingId,
    required List<dynamic> images,
  }) async {
    final uri = Uri.parse('$BASE_URL/api/board/post/$postId');
    final request = http.MultipartRequest('PUT', uri);
    request.fields['post_id'] = postId.toString();
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['apartment_id'] = apartmentId;
    request.fields['building_id'] = buildingId;

    for (final image in images) {
      if (image is File) {
        final mimeType = 'image/${image.path.split('.').last}';
        request.files.add(
          await http.MultipartFile.fromPath(
            'image_files',
            image.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else if (image is String) {
        request.fields['image_files'] = image;
      }
    }
    print(request.files);
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('게시글 수정 실패: ${response.body}');
    }
  }

  Future<void> deletePost(int postId) async {
    final uri = Uri.parse('$BASE_URL/api/board/post/$postId');
    final response = await http.delete(uri);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('게시글 삭제 실패: \\${response.body}');
    }
  }
}

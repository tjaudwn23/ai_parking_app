/// 게시판 관련 API 클래스(BoardApi)
/// - 커뮤니티 게시판 관련 API 호출을 담당하는 데이터 소스 클래스입니다.
/// - createPost(): 새 게시글을 작성합니다. 이미지 파일을 multipart/form-data로 전송합니다.
/// - fetchPostsByBuilding(): 특정 동의 게시글 목록을 페이지네이션으로 가져옵니다.
/// - fetchPostDetail(): 게시글 상세 정보와 댓글 목록을 가져옵니다.
/// - createComment(): 댓글을 작성합니다.
/// - deleteComment(): 댓글을 삭제합니다.
/// - updatePost(): 게시글을 수정합니다. 기존 이미지와 새 이미지를 함께 처리합니다.
/// - deletePost(): 게시글을 삭제합니다.
///
/// BASE_URL: 서버의 기본 URL 주소입니다.
library;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../model/post.dart';

//const String BASE_URL = 'http://localhost:8000';
const String BASE_URL = 'http://fine402.cafe24.com';

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

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST ${uri.toString()}');
    print('📤 요청 필드: ${request.fields}');
    print('📤 요청 파일 수: ${request.files.length}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

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

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] GET ${uri.toString()}');
    print('📤 요청 헤더: {\'Content-Type\': \'application/json\'}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] GET ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('게시글 목록을 불러오지 못했습니다: \\${response.body}');
    }
  }

  Future<Post> fetchPostDetail(dynamic postId) async {
    final uri = Uri.parse('$BASE_URL/api/board/post/${postId.toString()}');

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] GET ${uri.toString()}');
    print('📤 요청 헤더: {\'Content-Type\': \'application/json\'}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] GET ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final postJson = data['post'] as Map<String, dynamic>;
      postJson['comments'] = data['comments'];
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
    final requestBody = jsonEncode({
      'post_id': postId,
      'user_id': userId,
      'body': body,
    });

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST ${uri.toString()}');
    print('📤 요청 헤더: {\'Content-Type\': \'application/json\'}');
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('댓글 등록 실패: \\${response.body}');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final uri = Uri.parse('$BASE_URL/api/board/comment/$commentId');

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] DELETE ${uri.toString()}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.delete(uri);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] DELETE ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

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

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] PUT ${uri.toString()}');
    print('📤 요청 필드: ${request.fields}');
    print('📤 요청 파일 수: ${request.files.length}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] PUT ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('게시글 수정 실패: ${response.body}');
    }
  }

  Future<void> deletePost(int postId) async {
    final uri = Uri.parse('$BASE_URL/api/board/post/$postId');

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] DELETE ${uri.toString()}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.delete(uri);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] DELETE ${uri.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('게시글 삭제 실패: \\${response.body}');
    }
  }
}

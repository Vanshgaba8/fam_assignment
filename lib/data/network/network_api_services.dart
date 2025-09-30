import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import '../app_exceptions.dart';
import 'base_api_services.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final headers = <String, String>{'Content-Type': 'application/json'};

      Response response = await post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      ).timeout(Duration(seconds: 20));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future<dynamic> getWithBearerToken(String url, String token) async {
    dynamic responseJson;
    try {
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: 20));

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  /// Handles the response based on status code
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
      case 500:
        throw FetchDataException(
          "Error occurred with status code ${response.statusCode}",
        );
      default:
        throw FetchDataException(
          "Unexpected error with status code ${response.statusCode}",
        );
    }
  }

  @override
  Future<dynamic> postWithBearerToken(
    String url,
    dynamic data,
    String token,
  ) async {
    dynamic responseJson;
    try {
      if (data is Map<String, dynamic> && data.containsKey('file')) {
        // Handling file upload
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $token';

        // Add form fields
        data.forEach((key, value) {
          if (key != 'file') {
            request.fields[key] = value.toString();
          }
        });

        // Add file if it exists
        if (data['file'] != null) {
          request.files.add(
            await http.MultipartFile.fromPath('file', data['file'].path),
          );
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        responseJson = returnResponse(response);
      } else {
        // Regular POST request (JSON payload)
        final headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        };

        final response = await http
            .post(Uri.parse(url), headers: headers, body: json.encode(data))
            .timeout(Duration(seconds: 20));
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    debugPrint(responseJson.toString());
    return responseJson;
  }

  /// Regular POST request with Bearer token, no file handling
  @override
  Future<dynamic> onlyPostWithBearerToken(
    String url,
    dynamic data,
    String token,
  ) async {
    dynamic responseJson;
    try {
      // Set headers including the Bearer token
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Send the POST request
      final response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(data))
          .timeout(Duration(seconds: 20)); // Timeout after 20 seconds

      // Return response based on status code
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("An unexpected error occurred: $e");
    }
    return responseJson;
  }

  @override
  Future<dynamic> postMultipartFile(
    String url,
    Map<String, dynamic> data,
  ) async {
    dynamic responseJson;
    try {
      if (!data.containsKey('file') || data['file'] == null) {
        throw BadRequestException("No file provided");
      }

      File file = data['file'];
      final int fileSize = await file.length();

      // ✅ Limit to 25MB
      if (fileSize > 25 * 1024 * 1024) {
        throw BadRequestException("File size exceeds 25MB limit");
      }

      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields other than 'file'
      data.forEach((key, value) {
        if (key != 'file') {
          request.fields[key] = value.toString();
        }
      });

      // Attach the file with correct content type
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: _getContentType(file.path),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  MediaType _getContentType(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return MediaType('image', 'jpeg');
      case '.png':
        return MediaType('image', 'png');
      case '.pdf':
        return MediaType('application', 'pdf');
      case '.doc':
        return MediaType('application', 'msword');
      case '.docx':
        return MediaType(
          'application',
          'vnd.openxmlformats-officedocument.wordprocessingml.document',
        );
      default:
        return MediaType('application', 'octet-stream'); // generic binary
    }
  }

  Future<dynamic> postApi(String url, dynamic data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw Exception(
          'Failed POST: ${response.statusCode} - ${responseData['error'] ?? response.body}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<dynamic> deleteApiResponse(String url) async {
    try {
      final response = await http
          .delete(Uri.parse(url))
          .timeout(const Duration(seconds: 20));

      return returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } catch (e) {
      throw FetchDataException("Unexpected error: $e");
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiKey = 'AIzaSyBgb5znpxF2ACl9_-sZiIYESBgIA-Ygcz4';

// Channel IDs of the two channels you want to get videos from
const String channelId1 = 'UCdC58Fno7uiux5-fDWb3F4Q'; // Example channel 1
const String channelId2 = 'UCAPbeZYTsKaRd0Xe5gs2o6A'; // Example channel 2

// Function to get all videos from a specific channel
Future<List<Map<String, dynamic>>> getAllVideos(
    String apiKey, String channelId) async {
  // Build the URL for fetching the uploads playlist ID
  final channelUrl = Uri.parse(
      'https://www.googleapis.com/youtube/v3/channels?part=contentDetails&id=$channelId&key=$apiKey');

  // Fetch the channel details
  final channelResponse = await http.get(channelUrl);
  if (channelResponse.statusCode != 200) {
    throw Exception('Failed to load channel details');
  }

  final channelData = json.decode(channelResponse.body);
  final uploadsPlaylistId =
      channelData['items'][0]['contentDetails']['relatedPlaylists']['uploads'];

  // URL for fetching videos from the uploads playlist
  final playlistUrl = Uri.parse(
      'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=$uploadsPlaylistId&maxResults=50&key=$apiKey');

  List<Map<String, dynamic>> videos = [];
  String? nextPageToken;

  // Loop to fetch all pages of videos
  do {
    final response = await http.get(nextPageToken == null
        ? playlistUrl
        : Uri.parse('$playlistUrl&pageToken=$nextPageToken'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load videos');
    }

    final data = json.decode(response.body);

    // Add video details to the list
    for (var item in data['items']) {
      final videoTitle = item['snippet']['title'];
      final videoId = item['snippet']['resourceId']['videoId'];
      final thumbnailUrl = item['snippet']['thumbnails']['high']['url'];
      final uploadDate =
          DateTime.parse(item['snippet']['publishedAt']); // Parse to DateTime

      videos.add({
        'title': videoTitle,
        'videoId': videoId,
        'thumbnailUrl': thumbnailUrl,
        'uploadDate': uploadDate, // Store as DateTime
      });
    }

    nextPageToken = data['nextPageToken'];
  } while (nextPageToken != null);

  return videos;
}

void main() async {
  try {
    // Fetch videos from the first channel
    List<Map<String, dynamic>> allVideosChannel1 =
        await getAllVideos(apiKey, channelId1);

    // Fetch videos from the second channel
    List<Map<String, dynamic>> allVideosChannel2 =
        await getAllVideos(apiKey, channelId2);

    // Combine the videos from both channels into a single list
    List<Map<String, dynamic>> allVideos = []
      ..addAll(allVideosChannel1)
      ..addAll(allVideosChannel2);

    // Sort videos by upload date in descending order (newest first)
    allVideos.sort((a, b) => b['uploadDate'].compareTo(a['uploadDate']));

    // Print all videos
    for (var video in allVideos) {
      print(
          'Title: ${video['title']},\n Video ID: ${video['videoId']}\n ThumbnailUrl: ${video['thumbnailUrl']}\n Date: ${video['uploadDate']}\n\n');
    }

    // Print total number of videos
    print('Total videos: ${allVideos.length}');
  } catch (e) {
    print('Error: $e');
  }
}

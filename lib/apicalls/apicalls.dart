import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart ' as http;

const baseUrl = "https://api.pexels.com/v1/";
const apiKey = "";

curatedWallpapersapi() async {
  const endpoint = '/curated/?page=1&per_page=80?';
  final response = await http.get(
    Uri.parse("$baseUrl$endpoint"),
    headers: {'Authorization': apiKey},
  );
  if (response.statusCode == 200) {
    log("Success fetching wallpapers");
    Map wallpaperData = jsonDecode(response.body);
    return wallpaperData;
  } else {
    log("failed fetching wallpapers :${response.statusCode} - ${response.body} ");
    throw Exception("error fetching wallpapers");
  }
}

refreshWallPaper(int page) async {
  final endpoint = '/curated/?page=$page&per_page=40?';
  final response = await http.get(
    Uri.parse("$baseUrl$endpoint"),
    headers: {'Authorization': apiKey},
  );
  if (response.statusCode == 200) {
    log("Success fetching wallpapers");
    Map wallpaperData = jsonDecode(response.body);
    return wallpaperData;
  } else {
    log("failed fetching wallpapers :${response.statusCode} - ${response.body} ");
    throw Exception("error fetching wallpapers");
  }
}

imageDetails({imageid}) async {
  final int imageId = imageid;
  final endpoint = 'photos/$imageId';
  final response = await http.get(
    Uri.parse('$baseUrl$endpoint'),
    headers: {'Authorization': apiKey},
  );
  if (response.statusCode == 200) {
    log("Success fetching image");
    Map wallPaperDetails = jsonDecode(response.body);
    return wallPaperDetails;
  } else {
    log("failed fetching wallpapers :${response.statusCode} - ${response.body} ");
    throw Exception("error fetching wallpapers");
  }
}

Future<List<dynamic>> searchimages({required String searchtext}) async {
  final String searchText = searchtext;
  final endpoint = 'search?query=$searchText&per_page=40&page=1';
  final response = await http.get(
    Uri.parse('$baseUrl$endpoint'),
    headers: {'Authorization': apiKey},
  );

  if (response.statusCode == 200) {
    log("Success fetching wallpapers");
    Map<String, dynamic> wallpaperData = jsonDecode(response.body);

    if (wallpaperData['photos'] != null) {
      return wallpaperData['photos'];
    } else {
      return [];
    }
  } else {
    log("Failed fetching wallpapers: ${response.statusCode} - ${response.body}");
    throw Exception("Error fetching wallpapers");
  }
}

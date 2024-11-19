import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/apicalls/apicalls.dart';
import 'package:wallpaperapp/widgets/botomsheet.dart';

class ImageDetails extends StatefulWidget {
  final int imageid;

  const ImageDetails({
    super.key,
    required this.imageid,
  });

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  Map<String, dynamic>? wallPaperDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWallPaperDetails();
  }

  Future<void> fetchWallPaperDetails() async {
    try {
      var imageData = await imageDetails(imageid: widget.imageid);
      setState(() {
        wallPaperDetails = imageData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching wallpapers: $e");

      if (e is HttpException) {
        print("HTTP Error: ${e.message}");
      } else {
        print("Unknown error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wallPaperDetails != null
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 1,
                      child: CachedNetworkImage(
                        imageUrl: wallPaperDetails!['src']['portrait'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          height: 500,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ],
                )
              : const Center(child: Text("No Image Found")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return CustomBottomSheet(
                  imageUrl: wallPaperDetails!['src']['portrait'],
                );
              });
        },
        child: const Icon(Icons.wallpaper),
      ),
    );
  }
}

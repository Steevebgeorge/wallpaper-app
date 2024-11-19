import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpaperapp/apicalls/apicalls.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(List<dynamic>) onSearch; // Add this line

  const CustomSearchBar(
      {super.key, required this.onSearch}); // Update constructor

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController searchController = TextEditingController();
  Timer? debounce;
  bool isLoading = false;

  void search(String query) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        isLoading = true;
      });
      try {
        var searchWallpapers = await searchimages(searchtext: query);
        widget.onSearch(searchWallpapers); // Call the callback with the results
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error fetching wallpapers: $e");
      }
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: searchController,
        onChanged: (value) => search(value.trim()),
        decoration: InputDecoration(
          hintText: "Search ...",
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }
}

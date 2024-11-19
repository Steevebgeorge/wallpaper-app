import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpaperapp/apicalls/apicalls.dart';
import 'package:wallpaperapp/widgets/customsearchbar.dart';
import 'package:wallpaperapp/widgets/imagedetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List wallpapers = [];
  bool isLoading = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchWallpapers();
  }

  Future<void> fetchWallpapers() async {
    try {
      var data = await curatedWallpapersapi();
      setState(() {
        wallpapers = data['photos'];
        isLoading = false;
      });
      print(wallpapers.length);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching wallpapers: $e");
    }
  }

  Future<void> refreshWallPapers() async {
    try {
      var data = await refreshWallPaper(page);
      if (data != null && data['photos'] != null) {
        setState(() {
          wallpapers.addAll(data['photos']);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching wallpapers: $e")),
        );
      }
    }
  }

  void onRefresh() {
    setState(() {
      page = page + 1;
      refreshWallPapers();
    });
  }

  void handleSearchResults(List<dynamic> results) {
    if (results.isEmpty) {
      wallpapers = [];
    } else {
      wallpapers = results;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const Icon(Icons.menu),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  CustomSearchBar(onSearch: handleSearchResults),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Text(
                      "Featured",
                      style: GoogleFonts.xanhMono(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.79,
                      child: wallpapers.isEmpty
                          ? const Center(
                              child: Text("No result found, try again..."),
                            )
                          : MasonryGridView.builder(
                              itemCount: wallpapers.length,
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ImageDetails(
                                          imageid: wallpapers[index]['id']),
                                    ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    margin: const EdgeInsets.only(bottom: 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: wallpapers[index]['src']
                                            ['medium'],
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: onRefresh,
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}

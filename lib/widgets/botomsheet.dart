import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class CustomBottomSheet extends StatefulWidget {
  final String imageUrl;
  const CustomBottomSheet({
    super.key,
    required this.imageUrl,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  Future<void> setlockScreenWallpaper() async {
    int location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

    bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);

    if (result) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wallpaper set successfully!"),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to set wallpaper!"),
          ),
        );
      }
    }
  }

  Future<void> setHomeScreenWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

    bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);

    if (result) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wallpaper set successfully!"),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to set wallpaper!"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              setlockScreenWallpaper();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wallpaper),
                Text("  Set Lock-Screen Wallpaper"),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setHomeScreenWallpaper();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wallpaper),
                Text("Set Home-Screen Wallpaper"),
              ],
            ),
          )
        ],
      ),
    );
  }
}

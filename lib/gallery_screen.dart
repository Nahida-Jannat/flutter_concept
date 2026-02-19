import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Map<String, dynamic>> _images = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() => _isLoading = true);

    // Simulate loading images from network
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _images.addAll([
        {
          'id': 1,
          'url': 'https://picsum.photos/200/200?random=1',
          'title': 'Mountain View',
          'likes': 45,
        },
        {
          'id': 2,
          'url': 'https://picsum.photos/200/200?random=2',
          'title': 'Beach Sunset',
          'likes': 32,
        },
        {
          'id': 3,
          'url': 'https://picsum.photos/200/200?random=3',
          'title': 'City Lights',
          'likes': 78,
        },
        {
          'id': 4,
          'url': 'https://picsum.photos/200/200?random=4',
          'title': 'Forest Path',
          'likes': 23,
        },
        {
          'id': 5,
          'url': 'https://picsum.photos/200/200?random=5',
          'title': 'Ocean Waves',
          'likes': 91,
        },
        {
          'id': 6,
          'url': 'https://picsum.photos/200/200?random=6',
          'title': 'Desert Dunes',
          'likes': 17,
        },
      ]);
      _isLoading = false;
    });
  }

  void _showFullImage(Map<String, dynamic> image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullImageScreen(image: image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadImages,
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            final image = _images[index];
            return GestureDetector(
              onTap: () => _showFullImage(image),
              child: Card(
                elevation: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        image['url'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 50),
                          );
                        },
                      ),
                    ),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),

                    // Title and likes
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            image['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${image['likes']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final Map<String, dynamic> image;

  const FullImageScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image['title']),
      ),
      body: Center(
        child: Hero(
          tag: 'image-${image['id']}',
          child: Image.network(
            image['url'],
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
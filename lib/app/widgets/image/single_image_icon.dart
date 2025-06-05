import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SingleImageIcon extends StatelessWidget {
  final IconData icon;
  final String? photo;
  final double height;
  final double width;
  final BoxFit fit;
  
  const SingleImageIcon({
    super.key,
    this.icon = Iconsax.image,
    this.photo = '',
    this.height = 50.0,
    this.width = 50.0,
    this.fit = BoxFit.cover,
  });
  
  String _applyCorsProxy(String url) {
    return 'https://wsrv.nl/?url=${Uri.encodeComponent(url)}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 213, 225, 235),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: photo == null || photo!.isEmpty
        ? Icon(icon)
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _applyCorsProxy(photo!),
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                return Icon(icon, color: Colors.grey.shade600);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                );
              },
            ),
          ),
    );
  }
}
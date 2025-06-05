import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? headerAction;
  final List<Map<String, String>> routes;

  const PageHeader({
    super.key,
    required this.title,
    this.headerAction,
    this.routes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (headerAction != null)
            _buildHeaderActionButton()
          else if (routes.isNotEmpty)
            ...routes.map(_buildRouteButton),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton() {
    return InkWell(
      onTap: headerAction,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(17, 39, 43, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'Agregar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildRouteButton(Map<String, String> routeInfo) {
    return InkWell(
      onTap: () {
        if (routeInfo.containsKey('path')) {
          Get.offNamed(routeInfo['path']!);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black26,
              size: 15,
            ),
            const SizedBox(width: 10),
            Text(
              routeInfo['label'] ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
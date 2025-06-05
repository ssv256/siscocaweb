import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:siscoca/routes/routes.dart';

class DrawerItemData {
  final String name;
  final IconData? icon;
  final String url;
  final List<DrawerItemChild> children;

  const DrawerItemData({
    required this.name,
    this.icon,
    required this.url,
    this.children = const [],
  });
}

/// Type alias for child drawer items
typedef DrawerItemChild = ({String name, String url});

final List<DrawerItemData> menuItems = [
  const DrawerItemData(
    icon: Iconsax.home,
    name: 'Inicio',
    url: AppRoutes.home
  ),
  const DrawerItemData(
    icon: Iconsax.people,
    name: 'Pacientes',
    url: AppRoutes.patients
  ),
  const DrawerItemData(
    icon: Iconsax.hospital,
    name: 'Cuestionarios',
    url: AppRoutes.survey
  ),
  const DrawerItemData(
    icon: Iconsax.grid_1,
    name: 'Recursos',
    url: '/resources',
    children: [
      (name: 'Noticias', url: AppRoutes.news),
      (name: 'Categorías', url: AppRoutes.categories),
    ],
  ),
  const DrawerItemData(
    icon: Iconsax.document,
    name: 'Team space',
    url: '/team-space',
    children: [
      (name: 'Estudios', url: AppRoutes.studiesAdmin),
      (name: 'Hospitales', url: AppRoutes.hospitals),
      (name: 'Medicos', url: AppRoutes.doctors),
    ],
  ),
];
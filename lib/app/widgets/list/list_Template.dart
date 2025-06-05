import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../card/v1/card/main_card.dart';
import '../inputs/input_simulator.dart';
import '../inputs/main_input.dart';

/// A template widget for displaying lists with optional search and sort functionality.
/// 
/// The [controller] manages the scrolling of the list.
/// [title] displays at the top of the list if provided.
/// [filter] enables a search input when true.
/// [sort] enables sorting functionality when true.
class ListTemplate extends StatelessWidget {
  static const double kDesktopBreakpoint = 750;
  static const double kDefaultInputWidth = 200;
  static const double kDefaultButtonWidth = 230;

  final ScrollController controller;
  final double? width;
  final double? height;
  final List<Widget> children;
  final bool loader;
  final String? title;
  final IconData? icon;
  final VoidCallback? iconOnTap;
  final bool filter;
  final Widget? header;
  final String emptyTitle;
  final IconData iconData;
  final TextEditingController? filterController;
  final ValueChanged<String>? onFilterChange;
  final bool sort;
  final bool sortStatus;
  final ValueChanged<bool>? onSortStatusChange;
  final ValueChanged<String>? onSort;
  final bool sortDate;
  final List<String>? columnNames;

  const ListTemplate({
    super.key,
    required this.controller,
    this.title,
    this.icon,
    this.width,
    this.header,
    this.height,
    this.iconOnTap,
    this.onSort,
    this.onFilterChange,
    this.onSortStatusChange,
    this.filterController,
    this.sort = false,
    this.loader = false,
    this.filter = false,
    this.sortDate = false,
    this.iconData = Iconsax.warning_2,
    this.children = const [],
    this.sortStatus = false,
    this.emptyTitle = 'No hay datos',
    this.columnNames,
  })  : assert(width == null || width > 0, 'Width must be positive'),
        assert(height == null || height > 0, 'Height must be positive'),
        assert(!filter || filterController != null, 'FilterController is required when filter is true'),
        assert(!sort || onSort != null, 'onSort is required when sort is true');

  Widget _buildHeaderDefault() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
              ),
            ),
          const Spacer(),
          if (filter)
            SizedBox(
              width: kDefaultInputWidth,
              child: TextFieldWidget(
                margin: false,
                controller: filterController!,
                labelText: 'Buscar',
                onchange: onFilterChange,
              ),
            )
          else
            const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildHeaderMobile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (filter)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: TextFieldWidget(
                      margin: false,
                      controller: filterController!,
                      labelText: 'Buscar',
                      onchange: onFilterChange,
                    ),
                  ),
                )
              else
                const Spacer(),
              if (sort)
                SizedBox(
                  width: kDefaultInputWidth,
                  child: FieldSimulator(
                    height: 49,
                    paddingVertical: 13,
                    action: () => onSort?.call('default'),
                    title: '',
                    data: 'Ordenar por',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders() {
    if (columnNames == null || columnNames!.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 240, 240),
        border: Border.all(color: const Color.fromARGB(255, 240, 240, 240)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columnNames!.map((name) => Text(name)).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Icon(
          iconData,
          size: 70,
          color: const Color.fromARGB(255, 118, 118, 118),
        ),
        const SizedBox(height: 5),
        Text(emptyTitle),
      ],
    );
  }

  Widget _buildContent() {
    if (children.isEmpty && !loader) {
      return _buildEmptyState();
    }
    
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > kDesktopBreakpoint;
        
        return MainCard(
          height: height,
          width: width,
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                if (header != null)
                  header!
                else
                  if (isDesktop)
                    _buildHeaderDefault()
                  else
                    _buildHeaderMobile(),
                    
              if (columnNames != null) _buildColumnHeaders(),
              _buildContent(),
            ],
          ),
        );
      },
    );
  }
}
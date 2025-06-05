import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ListTableWidget extends StatelessWidget {
  final List<TableHeader> headers;
  final List<TableRowData> rows;
  final bool isPaginated;
  final int? itemsPerPage;
  final ValueChanged<int>? onPageChanged;
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearch;
  final bool enableSearch;
  final Widget? actionButton;
  final Color? headerColor;
  final Color? selectedRowColor;

  ListTableWidget({
    super.key, 
    required this.headers, 
    required this.rows,
    this.isPaginated = true,
    this.itemsPerPage,
    this.onPageChanged,
    this.searchController,
    this.onSearch,
    this.enableSearch = false,
    this.actionButton,
    this.headerColor,
    this.selectedRowColor,
  }) : assert(headers.isNotEmpty, 'Headers cannot be empty'),
       assert(rows.every((row) => row.cells.length == headers.length), 
              'Each row must have the same number of cells as headers'),
       assert(!enableSearch || searchController != null, 
              'SearchController is required when enableSearch is true');

  double get _totalWidth => headers.fold(0, (sum, header) => sum + header.width);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isSmallScreen = availableWidth < 600;
        return Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableMainHeaderEd(
                  isPaginated: isPaginated && !isSmallScreen,
                  onPageChanged: onPageChanged,
                  totalItems: rows.length,
                  itemsPerPage: itemsPerPage,
                  searchController: enableSearch ? searchController : null,
                  onSearch: onSearch,
                  actionButton: actionButton,
                ),
                if (enableSearch && isSmallScreen)
                  _buildSearchField(theme),
                const SizedBox(height: 16),
                Expanded(
                  child: isSmallScreen 
                      ? _buildMobileView(theme)
                      : _buildDesktopView(theme, availableWidth - 2),
                ),
              ],
            ),
        );
      },
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: searchController,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          prefixIcon: const Icon(Iconsax.search_normal),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildMobileView(ThemeData theme) {
    if (rows.isEmpty) {
      return _buildEmptyState(theme);
    }
    
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];
        
        return _HoverableMobileRow(
          row: row,
          theme: theme,
          headers: headers,
          selectedRowColor: selectedRowColor,
        );
      },
    );
  }

  Widget _buildDesktopView(ThemeData theme, double availableWidth) {
    if (rows.isEmpty) {
      return _buildEmptyState(theme);
    }

    final effectiveWidth = availableWidth;
    final needsHorizontalScroll = _totalWidth > effectiveWidth;
    final tableWidth = needsHorizontalScroll ? _totalWidth : effectiveWidth;
    
    final tableContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(theme, needsHorizontalScroll, effectiveWidth),
        const SizedBox(height: 8),
        Expanded(
          child: _buildTableBody(theme, needsHorizontalScroll, effectiveWidth),
        ),
      ],
    );
    
    if (needsHorizontalScroll) {
      return Scrollbar(
        controller: _horizontalScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: tableContent,
          ),
        ),
      );
    }
    
    return SizedBox(
      width: tableWidth,
      child: tableContent,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.document,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay datos disponibles',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta cambiar los filtros o añadir nuevos registros',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(ThemeData theme, bool needsHorizontalScroll, double availableWidth) {
    final width = needsHorizontalScroll ? _totalWidth : availableWidth;
    
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: headerColor ?? theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: _buildHeaderRow(theme, needsHorizontalScroll, availableWidth),
    );
  }

  Widget _buildHeaderRow(ThemeData theme, bool needsHorizontalScroll, double availableWidth) {
    final ratio = needsHorizontalScroll ? 1.0 : (availableWidth - 2) / _totalWidth;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        headers.length,
        (index) {
          final cellWidth = headers[index].width * (needsHorizontalScroll ? 1.0 : ratio);
          return Container(
            width: cellWidth,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), 
            child: Tooltip(
              message: headers[index].tooltip ?? headers[index].title,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      headers[index].title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (headers[index].sortable)
                    Icon(
                      Iconsax.sort,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableBody(ThemeData theme, bool needsHorizontalScroll, double availableWidth) {
    final width = needsHorizontalScroll ? _totalWidth : availableWidth;
    return SizedBox(
      width: width,
      child: Scrollbar(
        controller: _verticalScrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _verticalScrollController,
          itemCount: rows.length,
          itemBuilder: (context, index) => _buildTableRow(rows[index], theme, needsHorizontalScroll, availableWidth),
        ),
      ),
    );
  }

  Widget _buildTableRow(TableRowData row, ThemeData theme, bool needsHorizontalScroll, double availableWidth) {
    final width = needsHorizontalScroll ? _totalWidth : availableWidth;
    final ratio = needsHorizontalScroll ? 1.0 : (availableWidth - 2) / _totalWidth;
    
    return _HoverableTableRow(
      row: row,
      theme: theme,
      width: width,
      ratio: ratio,
      headers: headers,
      needsHorizontalScroll: needsHorizontalScroll,
      selectedRowColor: selectedRowColor,
    );
  }
}

// New HoverableTableRow class
class _HoverableTableRow extends StatefulWidget {
  final TableRowData row;
  final ThemeData theme;
  final double width;
  final double ratio;
  final List<TableHeader> headers;
  final bool needsHorizontalScroll;
  final Color? selectedRowColor;

  const _HoverableTableRow({
    required this.row,
    required this.theme,
    required this.width,
    required this.ratio,
    required this.headers,
    required this.needsHorizontalScroll,
    this.selectedRowColor,
  });

  @override
  State<_HoverableTableRow> createState() => _HoverableTableRowState();
}

class _HoverableTableRowState extends State<_HoverableTableRow> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.row.isSelected 
              ? widget.selectedRowColor ?? widget.theme.colorScheme.primary.withOpacity(0.1)
              : isHovered
                  ? widget.theme.colorScheme.primary.withOpacity(0.05)
                  : widget.theme.cardTheme.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isHovered 
              ? widget.theme.colorScheme.primary.withOpacity(0.3) 
              : widget.theme.dividerColor.withOpacity(0.1),
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered 
                ? widget.theme.colorScheme.primary.withOpacity(0.1)
                : Colors.black.withOpacity(0.02),
              blurRadius: isHovered ? 8 : 3,
              spreadRadius: isHovered ? 1 : 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: widget.row.onTap,
            borderRadius: BorderRadius.circular(10),
            hoverColor: widget.theme.colorScheme.primary.withOpacity(0.03),
            splashColor: widget.theme.colorScheme.primary.withOpacity(0.1),
            highlightColor: widget.theme.colorScheme.primary.withOpacity(0.08),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final rowContent = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.headers.length,
                    (index) {
                      final cellWidth = widget.headers[index].width * 
                          (widget.needsHorizontalScroll ? 1.0 : widget.ratio);
                      return Container(
                        width: cellWidth,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: widget.row.cells[index],
                      );
                    },
                  ),
                );
                
                if (widget.needsHorizontalScroll) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: rowContent,
                  );
                }
                
                return rowContent;
              },
            ),
          ),
        ),
      ),
    );
  }
}

// New HoverableMobileRow class
class _HoverableMobileRow extends StatefulWidget {
  final TableRowData row;
  final ThemeData theme;
  final List<TableHeader> headers;
  final Color? selectedRowColor;

  const _HoverableMobileRow({
    required this.row,
    required this.theme,
    required this.headers,
    this.selectedRowColor,
  });

  @override
  State<_HoverableMobileRow> createState() => _HoverableMobileRowState();
}

class _HoverableMobileRowState extends State<_HoverableMobileRow> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.row.isSelected 
              ? widget.selectedRowColor ?? widget.theme.colorScheme.primary.withOpacity(0.1)
              : isHovered
                  ? widget.theme.colorScheme.primary.withOpacity(0.05)
                  : widget.theme.cardTheme.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isHovered 
              ? widget.theme.colorScheme.primary.withOpacity(0.3) 
              : Colors.transparent,
            width: isHovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isHovered 
                ? widget.theme.colorScheme.primary.withOpacity(0.1)
                : Colors.black.withOpacity(0.02),
              blurRadius: isHovered ? 8 : 3,
              spreadRadius: isHovered ? 1 : 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:InkWell(
            onTap: widget.row.onTap,
            borderRadius: BorderRadius.circular(10),
            hoverColor: widget.theme.colorScheme.primary.withOpacity(0.03),
            splashColor: widget.theme.colorScheme.primary.withOpacity(0.1),
            highlightColor: widget.theme.colorScheme.primary.withOpacity(0.08),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.headers.length,
                  (i) =>  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            widget.headers[i].title,
                            style: widget.theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: widget.row.cells[i],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class TableHeader {
  final String title;
  final double width;
  final String? tooltip;
  final bool sortable;

  const TableHeader({
    required this.title,
    required this.width,
    this.tooltip,
    this.sortable = false,
  });
}

class TableRowData {
  final List<Widget> cells;
  final VoidCallback? onTap;
  final bool isSelected;

  const TableRowData({
    required this.cells,
    this.onTap,
    this.isSelected = false,
  });
}

class TableMainHeaderEd extends StatelessWidget {
  final bool isPaginated;
  final ValueChanged<int>? onPageChanged;
  final int? totalItems;
  final int? itemsPerPage;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearch;
  final Widget? actionButton;
  
  const TableMainHeaderEd({
    super.key,
    this.isPaginated = true,
    this.onPageChanged,
    this.totalItems,
    this.itemsPerPage,
    this.searchController,
    this.onSearch,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final isNarrow = availableWidth < 800;
        
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              if (searchController != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
              
            ],
          );
        }
        
        return Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              if (searchController != null)
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearch,
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        prefixIcon: const Icon(Iconsax.search_normal),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                ),
              if (actionButton != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: actionButton!,
                ),
          
            ],
          ),
        );
      },
    );
  }

}
// import 'package:data_table_2/data_table_2.dart';
// import 'package:flutter/material.dart';

// class TableAsyncApu extends StatelessWidget {
//   const TableAsyncApu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AsyncPaginatedDataTable2(
//       horizontalMargin: 20,
//       checkboxHorizontalMargin: 12,
//       columnSpacing: 0,
//       wrapInCard: false,
//       header: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           if (getCurrentRouteOption(context) == custPager)
//                   PageNumber(controller: _controller)
//           ]
//       ),
//           rowsPerPage: _rowsPerPage,
//           autoRowsToHeight: getCurrentRouteOption(context) == autoRows,
//           // Default - do nothing, autoRows - goToLast, other - goToFirst
//           pageSyncApproach: getCurrentRouteOption(context) == dflt
//               ? PageSyncApproach.doNothing
//               : getCurrentRouteOption(context) == autoRows
//                   ? PageSyncApproach.goToLast
//                   : PageSyncApproach.goToFirst,
//           minWidth: 800,
//           fit: FlexFit.tight,
//           border: TableBorder(
//               top: const BorderSide(color: Colors.black),
//               bottom: BorderSide(color: Colors.grey[300]!),
//               left: BorderSide(color: Colors.grey[300]!),
//               right: BorderSide(color: Colors.grey[300]!),
//               verticalInside: BorderSide(color: Colors.grey[300]!),
//               horizontalInside: const BorderSide(color: Colors.grey, width: 1)),
//           onRowsPerPageChanged: (value) {
//             // No need to wrap into setState, it will be called inside the widget
//             // and trigger rebuild
//             //setState(() {
//             print('Row per page changed to $value');
//             _rowsPerPage = value!;
//             //});
//           },
//           initialFirstRowIndex: _initialRow,
//           onPageChanged: (rowIndex) {
//             //print(rowIndex / _rowsPerPage);
//           },
//           sortColumnIndex: _sortColumnIndex,
//           sortAscending: _sortAscending,
//           sortArrowIcon: Icons.keyboard_arrow_up,
//           sortArrowAnimationDuration: const Duration(milliseconds: 0),
//           onSelectAll: (select) => select != null && select
//               ? (getCurrentRouteOption(context) != selectAllPage
//                   ? _dessertsDataSource!.selectAll()
//                   : _dessertsDataSource!.selectAllOnThePage())
//               : (getCurrentRouteOption(context) != selectAllPage
//                   ? _dessertsDataSource!.deselectAll()
//                   : _dessertsDataSource!.deselectAllOnThePage()),
//           controller: _controller,
//           hidePaginator: getCurrentRouteOption(context) == custPager,
//           columns: _columns,
//           empty: Center(
//               child: Container(
//                   padding: const EdgeInsets.all(20),
//                   color: Colors.grey[200],
//                   child: const Text('No data'))),
//           loading: _Loading(),
//           errorBuilder: (e) => _ErrorAndRetry(
//               e.toString(), () => _dessertsDataSource!.refreshDatasource()),
//           source: _dessertsDataSource!),;
//   }
// }
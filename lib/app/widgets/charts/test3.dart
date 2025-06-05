import 'package:flutter/material.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tab Bar
            DefaultTabController(
              length: 3, // Number of tabs
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'New Bookings'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                  // Tab Bar View
                  Container(
                    height: 500, 
                    child: TabBarView(
                      children: [
                        // Replace with your actual content for each tab
                        Center(child: Text('New Bookings Content')),
                        Center(child: Text('Upcoming Content')),
                        buildCompletedBookings(), // Function to build the Completed tab
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCompletedBookings() {
    // Sample data for completed bookings
    List<Map<String, dynamic>> completedBookings = [
      {
        'customerName': 'Esther Howard',
        'bookingId': '#273820',
        'carName': 'Rolls Royal Ghost V2',
        'date': 'June 02, 2023',
        'time': '10:30 AM',
        'amount': '\$50,000',
        'status': 'Completed'
      },
      {
        'customerName': 'Wade Warren',
        'bookingId': '#273821',
        'carName': 'Lamborghini Uras',
        'date': 'June 02, 2023',
        'time': '10:20 AM',
        'amount': '\$40,000',
        'status': 'Completed'
      },
      {
        'customerName': 'Guy Hawkins',
        'bookingId': '#273822',
        'carName': 'BMW 520d Sport',
        'date': 'June 02, 2023',
        'time': '10:00 AM',
        'amount': '\$10,000',
        'status': 'Completed'
      },
      {
        'customerName': 'Robert Fox',
        'bookingId': '#273823',
        'carName': 'Ferrari F12 Barsilona',
        'date': 'June 02, 2023',
        'time': '9:30 AM',
        'amount': '\$50,00',
        'status': 'Completed'
      },
      {
        'customerName': 'Cody Fisher',
        'bookingId': '#273824',
        'carName': 'Rolls Royal Ghost V2',
        'date': 'June 02, 2023',
        'time': '7:30 AM',
        'amount': '\$50,0',
        'status': 'Completed'
      },
      {
        'customerName': 'Ralph Edwards',
        'bookingId': '#273825',
        'carName': 'Tesla model 3',
        'date': 'June 02, 2023',
        'time': '8:30 AM',
        'amount': '\$70,00',
        'status': 'Completed'
      },
      {
        'customerName': 'Ronald Richards',
        'bookingId': '#273826',
        'carName': 'Lamborghini Uras',
        'date': 'June 02, 2023',
        'time': '8:10 AM',
        'amount': '\$10,000',
        'status': 'Completed'
      },
      {
        'customerName': 'Jerome Bell',
        'bookingId': '#273827',
        'carName': 'BMW 520d Sport',
        'date': 'June 02, 2023',
        'time': '7:30 AM',
        'amount': '\$60,00',
        'status': 'Completed'
      },
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: completedBookings.length,
            itemBuilder: (context, index) {
              final booking = completedBookings[index];
              return ListTile(
                leading: CircleAvatar(
                  // You can replace this with an image if you have one
                  child: Text(booking['customerName'][0]),
                ),
                title: Text(booking['customerName']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking['bookingId']),
                    Text(booking['carName']),
                    Text('${booking['date']}, ${booking['time']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(booking['amount']),
                    SizedBox(width: 8),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking['status'],
                          style: TextStyle(color: Colors.green),
                        )),
                    SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (String item) {
                        // Handle action based on the selected item
                        print('Selected: $item');
                      },
                      itemBuilder: (BuildContext context) {
                        return {'Edit', 'Delete'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Pagination
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Showing 1 To 8 Out Of 8 Records'),
              DropdownButton<int>(
                value: 10, // Current number of items per page
                items: [10, 25, 50, 100].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  // Handle change in number of items per page
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
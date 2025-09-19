import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          
          _buildMonthSection('October 2021'),
          const SizedBox(height: 16),
          
      
          _buildNotificationCard(
            type: 'Promotion',
            date: 'Oct 21 - 08.00',
            title: 'Today 50% discount',
            description: 'on all Books in Novel category with online orders worldwide.',
          ),
          const SizedBox(height: 12),
          
      
          _buildNotificationCard(
            type: 'Promotion',
            date: 'Oct 08 - 20.30',
            title: 'Buy 2 get 1 free',
            description: 'for since books from 08 - 10 October 2021.',
          ),
          
          const Divider(thickness: 1, height: 32),
          
       
 _buildMonthSection('September 2021'),
          const SizedBox(height: 16),
          
         
          _buildNotificationCard(
      type: 'Information',
            date: 'Sept 16 - 11.00',
            title: 'There is a new book now are available',
            description: '',
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSection(String month) {
    return Text(
      month,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildNotificationCard({
    required String type,
    required String date,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
          
            if (title.contains('50%') || title.contains('2 get 1'))
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: title.substring(0, title.indexOf('50%') + 3),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: title.substring(title.indexOf('50%') + 3),
                    ),
                  ],
                ),
              )
            else
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            
         
            if (description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
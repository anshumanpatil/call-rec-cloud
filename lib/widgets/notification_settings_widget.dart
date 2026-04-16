import 'package:flutter/material.dart';

class NotificationSettingsWidget extends StatelessWidget {
  const NotificationSettingsWidget({
    super.key,
    required this.notificationTitleController,
    required this.notificationBodyController,
    required this.selectedRepeatInterval,
    required this.onRepeatIntervalChanged,
    required this.onSaveNotificationDetails,
  });

  final TextEditingController notificationTitleController;
  final TextEditingController notificationBodyController;
  final String selectedRepeatInterval;
  final ValueChanged<String?> onRepeatIntervalChanged;
  final VoidCallback onSaveNotificationDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notification Title',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: notificationTitleController,
          decoration: InputDecoration(
            hintText: 'Reminder',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Notification Body',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: notificationBodyController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'upload files to storage',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Notification Frequency',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: selectedRepeatInterval,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'hourly', child: Text('Hourly')),
            DropdownMenuItem(value: 'daily', child: Text('Daily')),
            DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
          ],
          onChanged: onRepeatIntervalChanged,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: onSaveNotificationDetails,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Notification Text'),
          ),
        ),
      ],
    );
  }
}

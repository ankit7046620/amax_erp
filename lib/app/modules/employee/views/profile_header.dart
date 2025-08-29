
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with your profile image if needed
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            'https://randomuser.me/api/portraits/men/1.jpg',
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Michael Mitc', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 4),
            Text('Lead UI/UX Designer', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),
        CircleAvatar(
radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.notifications_none, color: Colors.black54)),
      ],
    );
  }
}

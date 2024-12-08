import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Chore Flick'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Overview Section
            SectionTitle(title: 'Welcome to Chore Flick'),
            Text(
              "Chore Flick is your ultimate productivity companion designed to simplify your daily life. Whether it's taking notes, scheduling appointments, or tracking habits, Chore Flick ensures you stay organized and on top of your game.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Features Section
            SectionTitle(title: 'Key Features'),
            FeaturesList(
              features: [
                '📝 **Quick Notes**: Effortlessly capture your thoughts and ideas.',
                '📅 **Smart Appointments**: Schedule and manage events seamlessly.',
                '✔️ **Daily Habits**: Build and maintain productive habits.',
              ],
            ),
            SizedBox(height: 20),

            // Mission Section
            SectionTitle(title: 'Our Mission'),
            Text(
              "At Chore Flick, our mission is to empower individuals to achieve their goals by offering a simple yet powerful platform for personal organization. We aim to bridge the gap between productivity and simplicity.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // How It Works Section
            SectionTitle(title: 'How It Works'),
            FeaturesList(
              features: [
                '📌 Create notes for your tasks, ideas, or reminders.',
                '🕒 Schedule appointments and receive timely reminders.',
                '🌟 Track daily habits with an intuitive dashboard.',
                '💡 Access a clean and user-friendly interface.',
              ],
            ),
            SizedBox(height: 20),

            // Contact Us Section
            SectionTitle(title: 'Contact Us'),
            Text(
              "We'd love to hear from you! For feedback, support, or inquiries, feel free to reach out:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ContactDetails(),
          ],
        ),
      ),
    );
  }
}

// Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

// Features List Widget
class FeaturesList extends StatelessWidget {
  final List<String> features;

  const FeaturesList({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            feature,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}

// Contact Details Widget
class ContactDetails extends StatelessWidget {
  const ContactDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ContactRow(
          icon: Icons.email,
          label: 'Email',
          value: 'support@choreflick.com',
        ),
        ContactRow(
          icon: Icons.phone,
          label: 'Phone',
          value: '+1-800-123-4567',
        ),
        ContactRow(
          icon: Icons.web,
          label: 'Website',
          value: 'www.choreflick.com',
        ),
      ],
    );
  }
}

// Contact Row Widget
class ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

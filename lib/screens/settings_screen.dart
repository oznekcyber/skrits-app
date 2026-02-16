import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  _SettingsTile(
                    title: 'Theme',
                    subtitle: _getThemeModeLabel(appState.themeMode),
                    icon: Icons.palette_outlined,
                    onTap: () => _showThemeDialog(context),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            Text(
              'Learning',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  _SettingsTile(
                    title: 'Learning Mode',
                    subtitle: 'Silent Mode',
                    icon: Icons.school_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feature coming soon!')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    title: 'TTS Settings',
                    subtitle: 'Voice & Speed',
                    icon: Icons.record_voice_over,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feature coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            Text(
              'Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  _SettingsTile(
                    title: 'Name',
                    subtitle: appState.userName,
                    icon: Icons.person_outline,
                    onTap: () => _showNameDialog(context),
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    title: 'Email',
                    subtitle: 'user@example.com',
                    icon: Icons.email_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feature coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            Text(
              'About',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            
            const SizedBox(height: 16),
            
            Card(
              child: Column(
                children: [
                  _SettingsTile(
                    title: 'App Version',
                    subtitle: '1.0.0',
                    icon: Icons.info_outline,
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Feature coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            OutlinedButton.icon(
              onPressed: () {
                // Log out
                Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Log Out', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context) {
    final appState = context.read<AppStateProvider>();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: appState.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appState.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDialog(BuildContext context) {
    final appState = context.read<AppStateProvider>();
    final controller = TextEditingController(text: appState.userName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                appState.setUserName(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}

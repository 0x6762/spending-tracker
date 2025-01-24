import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              title: const Text('Settings'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Theme settings
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: const Text('Theme'),
                          subtitle: const Text('System default'),
                          onTap: () {
                            // TODO: Implement theme selection
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account settings
                  Text(
                    'Accounts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.account_balance_outlined),
                          title: const Text('Manage Accounts'),
                          subtitle: const Text('Add or edit your accounts'),
                          onTap: () {
                            // TODO: Implement account management
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Data settings
                  Text(
                    'Data',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.backup_outlined),
                          title: const Text('Backup & Restore'),
                          subtitle: const Text('Manage your expense data'),
                          onTap: () {
                            // TODO: Implement backup & restore
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: const Text('Clear Data'),
                          subtitle: const Text('Delete all expenses'),
                          textColor: Theme.of(context).colorScheme.error,
                          iconColor: Theme.of(context).colorScheme.error,
                          onTap: () {
                            // TODO: Implement clear data
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

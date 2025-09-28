// lib/core/widgets/adaptive_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final ValueChanged<int>? onDestinationSelected;

  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.currentIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktop(context);

    if (isDesktop) {
      return _buildDesktopLayout(context);
    } else {
      return _buildMobileLayout(context);
    }
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.language_outlined),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Открыть настройки
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Главная'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: Text('Портфель'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Рынок'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: Text('Профиль'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Открыть настройки
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Портфель',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Рынок',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.analytics_outlined, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Инвест-Аналитик Pro',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Главная'),
            selected: currentIndex == 0,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected?.call(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('Портфель'),
            selected: currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected?.call(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: const Text('Рынок'),
            selected: currentIndex == 2,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected?.call(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('Профиль'),
            selected: currentIndex == 3,
            onTap: () {
              Navigator.pop(context);
              onDestinationSelected?.call(3);
            },
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Версия 1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Русский'),
              onTap: () {
                _changeLanguage(context, const Locale('ru'));
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                _changeLanguage(context, const Locale('en'));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) {
    EasyLocalization.of(context)?.setLocale(locale);
    Navigator.pop(context);
  }
}

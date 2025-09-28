import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTab = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              children: [
                // Header Section
                _buildHeader(context, isSmallScreen),
                SizedBox(height: isSmallScreen ? 24 : 32),

                // Tab Bar - ИСПРАВЛЕННЫЙ ВАРИАНТ БЕЗ БЕЛОЙ ЛИНИИ
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
                  child: Container(
                    height: isSmallScreen ? 48 : 56,
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onSurface,
                      labelPadding: EdgeInsets.zero,
                      // Убираем dividerColor и indicatorPadding чтобы убрать белую линию
                      dividerColor: Colors.transparent,
                      indicatorPadding: EdgeInsets.zero,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      tabs: [
                        Tab(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login_outlined,
                                    size: isSmallScreen ? 18 : 20),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                Text(
                                  'login'.tr(),
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_outlined,
                                    size: isSmallScreen ? 18 : 20),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                Text(
                                  'register'.tr(),
                                  style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 24 : 32),

                // Content Area - УБИРАЕМ БЕЛУЮ ПОЛОСУ ПОД ТАБАМИ
                Container(
                  height: isSmallScreen ? 550 : 500,
                  decoration: BoxDecoration(
                    // Убираем любые границы и линии
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    // Убираем физику чтобы не было видно разделителя
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LoginTab(isSmallScreen: isSmallScreen),
                      RegisterTab(isSmallScreen: isSmallScreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
      child: Column(
        children: [
          Container(
            width: isSmallScreen ? 60 : 80,
            height: isSmallScreen ? 60 : 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(isSmallScreen ? 15 : 20),
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: isSmallScreen ? 30 : 40,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            'app_title'.tr(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 20 : 24,
                ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            _currentTab == 0
                ? 'Войдите в свой аккаунт'
                : 'Создайте новый аккаунт',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LoginTab extends StatefulWidget {
  final bool isSmallScreen;

  const LoginTab({super.key, required this.isSmallScreen});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      print('Login attempt: ${_emailController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isSmallScreen ? 16 : 24,
        vertical: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEmailField(),
            SizedBox(height: widget.isSmallScreen ? 12 : 16),
            _buildPasswordField(),
            SizedBox(height: widget.isSmallScreen ? 6 : 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  print('Forgot password pressed');
                },
                child: Text(
                  'forgot_password'.tr(),
                  style: TextStyle(fontSize: widget.isSmallScreen ? 14 : 16),
                ),
              ),
            ),
            SizedBox(height: widget.isSmallScreen ? 20 : 24),
            _buildLoginButton(),
            SizedBox(height: widget.isSmallScreen ? 20 : 24),
            _buildDivider(),
            SizedBox(height: widget.isSmallScreen ? 20 : 24),
            _buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'email'.tr(),
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Введите email';
        if (!value.contains('@')) return 'Введите корректный email';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'password'.tr(),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Введите пароль';
        if (value.length < 6)
          return 'Пароль должен содержать минимум 6 символов';
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: widget.isSmallScreen ? 48 : 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
              )
            : Text(
                'login'.tr(),
                style: TextStyle(
                    fontSize: widget.isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: widget.isSmallScreen ? 12 : 16),
          child: Text(
            'или войдите с помощью',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: widget.isSmallScreen ? 12 : 14,
            ),
          ),
        ),
        Expanded(
            child: Divider(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    final buttonSize =
        widget.isSmallScreen ? 48.0 : 56.0; // Добавляем .0 для double

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.apple,
          onPressed: () => print('Apple login'),
          size: buttonSize,
        ),
        SizedBox(width: widget.isSmallScreen ? 12 : 16),
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          onPressed: () => print('Google login'),
          size: buttonSize,
        ),
        SizedBox(width: widget.isSmallScreen ? 12 : 16),
        _buildSocialButton(
          icon: Icons.facebook,
          onPressed: () => print('Facebook login'),
          size: buttonSize,
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      {required IconData icon,
      required VoidCallback onPressed,
      required double size // Меняем на double
      }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, size: size * 0.4),
        onPressed: onPressed,
      ),
    );
  }
}

class RegisterTab extends StatefulWidget {
  final bool isSmallScreen;

  const RegisterTab({super.key, required this.isSmallScreen});

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isLoading = false);
      print('Register attempt: ${_emailController.text}');
    }
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Политика конфиденциальности'),
        content: SingleChildScrollView(
          child: Text(
            _privacyPolicyText,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfUse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Условия использования'),
        content: SingleChildScrollView(
          child: Text(
            _termsOfUseText,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  final String _privacyPolicyText = '''
ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ
Приложение "Инвест-Аналитик Pro"

1. Сбор информации
Мы собираем следующую информацию:
- Email адрес для создания учетной записи
- Данные о подписках и платежах
- Анонимизированные данные об использовании приложения
- Инвестиционные предпочтения (по вашему выбору)

2. Использование информации
Собранная информация используется для:
- Предоставления персонализированных инвестиционных аналитик
- Улучшения работы приложения
- Обеспечения безопасности вашего аккаунта
- Отправки уведомлений о важных рыночных событиях

3. Защита данных
Мы используем современные методы шифрования:
- Все данные передаются по защищенному HTTPS соединению
- Пароли хранятся в зашифрованном виде
- Персональные данные защищены от несанкционированного доступа

4. Третьи стороны
Мы не передаем ваши персональные данные третьим лицам, за исключением:
- Платежных систем для обработки подписок
- По требованию законодательства

5. Ваши права
Вы имеете право:
- Просматривать и обновлять свои данные
- Удалить аккаунт и все связанные данные
- Отказаться от сбора аналитических данных
- Экспортировать свои данные

6. Контакты
По вопросам конфиденциальности обращайтесь:
support@invest-analyst-pro.ru

Дата последнего обновления: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}
''';

  final String _termsOfUseText = '''
УСЛОВИЯ ИСПОЛЬЗОВАНИЯ
Приложение "Инвест-Аналитик Pro"

1. Общие положения
1.1. Настоящие Условия использования регулируют отношения между вами и приложением "Инвест-Аналитик Pro".
1.2. Используя приложение, вы соглашаетесь с настоящими Условиями.

2. Услуги приложения
2.1. Приложение предоставляет:
- Анализ фондового рынка
- Прогнозирование цен акций
- Инвестиционные рекомендации
- Портфельную аналитику

2.2. Все предоставляемые данные носят информационный характер и не являются финансовой рекомендацией.

3. Регистрация и учетная запись
3.1. Для доступа к полному функционалу требуется регистрация.
3.2. Вы обязуетесь предоставлять достоверную информацию при регистрации.
3.3. Вы несете ответственность за сохранность своих учетных данных.

4. Подписки и платежи
4.1. Приложение предлагает различные тарифные планы:
- Basic: бесплатный доступ к базовым функциям
- Standard: расширенный доступ к российским акциям
- Premium: полный доступ ко всем инструментам

4.2. Оплата подписок осуществляется через официальные магазины приложений.

5. Интеллектуальная собственность
5.1. Все права на приложение и его контент принадлежат разработчикам.
5.2. Запрещается копирование, модификация или распространение контента без разрешения.

6. Ограничение ответственности
6.1. Приложение не несет ответственности за:
- Инвестиционные решения, принятые на основе предоставленной информации
- Убытки, связанные с использованием приложения
- Технические сбои и перерывы в работе

7. Изменения условий
7.1. Мы оставляем право изменять Условия использования.
7.2. Об изменениях будет сообщено через приложение.

8. Прекращение использования
8.1. Вы можете прекратить использование приложения в любое время.
8.2. Мы оставляем право блокировать аккаунты за нарушение Условий.

Дата последнего обновления: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}
''';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isSmallScreen ? 16 : 24,
        vertical: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildEmailField(),
            SizedBox(height: widget.isSmallScreen ? 12 : 16),
            _buildPasswordField(),
            SizedBox(height: widget.isSmallScreen ? 12 : 16),
            _buildConfirmPasswordField(),
            SizedBox(height: widget.isSmallScreen ? 20 : 24),
            _buildRegisterButton(),
            SizedBox(height: widget.isSmallScreen ? 20 : 24),
            _buildTermsText(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'email'.tr(),
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Введите email';
        if (!value.contains('@')) return 'Введите корректный email';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'password'.tr(),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Введите пароль';
        if (value.length < 6)
          return 'Пароль должен содержать минимум 6 символов';
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'confirm_password'.tr(),
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined),
          onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Подтвердите пароль';
        if (value != _passwordController.text) return 'Пароли не совпадают';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: widget.isSmallScreen ? 48 : 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
              )
            : Text(
                'register'.tr(),
                style: TextStyle(
                    fontSize: widget.isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isSmallScreen ? 8 : 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: widget.isSmallScreen ? 12 : 14,
              ),
          children: [
            const TextSpan(
                text:
                    'Нажимая "Зарегистрироваться", вы соглашаетесь с нашими '),
            TextSpan(
              text: 'Условиями использования',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = _showTermsOfUse,
            ),
            const TextSpan(text: ' и '),
            TextSpan(
              text: 'Политикой конфиденциальности',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = _showPrivacyPolicy,
            ),
          ],
        ),
      ),
    );
  }
}

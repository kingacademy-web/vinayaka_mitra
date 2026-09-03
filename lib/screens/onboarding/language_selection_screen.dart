import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/language_provider.dart';
import '../home/home_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LangItem {
  final String code;
  final String name;
  final String nativeName;
  final String subtitle;
  final String flag;

  const _LangItem({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.subtitle,
    required this.flag,
  });
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late String _selectedCode;

  final List<_LangItem> _languages = const [
    _LangItem(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
      subtitle: 'సంపూర్ణ పూజా విధానం, హారతులు & మిత్ర మండలి నిర్వహణ',
      flag: '🇮🇳',
    ),
    _LangItem(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
      subtitle: 'षोडशोपचार पूजा, आरती संग्रह एवं गणेश उत्सव समिति',
      flag: '🇮🇳',
    ),
    _LangItem(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      subtitle: '16-Step Pooja, Harathis & Festival Committee Hub',
      flag: '🌐',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCode = context.read<LanguageProvider>().currentLanguage;
  }

  void _proceed() async {
    await context.read<LanguageProvider>().setLanguage(_selectedCode);
    if (!mounted) return;

    if (widget.isFromSettings) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Auspicious Deity Symbol
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceElevated : AppColors.goldSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.saffron, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.saffron.withOpacity(0.25),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🕉️',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Center(
                child: Text(
                  'శ్రీ వినాయక మిత్ర',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.saffron,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Vinayaka Chavithi Devotional & Committee Hub',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Header prompt
              Text(
                'మీ ప్రాధాన్య భాషను ఎంచుకోండి\nअपनी भाषा चुनें • Choose Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  color: isDark ? AppColors.royalGold : AppColors.deepGold,
                ),
              ),

              const SizedBox(height: 24),

              // Language Cards
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _languages[index];
                    final isSelected = _selectedCode == item.code;

                    return InkWell(
                      onTap: () {
                        setState(() => _selectedCode = item.code);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.darkSurfaceElevated : AppColors.goldSoft.withOpacity(0.6))
                              : (isDark ? AppColors.darkSurface : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.saffron : (isDark ? AppColors.darkBorder : Colors.grey.shade300),
                            width: isSelected ? 2.2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.saffron.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Text(
                              item.flag,
                              style: const TextStyle(fontSize: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.nativeName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? AppColors.saffron
                                              : (isDark ? AppColors.darkTextPrimary : Colors.black87),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${item.name})',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: item.code,
                              groupValue: _selectedCode,
                              activeColor: AppColors.saffron,
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCode = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                onPressed: _proceed,
                child: Text(
                  _selectedCode == 'te'
                      ? 'ముందుకు సాగండి (Continue) ➔'
                      : _selectedCode == 'hi'
                          ? 'आगे बढ़ें (Continue) ➔'
                          : 'Continue ➔',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

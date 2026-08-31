import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/recipe.dart';
import '../../services/firebase_service.dart';

class PrasadamScreen extends StatefulWidget {
  const PrasadamScreen({super.key});

  @override
  State<PrasadamScreen> createState() => _PrasadamScreenState();
}

class _PrasadamScreenState extends State<PrasadamScreen> {
  final FirebaseService _service = FirebaseService();
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final list = await _service.getRecipes();
    setState(() {
      _recipes = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('వినాయక నైవేద్యం & ప్రసాదాలు'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.saffron))
          : _recipes.isEmpty
              ? const Center(child: Text('ప్రసాదం వంటకాలు అందుబాటులో లేవు'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final r = _recipes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ExpansionTile(
                        initiallyExpanded: index == 0,
                        leading: CircleAvatar(
                          backgroundColor: isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.goldSoft,
                          child: const Icon(
                            Icons.restaurant_menu,
                            color: AppColors.saffron,
                          ),
                        ),
                        title: Text(
                          r.nameTe,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          r.nameEn,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Time & Servings chips
                                Row(
                                  children: [
                                    _InfoBadge(
                                      icon: Icons.timer_outlined,
                                      label: 'తయారీ: ${r.prepTime}',
                                    ),
                                    const SizedBox(width: 8),
                                    _InfoBadge(
                                      icon: Icons.local_fire_department_outlined,
                                      label: 'వంట: ${r.cookTime}',
                                    ),
                                    const SizedBox(width: 8),
                                    _InfoBadge(
                                      icon: Icons.people_outline,
                                      label: '${r.servings} మందికి',
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Sacred Significance
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkChip
                                        : AppColors.goldSoft.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.goldBorder.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: AppColors.saffron,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          r.significance,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.royalGold
                                                : AppColors.deepGold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Ingredients List
                                Text(
                                  'కావలసిన పదార్థాలు (Ingredients):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDark ? AppColors.royalGold : AppColors.maroon,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...r.ingredients.map(
                                  (ing) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('• ',
                                            style: TextStyle(
                                                color: AppColors.saffron,
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(
                                            ing,
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Instructions List
                                Text(
                                  'తయారీ విధానం (Preparation Steps):',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDark ? AppColors.royalGold : AppColors.maroon,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ...r.instructions.asMap().entries.map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(top: 2),
                                          decoration: const BoxDecoration(
                                            color: AppColors.saffron,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${entry.key + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.saffron),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

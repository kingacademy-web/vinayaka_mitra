import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/pooja_step.dart';
import '../../providers/pooja_provider.dart';

class PoojaVidhanamScreen extends StatefulWidget {
  const PoojaVidhanamScreen({super.key});

  @override
  State<PoojaVidhanamScreen> createState() => _PoojaVidhanamScreenState();
}

class _PoojaVidhanamScreenState extends State<PoojaVidhanamScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PoojaProvider>().load();
    });
  }

  void _showSamagriModal(BuildContext context, List<String> samagri) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '📦 కావలసిన పూజా ద్రవ్యాలు',
                    style: TextStyle(
                      fontFamily: 'NotoSansTelugu',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.royalGold : AppColors.deepGold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              if (samagri.isEmpty)
                const Text('ప్రత్యేక ద్రవ్యాలు అవసరం లేదు (అక్షింతలు/పువ్వులతో చేయవచ్చు)')
              else
                ...samagri.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: AppColors.greenAuspicious),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontFamily: 'NotoSansTelugu',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('పూజా ప్రగతిని రీసెట్ చేయాలా?'),
        content: const Text(
          'పూర్తయిన అన్ని పూజా దశల చెక్‌లిస్ట్ పునఃప్రారంభించబడుతుంది.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('రద్దు చేయండి'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.maroon),
            onPressed: () {
              context.read<PoojaProvider>().resetAllSteps();
              Navigator.pop(ctx);
            },
            child: const Text('రీసెట్ చేయండి'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PoojaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentStep = provider.currentStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('షోడశోపచార పూజా విధానం'),
        actions: [
          IconButton(
            tooltip: 'రీసెట్ పూజ',
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.saffron))
          : provider.steps.isEmpty
              ? const Center(child: Text('పూజా వివరాలు అందుబాటులో లేవు'))
              : Column(
                  children: [
                    // Top Progress Bar Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: isDark ? AppColors.darkSurface : AppColors.goldSoft.withOpacity(0.5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'దశ: ${provider.currentStepIndex + 1} / ${provider.steps.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${provider.completedStepsCount} పూర్తి అయ్యాయి',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.royalGold : AppColors.deepGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: provider.progressPercentage,
                              minHeight: 8,
                              backgroundColor: isDark ? AppColors.darkChip : Colors.grey.shade300,
                              color: AppColors.saffron,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Step Card
                    Expanded(
                      child: currentStep == null
                          ? const SizedBox.shrink()
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Step Title Banner
                                  Card(
                                    color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.saffron,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'దశ ${currentStep.stepNumber}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () => provider.toggleStepCompletion(
                                                  currentStep.stepNumber,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4),
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value: provider.isStepCompleted(
                                                          currentStep.stepNumber,
                                                        ),
                                                        activeColor: AppColors.greenAuspicious,
                                                        onChanged: (_) =>
                                                            provider.toggleStepCompletion(
                                                          currentStep.stepNumber,
                                                        ),
                                                      ),
                                                      const Text(
                                                        'పూర్తయింది',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            currentStep.nameTe,
                                            style: TextStyle(
                                              fontFamily: 'NotoSansTelugu',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: isDark
                                                  ? AppColors.royalGold
                                                  : AppColors.deepGold,
                                            ),
                                          ),
                                          Text(
                                            currentStep.nameEn,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Sanskrit Mantra Box
                                  Card(
                                    color: isDark
                                        ? const Color(0xFF261D12)
                                        : AppColors.goldSoft.withOpacity(0.4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.auto_stories,
                                                size: 18,
                                                color: AppColors.saffron,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'మంత్రం / శ్లోకం',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: isDark
                                                      ? AppColors.royalGold
                                                      : AppColors.deepGold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 16),
                                          SelectableText(
                                            currentStep.mantra,
                                            style: TextStyle(
                                              fontFamily: 'NotoSansTelugu',
                                              fontSize: 16,
                                              height: 1.8,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.deepMaroon,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Action Vidhi Box
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.task_alt,
                                                size: 18,
                                                color: AppColors.greenAuspicious,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'పూజా విధానం (చేయవలసిన పద్ధతి)',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: isDark
                                                      ? AppColors.royalGold
                                                      : AppColors.deepGold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(height: 16),
                                          Text(
                                            currentStep.vidhi,
                                            style: TextStyle(
                                              fontFamily: 'NotoSansTelugu',
                                              fontSize: 15,
                                              height: 1.7,
                                              color: isDark
                                                  ? AppColors.darkTextPrimary
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Samagri quick button
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.saffron),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    icon: const Icon(Icons.inventory_2_outlined,
                                        color: AppColors.saffron),
                                    label: const Text(
                                      'ఈ దశకు కావలసిన సామగ్రిని చూడండి',
                                      style: TextStyle(
                                        fontFamily: 'NotoSansTelugu',
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.saffron,
                                      ),
                                    ),
                                    onPressed: () => _showSamagriModal(
                                      context,
                                      currentStep.samagriRequired,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    // Bottom Navigation Bar for steps
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, -2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('మునుపటిది'),
                              onPressed: provider.currentStepIndex > 0
                                  ? provider.previousStep
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(
                                provider.currentStepIndex == provider.steps.length - 1
                                    ? 'పూజ పూర్తి'
                                    : 'తదుపరి దశ',
                              ),
                              onPressed: provider.currentStepIndex <
                                      provider.steps.length - 1
                                  ? () {
                                      provider.toggleStepCompletion(
                                        currentStep!.stepNumber,
                                      );
                                      provider.nextStep();
                                    }
                                  : () {
                                      provider.toggleStepCompletion(
                                        currentStep!.stepNumber,
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('🎉 శ్రీ వినాయక పూజ సంపూర్ణమైనది!'),
                                          backgroundColor: AppColors.greenAuspicious,
                                        ),
                                      );
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

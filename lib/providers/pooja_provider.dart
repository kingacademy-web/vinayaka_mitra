import 'package:flutter/material.dart';
import '../data/models/pooja_step.dart';
import '../services/firebase_service.dart';
import '../services/offline_cache_service.dart';

class PoojaProvider extends ChangeNotifier {
  final FirebaseService _service;
  final OfflineCacheService _cache = OfflineCacheService();

  List<PoojaStep> _steps = [];
  int _currentStepIndex = 0;
  bool _isLoading = false;

  PoojaProvider(this._service);

  List<PoojaStep> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  bool get isLoading => _isLoading;
  PoojaStep? get currentStep =>
      (_steps.isNotEmpty && _currentStepIndex < _steps.length)
          ? _steps[_currentStepIndex]
          : null;

  int get completedStepsCount =>
      _cache.getCompletedPoojaStepsCount(_steps.length);

  double get progressPercentage =>
      _steps.isEmpty ? 0.0 : completedStepsCount / _steps.length;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _steps = await _service.getPoojaSteps();
    _isLoading = false;
    notifyListeners();
  }

  void setCurrentStep(int index) {
    if (index >= 0 && index < _steps.length) {
      _currentStepIndex = index;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  bool isStepCompleted(int stepNumber) {
    return _cache.isPoojaStepCompleted(stepNumber);
  }

  Future<void> toggleStepCompletion(int stepNumber) async {
    final current = _cache.isPoojaStepCompleted(stepNumber);
    await _cache.setPoojaStepCompleted(stepNumber, !current);
    notifyListeners();
  }

  Future<void> resetAllSteps() async {
    await _cache.resetPoojaChecklist();
    _currentStepIndex = 0;
    notifyListeners();
  }
}

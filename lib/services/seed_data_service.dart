import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/harathi.dart';
import '../data/models/pathri.dart';
import '../data/models/pooja_step.dart';
import '../data/models/recipe.dart';
import '../data/models/vratha_katha.dart';

class SeedDataService {
  static final SeedDataService _instance = SeedDataService._internal();
  factory SeedDataService() => _instance;
  SeedDataService._internal();

  /// Loads bundled Harathulu from assets
  Future<List<Harathi>> loadHarathis() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/harathis.json');
      final list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => Harathi.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Loads 21 Sacred Pathri from assets
  Future<List<Pathri>> loadPathriList() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/pathri.json');
      final list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => Pathri.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Loads 16 Shodashopachara Pooja Steps from assets
  Future<List<PoojaStep>> loadPoojaSteps() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/pooja_steps.json');
      final list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => PoojaStep.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Loads festive Naivedyam Recipes from assets
  Future<List<Recipe>> loadRecipes() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/recipes.json');
      final list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => Recipe.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Loads Vratha Katha stories from assets
  Future<List<KathaChapter>> loadVrathaKatha() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/seed/vratha_katha.json');
      final list = json.decode(jsonStr) as List<dynamic>;
      return list.map((e) => KathaChapter.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }
}

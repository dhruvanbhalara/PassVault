import 'package:flutter/material.dart';

class AppColors {
  // ─────────────────────────────────────────────────────────────
  // Brand / Seed
  // ─────────────────────────────────────────────────────────────
  static const Color seed = Color(0xFF3F51B5); // Indigo

  // ─────────────────────────────────────────────────────────────
  // Light Mode
  // ─────────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightPrimary = Color(0xFF3F51B5);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  static const Color lightSecondary = Color(0xFF2CB9B0);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0xFF5F6368);

  static const Color lightDivider = Color(0xFFE0E3EB);

  // ─────────────────────────────────────────────────────────────
  // Dark Mode
  // ─────────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  static const Color darkPrimary = Color(0xFF8C9EFF); // Softer Indigo
  static const Color darkOnPrimary = Color(0xFF0F172A);

  static const Color darkSecondary = Color(0xFF64D8CB);
  static const Color darkOnSecondary = Color(0xFF00332F);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B3B8);

  static const Color darkDivider = Color(0xFF2C2C2E);

  // ─────────────────────────────────────────────────────────────
  // AMOLED (Opt-in)
  // ─────────────────────────────────────────────────────────────
  static const Color amoledBackground = Colors.black;
  static const Color amoledSurface = Color(0xFF121212);

  // ─────────────────────────────────────────────────────────────
  // Semantic Colors
  // ─────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);

  // Password strength
  static const Color strengthWeak = error;
  static const Color strengthFair = Color(0xFFF57C00); // Orange
  static const Color strengthGood = warning;
  static const Color strengthStrong = success;
}

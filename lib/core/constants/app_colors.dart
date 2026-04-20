class AppColors {
  static const Color background = Color(0xFF05070D);
  static const Color surface = Color(0xFF0B1020);
  static const Color surfaceVariant = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1A2235);

  // Neon Accents
  static const Color primaryNeon = Color(0xFF00E5FF);
  static const Color secondaryNeon = Color(0xFFFF3DF2);
  static const Color tertiaryNeon = Color(0xFF8B5CF6);
  static const Color accentLime = Color(0xFF00FF88);

  // Status
  static const Color success = Color(0xFF00FF88);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF00E5FF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Glass
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassFill = Color(0x0DFFFFFF);

  // Gradients
  static const LinearGradient neonCyanGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF00B8D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonMagentaGradient = LinearGradient(
    colors: [Color(0xFFFF3DF2), Color(0xFFE040FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A2235), Color(0xFF0B1020)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF05070D)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
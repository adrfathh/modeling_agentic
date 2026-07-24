// lib/features/admin_it/presentation/screens/kurikulum_screen.dart
import 'package:flutter/material.dart';
import 'package:attendance_app/core/theme/app_color_tokens.dart';
import 'package:attendance_app/core/theme/app_dimensions.dart';
import 'package:attendance_app/core/theme/app_text_styles.dart';

class KurikulumScreen extends StatelessWidget {
  const KurikulumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      ('Matematika', 'Bpk. Hendro, S.Pd.', 'XI IPA 2', AppColorTokens.activePrimary),
      ('Bahasa Indonesia', 'Ibu Siti, M.Pd.', 'XI IPA 1', AppColorTokens.attendApprove),
      ('Fisika', 'Bpk. Ari, S.Si.', 'X IPA 1', AppColorTokens.lateSickLeave),
      ('PKN', 'Ibu Ratna, S.H.', 'XII IPS 1', AppColorTokens.waitingFreeze),
      ('Seni Budaya', 'Bpk. Dimas, S.Sn.', 'X IPS 2', AppColorTokens.unavailableGray),
    ];

    return Scaffold(
      backgroundColor: AppColorTokens.surfaceApp,
      appBar: AppBar(title: const Text('Kurikulum & Jadwal')),
      body: ListView.builder(
        padding: AppDimensions.screenPadding,
        itemCount: subjects.length,
        itemBuilder: (_, i) {
          final (name, guru, kelas, color) = subjects[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorTokens.surfaceCard,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              boxShadow: AppDimensions.shadowCard,
              border: Border(left: BorderSide(color: color, width: 4)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: AppTextStyles.title1),
              const SizedBox(height: 4),
              Text(guru, style: AppTextStyles.label2),
              Text(kelas, style: AppTextStyles.caption),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColorTokens.activePrimary,
        child: const Icon(Icons.add_rounded, color: AppColorTokens.textOnPrimary),
      ),
    );
  }
}

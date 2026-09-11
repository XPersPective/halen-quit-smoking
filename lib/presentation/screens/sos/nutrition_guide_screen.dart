import 'package:flutter/material.dart';

import '../../../core/design/tokens.dart';
import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Anti-craving nutrition and hydration guide (Roadmap Faz E.2).
///
/// Explains the biological mechanisms of Vitamin C, urine pH/alkaline foods,
/// cold water vagal stimulation, and caffeine/sugar reduction.
class NutritionGuideScreen extends StatelessWidget {
  const NutritionGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nutritionGuideTitle),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HalenSpace.x5),
          children: [
            Text(
              l10n.nutritionGuideSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HalenSpace.x5),

            const _NutritionPillarCard(
              icon: Icons.water_drop_rounded,
              iconColor: HalenColors.skyBlue,
              title: '1. Buz Gibi Su & Maden Suyu (Vagus Uyarımı)',
              scientificBasis:
                  'Orofaringeal termoreseptörlerin uyarılması ve vagal tonus aktivasyonu.',
              body:
                  'Bir sigara isteği geldiğinde, bir bardak buz gibi suyu pipetle veya yudum yudum için.\n\n'
                  '• Soğuk su, boğaz ve ağızdaki nikotinik duyusal reseptörleri şaşırtır.\n'
                  '• Parasempatik sistemi (vagus siniri) aktive ederek yükselen kalp atımını ve anksiyeteyi dakikalar içinde düşürür.\n'
                  '• El ve ağız hareketini ikame ederek psikomotor boşluğu doldurur.',
            ),
            const SizedBox(height: HalenSpace.x4),

            const _NutritionPillarCard(
              icon: Icons.eco_rounded,
              iconColor: HalenColors.emerald,
              title: '2. Alkali Besinler (İdrar pH ve Nikotin Klirensi)',
              scientificBasis:
                  'Asidik idrar nikotin eliminasyonunu hızlandırırken, alkali pH nikotin seviyesini daha dengeli tutar (Beckett & Rowland, 1965).',
              body:
                  'Vücut asidik olduğunda böbrekler nikotini kandan hızla atar ve bu durum şiddetli, ani yoksunluk krizlerine yol açar.\n\n'
                  '• Salatalık dilimleri, kereviz sapı, çiğ badem, havuç ve yeşil yapraklı sebzeler idrarı alkaliye kaydırır.\n'
                  '• Bu sayede kandaki nikotin seviyesi sert bir uçurum yerine yumuşak bir eğriyle düşer ve krizler seyrekleşir.\n'
                  '• Yanınızda salatalık veya havuç çubukları bulundurmak kriz anında mükemmel bir çiğneme refleksidir.',
            ),
            const SizedBox(height: HalenSpace.x4),

            const _NutritionPillarCard(
              icon: Icons.local_florist_rounded,
              iconColor: HalenColors.amberCta,
              title: '3. C Vitamini Takviyesi (Antioksidan Kalkanı)',
              scientificBasis:
                  'Sigara dumanındaki serbest radikaller plazma askorbik asit (C vitamini) depolarını %30-50 tüketir.',
              body:
                  'Nikotin yoksunluğu vücutta akut bir stres tepkisi yaratır ve adrenal bezler yüksek miktarda C vitamini harcar.\n\n'
                  '• Taze sıkılmış limonlu ılık su, kivi, çilek, portakal ve kırmızı biber C vitamini depolarını hızla tazeler.\n'
                  '• Kortizol regülasyonunu destekleyerek yoksunluğun yarattığı tükenmişlik ve asabiyeti hafifletir.',
            ),
            const SizedBox(height: HalenSpace.x4),

            const _NutritionPillarCard(
              icon: Icons.warning_amber_rounded,
              iconColor: HalenColors.coral,
              title: '4. Kafein ve Rafine Şeker Uyarısı (Kritik Tuzak)',
              scientificBasis:
                  'Tütün dumanı karaciğerdeki CYP1A2 enzimini uyararak kafeini hızla parçalar; sigara bırakıldığında kafein klerensi %50 yavaşlar.',
              body:
                  'Sigarayı azalttığınızda veya bıraktığınızda:\n\n'
                  '• Kahve kanda iki kat daha uzun süre kalır! Normalde içtiğiniz kahve miktarı artık sizde taşikardi (çarpıntı), titreme ve panik yaratır. Çoğu kişi bu durumu nikotin krizi sanır; oysa aşırı kafein yüklenmesidir. Kahve tüketiminizi %50 azaltın.\n'
                  '• Basit şekerler (çikolata, şerbetli tatlılar) kan şekerinde ani zirveler ve çöküşler (reaktif hipoglisemi) oluşturarak dopamin açlığını ve sigara krizini azdırır. Şeker yerine lifli atıştırmalıklar tercih edin.',
            ),
            const SizedBox(height: HalenSpace.x6),
          ],
        ),
      ),
    );
  }
}

class _NutritionPillarCard extends StatelessWidget {
  const _NutritionPillarCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.scientificBasis,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String scientificBasis;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(HalenSpace.x5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(HalenSpace.x3),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: HalenSpace.x3),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HalenSpace.x3),
            Container(
              padding: const EdgeInsets.all(HalenSpace.x3),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.science_outlined, size: 16),
                  const SizedBox(width: HalenSpace.x2),
                  Expanded(
                    child: Text(
                      'Klinik Temel: $scientificBasis',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HalenSpace.x3),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

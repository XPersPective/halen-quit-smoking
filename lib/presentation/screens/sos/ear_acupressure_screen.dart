import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/design/tokens.dart';

/// The guided ear-acupressure round (module report §5.④).
///
/// Five points, twelve seconds each — the NADA set (Shen Men, Autonomic,
/// Kidney, Liver, Lung). Three constraints shaped this screen:
///  - **fingers only.** Needles are never suggested, and the line saying so
///    is always on screen, not buried in a footnote;
///  - **no anatomical photograph.** A stylised outline avoids both a
///    licensing problem and the medical-procedure look that would oversell
///    what this is;
///  - **the evidence label travels with it.** This is the ⚪ traditional tier:
///    short-term withdrawal data exists, long-term quitting benefit has not
///    been shown, and the screen says exactly that.
class EarAcupressureScreen extends StatefulWidget {
  const EarAcupressureScreen({super.key});

  @override
  State<EarAcupressureScreen> createState() => _EarAcupressureScreenState();
}

class _EarAcupressureScreenState extends State<EarAcupressureScreen> {
  static const _secondsPerPoint = 12;
  static const _pointCount = 5;

  int _elapsed = 0;
  bool _running = false;
  int _selectedPoint = 0;
  Timer? _ticker;

  int get _currentPoint => (_elapsed ~/ _secondsPerPoint).clamp(0, _pointCount - 1);
  int get _secondsLeftOnPoint =>
      _secondsPerPoint - (_elapsed % _secondsPerPoint);
  bool get _finished => _elapsed >= _secondsPerPoint * _pointCount;

  static const _pointInfo = [
    (
      title: 'Shen Men (Ruh Kapısı)',
      location: 'Kulağın üst üçgen çukuru (triangular fossa)',
      effect: 'Parasempatik sinir sistemini uyarır; kriz anındaki anksiyete, panik ve stres hormonlarını (kortizol) yatıştırır.',
      instruction: 'İşaret parmağınızla çukura hafifçe bastırıp küçük dairesel hareketler yapın. 4 sn nefes alırken bası uygulayın, 6 sn verirken gevşetin.',
    ),
    (
      title: 'Sempatik / Otonom Nokta',
      location: 'İç kıvrımın (helix kökünün) üst sınırı',
      effect: 'Vazokonstriksiyonu (damar daralmasını) çözer, nikotin düşüşüyle hızlanan nabzı ve bedensel gerginliği dengeler.',
      instruction: 'Parmak ucunuzla kıkırdak kenarına nazikçe bastırın. Nabzınızı dinleyin ve omuzlarınızı serbest bırakın.',
    ),
    (
      title: 'Böbrek Noktası (Kidney)',
      location: 'Concha çukurunun üst iç bölgesi',
      effect: 'Korku ve irade yorgunluğunu hafifletir; böbreklerin toksin ve katran atım metabolizmasını destekler.',
      instruction: 'Başparmağınız kulağın arkasında destek olsun, işaret parmağınızla concha çukurunun üstüne ritmik hafif bası yapın.',
    ),
    (
      title: 'Karaciğer Noktası (Liver)',
      location: 'Concha çukurunun orta-arka bölgesi',
      effect: 'Yoksunluk kaynaklı öfke, asabiyet, tahammülsüzlük ve dürtüsel sigara yakma arzusunu yatıştırır.',
      instruction: 'Concha\'nın arka duvarına dairesel masaj uygulayın. Bu bölge gergin olduğunda hafif hassas olabilir; acıtmadan uygulayın.',
    ),
    (
      title: 'Akciğer Noktası (Lung)',
      location: 'Concha kavitesinin merkez ve alt bölgesi',
      effect: 'Solunum yollarındaki hava açlığı spazmını gevşetir, nefesi derinleştirir ve rahatlatır.',
      instruction: 'Kulak deliğinin hemen yukarısına ve arkasına parmağınızı yerleştirin. Her nefes verişte basıyı hafifçe artırın.',
    ),
  ];

  void _start() {
    _ticker?.cancel();
    setState(() {
      _elapsed = 0;
      _running = true;
      _selectedPoint = 0;
    });
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        _elapsed += 1;
        if (_running) {
          _selectedPoint = _currentPoint;
        }
      });
      if (_finished) {
        timer.cancel();
        setState(() => _running = false);
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  List<String> _pointNames(AppLocalizations l10n) => [
        l10n.sosEarPointShenMen,
        l10n.sosEarPointAutonomic,
        l10n.sosEarPointKidney,
        l10n.sosEarPointLiver,
        l10n.sosEarPointLung,
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final names = _pointNames(l10n);
    final displayIndex = _running ? _currentPoint : _selectedPoint;
    final activeInfo = _pointInfo[displayIndex];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.earGuideTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(HalenSpace.x6),
          children: [
            Center(
              child: SizedBox(
                height: 220,
                width: 170,
                child: Semantics(
                  label: _running
                      ? l10n.earGuideStep(
                          names[_currentPoint],
                          _secondsLeftOnPoint,
                        )
                      : l10n.earGuideTitle,
                  excludeSemantics: true,
                  child: CustomPaint(
                    painter: _EarPainter(
                      activePoint: displayIndex,
                      isLight: theme.brightness == Brightness.light,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x4),

            // Clinical Point Insight Card
            Card(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              child: Padding(
                padding: const EdgeInsets.all(HalenSpace.x4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: HalenColors.emerald.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Nokta ${displayIndex + 1}/5',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: HalenColors.emerald,
                            ),
                          ),
                        ),
                        const SizedBox(width: HalenSpace.x2),
                        Expanded(
                          child: Text(
                            activeInfo.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HalenSpace.x2),
                    Text(
                      'Konum: ${activeInfo.location}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: HalenSpace.x2),
                    Text(
                      activeInfo.effect,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: HalenSpace.x2),
                    Container(
                      padding: const EdgeInsets.all(HalenSpace.x2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.touch_app_outlined, size: 16),
                          const SizedBox(width: HalenSpace.x2),
                          Expanded(
                            child: Text(
                              activeInfo.instruction,
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: HalenSpace.x4),

            for (var i = 0; i < _pointCount; i++)
              _PointRow(
                index: i,
                name: names[i],
                isSelected: i == displayIndex,
                state: !_running && !_finished
                    ? _PointState.idle
                    : i < _currentPoint || _finished
                        ? _PointState.done
                        : i == _currentPoint
                            ? _PointState.active
                            : _PointState.idle,
                secondsLeft: _secondsLeftOnPoint,
                onTap: () {
                  if (!_running) {
                    setState(() => _selectedPoint = i);
                  }
                },
              ),
            const SizedBox(height: HalenSpace.x5),
            if (_finished)
              Text(l10n.earGuideFinished, style: theme.textTheme.titleMedium)
            else
              FilledButton(
                onPressed: _running ? null : _start,
                child: Text(l10n.earGuideStart),
              ),
            const SizedBox(height: HalenSpace.x5),
            Text(
              l10n.sosNoNeedles,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: HalenSpace.x2),
            Text(
              '${l10n.evidenceTraditional} · ${l10n.evidenceLabel}',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

enum _PointState { idle, active, done }

class _PointRow extends StatelessWidget {
  const _PointRow({
    required this.index,
    required this.name,
    required this.state,
    required this.secondsLeft,
    required this.isSelected,
    required this.onTap,
  });

  final int index;
  final String name;
  final _PointState state;
  final int secondsLeft;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final active = state == _PointState.active;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: HalenSpace.x1, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: switch (state) {
                  _PointState.done =>
                    HalenColors.emerald.withValues(alpha: 0.25),
                  _PointState.active =>
                    HalenColors.petrol.withValues(alpha: 0.25),
                  _PointState.idle => isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.25)
                      : theme.dividerColor.withValues(alpha: 0.4),
                },
              ),
              child: state == _PointState.done
                  ? const Icon(Icons.check_rounded, size: 14)
                  : Text('${index + 1}', style: theme.textTheme.labelSmall),
            ),
            const SizedBox(width: HalenSpace.x3),
            Expanded(
              child: Text(
                active ? l10n.earGuideStep(name, secondsLeft) : name,
                style: active
                    ? theme.textTheme.titleSmall
                    : theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
              ),
            ),
            if (isSelected && !active)
              const Icon(Icons.info_outline, size: 16),
          ],
        ),
      ),
    );
  }
}

/// A stylised outer ear with the five NADA points — deliberately a drawing,
/// not a photograph or a clinical diagram.
class _EarPainter extends CustomPainter {
  _EarPainter({required this.activePoint, required this.isLight});

  final int activePoint;
  final bool isLight;

  /// Relative positions of the five points inside the ear outline.
  static const _points = <Offset>[
    Offset(0.46, 0.34), // Shen Men — upper triangular fossa
    Offset(0.38, 0.44), // Autonomic
    Offset(0.52, 0.52), // Kidney
    Offset(0.58, 0.44), // Liver
    Offset(0.50, 0.62), // Lung
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final tint = isLight ? HalenColors.petrol : HalenColors.mint;
    final w = size.width;
    final h = size.height;

    final outline = Path()
      ..moveTo(w * 0.62, h * 0.12)
      ..cubicTo(w * 0.28, h * 0.10, w * 0.16, h * 0.42, w * 0.26, h * 0.66)
      ..cubicTo(w * 0.33, h * 0.84, w * 0.48, h * 0.94, w * 0.62, h * 0.88)
      ..cubicTo(w * 0.72, h * 0.84, w * 0.70, h * 0.74, w * 0.62, h * 0.72);

    final helix = Path()
      ..moveTo(w * 0.58, h * 0.24)
      ..cubicTo(w * 0.38, h * 0.26, w * 0.32, h * 0.48, w * 0.40, h * 0.64)
      ..cubicTo(w * 0.46, h * 0.76, w * 0.56, h * 0.78, w * 0.60, h * 0.72);

    final stroke = Paint()
      ..color = tint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(outline, stroke);
    canvas.drawPath(
      helix,
      Paint()
        ..color = tint.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    for (var i = 0; i < _points.length; i++) {
      final centre = Offset(_points[i].dx * w, _points[i].dy * h);
      final isActive = i == activePoint;
      canvas.drawCircle(
        centre,
        isActive ? 11 : 6,
        Paint()
          ..color = (isActive ? HalenColors.amberCta : tint)
              .withValues(alpha: isActive ? 0.30 : 0.16),
      );
      canvas.drawCircle(
        centre,
        isActive ? 6 : 4,
        Paint()..color = isActive ? HalenColors.amberCta : tint,
      );
    }
  }

  @override
  bool shouldRepaint(_EarPainter old) =>
      old.activePoint != activePoint || old.isLight != isLight;
}

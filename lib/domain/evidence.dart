/// Evidence grading shown next to every technique and tip
/// (module report §5, §10).
///
/// Grading things HONESTLY — including saying "no good evidence" about the
/// herbal remedies users come looking for — is what makes the rest of the
/// app credible. The three levels are deliberately blunt.
library;

enum EvidenceLevel {
  /// Randomized trial or meta-analytic support.
  strong,

  /// Limited or short-term evidence only.
  promising,

  /// Traditional practice; evidence insufficient. Harmless, optional.
  traditional,
}

/// The channels a daily support card can come from (module report §10).
enum SupportChannel { movement, nutrition, ritual }

/// Content families for the daily card engine (module report §11).
///
/// [reality] cards carry negative information and therefore MUST ship an
/// action line: fear works only when paired with efficacy, so a reality card
/// without "what you can do" is rejected by the content lint.
enum ContentFamily { knowledge, reality, gain, motivation }

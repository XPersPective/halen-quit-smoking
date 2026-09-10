import 'package:flutter/foundation.dart' show immutable;

import '../../domain/cessation.dart';
import 'library_repository.dart' show L10nText;

/// Stop-smoking medicines, as information and a referral (premium brief §C.1).
///
/// This was the single largest gap in the product: nicotine replacement
/// therapy roughly halves again the odds of stopping, varenicline more than
/// doubles them, and the app had not mentioned any of it. A quit-smoking app
/// that never says "there are medicines for this" is withholding the most
/// effective thing available to its user.
///
/// The boundary this file holds:
///
///  * **information, never a prescription.** No brands, no doses, no
///    "you should take". Every entry ends at the same place: talk to a
///    pharmacist or a doctor.
///  * **the comparator travels with the number.** A risk ratio without
///    "compared to what" is a marketing figure, so each entry names its
///    comparator explicitly.
///  * **the common mistake is named.** Under-dosing and stopping too early
///    are why NRT fails for most people who try it, and that is more useful
///    to a user than another sentence about how it works.
@immutable
class MedicineEntry {
  const MedicineEntry({
    required this.medicine,
    required this.name,
    required this.howItWorks,
    required this.typicalUse,
    required this.commonMistake,
    required this.source,
  });

  final StopSmokingMedicine medicine;
  final L10nText name;
  final L10nText howItWorks;

  /// How it is normally used — descriptive, never a dose instruction.
  final L10nText typicalUse;

  /// What most often goes wrong with it.
  final L10nText commonMistake;

  final String source;

  double get riskRatio => MedicineEvidence.riskRatio[medicine]!;

  bool get needsPrescription => MedicineEvidence.needsPrescription(medicine);

  bool get comparesToSingleNrt =>
      MedicineEvidence.comparesToSingleNrt(medicine);
}

/// The catalogue. Small on purpose: five NRT forms, the combination, and the
/// two prescription options that exist in most markets.
class MedicineRepository {
  const MedicineRepository();

  static const _cochraneNrt =
      'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD000146.pub5/full';
  static const _cochraneCombination =
      'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD013308.pub2/full';
  static const _cochraneVarenicline =
      'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD006103.pub8/full';
  static const _cochraneBupropion =
      'https://www.cochranelibrary.com/cdsr/doi/10.1002/14651858.CD000031.pub6/full';

  List<MedicineEntry> all() => const [
        MedicineEntry(
          medicine: StopSmokingMedicine.nicotinePatch,
          name: L10nText(
            en: 'Nicotine patch',
            tr: 'Nikotin bandı',
            de: 'Nikotinpflaster',
          ),
          howItWorks: L10nText(
            en: 'Releases a steady level of nicotine through the skin all '
                'day, so the background craving never builds.',
            tr: 'Gün boyu deriden sabit düzeyde nikotin salar; arka plandaki '
                'istek hiç birikmez.',
            de: 'Gibt den ganzen Tag gleichmäßig Nikotin über die Haut ab, '
                'sodass das Grundverlangen gar nicht erst aufbaut.',
          ),
          typicalUse: L10nText(
            en: 'One patch a day, applied in the morning, for 8-12 weeks.',
            tr: 'Günde bir bant, sabah yapıştırılır, 8-12 hafta boyunca.',
            de: 'Ein Pflaster täglich, morgens aufgeklebt, 8-12 Wochen lang.',
          ),
          commonMistake: L10nText(
            en: 'Stopping after two weeks because it "did not work". The '
                'patch handles the background, not the sudden craving — that '
                'is what a fast form is for.',
            tr: '"İşe yaramadı" diye iki hafta sonra bırakmak. Bant arka '
                'planı tutar, ani isteği değil — onun için hızlı bir form '
                'gerekir.',
            de: 'Nach zwei Wochen abbrechen, weil es „nicht wirkt". Das '
                'Pflaster deckt den Grundpegel ab, nicht das plötzliche '
                'Verlangen — dafür ist eine schnelle Form da.',
          ),
          source: _cochraneNrt,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.nicotineGum,
          name: L10nText(
            en: 'Nicotine gum',
            tr: 'Nikotin sakızı',
            de: 'Nikotinkaugummi',
          ),
          howItWorks: L10nText(
            en: 'Nicotine is absorbed through the lining of the mouth within '
                'minutes, so it meets a craving while it is happening.',
            tr: 'Nikotin dakikalar içinde ağız mukozasından emilir; isteği '
                'tam olurken karşılar.',
            de: 'Nikotin wird binnen Minuten über die Mundschleimhaut '
                'aufgenommen und trifft das Verlangen, während es da ist.',
          ),
          typicalUse: L10nText(
            en: 'One piece when a craving comes, chewed slowly and parked '
                'against the cheek.',
            tr: 'İstek geldiğinde bir adet; yavaş çiğnenip yanağa yaslanır.',
            de: 'Ein Stück bei Verlangen, langsam kauen und in die '
                'Wangentasche legen.',
          ),
          commonMistake: L10nText(
            en: 'Chewing it like ordinary gum. Fast chewing sends the '
                'nicotine to the stomach, where it does nothing but cause '
                'hiccups and heartburn.',
            tr: 'Normal sakız gibi çiğnemek. Hızlı çiğneme nikotini mideye '
                'gönderir; orada hıçkırık ve mide yanmasından başka bir şey '
                'yapmaz.',
            de: 'Wie normalen Kaugummi kauen. Schnelles Kauen schickt das '
                'Nikotin in den Magen, wo es nur Schluckauf und Sodbrennen '
                'macht.',
          ),
          source: _cochraneNrt,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.nicotineLozenge,
          name: L10nText(
            en: 'Nicotine lozenge',
            tr: 'Nikotin pastili',
            de: 'Nikotinlutschtablette',
          ),
          howItWorks: L10nText(
            en: 'Like the gum, but dissolved rather than chewed — easier for '
                'anyone with jaw trouble or dental work.',
            tr: 'Sakız gibi ama çiğnenmez, erir — çene sorunu veya diş '
                'işi olanlar için daha kolay.',
            de: 'Wie der Kaugummi, aber gelutscht statt gekaut — leichter '
                'bei Kieferproblemen oder Zahnersatz.',
          ),
          typicalUse: L10nText(
            en: 'Let it dissolve slowly; do not chew or swallow it.',
            tr: 'Yavaşça erimeye bırakılır; çiğnenmez, yutulmaz.',
            de: 'Langsam lutschen lassen; nicht kauen oder schlucken.',
          ),
          commonMistake: L10nText(
            en: 'Using too few. Most people use fewer than the packet '
                'allows and then conclude it does not help.',
            tr: 'Çok az kullanmak. Çoğu kişi kutunun izin verdiğinden azını '
                'kullanıp "fayda etmiyor" sonucuna varır.',
            de: 'Zu wenige nehmen. Die meisten bleiben unter der zulässigen '
                'Menge und schließen dann, es helfe nicht.',
          ),
          source: _cochraneNrt,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.nicotineSpray,
          name: L10nText(
            en: 'Mouth spray',
            tr: 'Ağız spreyi',
            de: 'Mundspray',
          ),
          howItWorks: L10nText(
            en: 'The fastest form available without a prescription — it acts '
                'in about a minute, which is roughly craving speed.',
            tr: 'Reçetesiz alınabilen en hızlı form — yaklaşık bir dakikada '
                'etki eder, ki bu aşağı yukarı isteğin hızıdır.',
            de: 'Die schnellste rezeptfreie Form — wirkt in etwa einer '
                'Minute, ungefähr im Tempo des Verlangens.',
          ),
          typicalUse: L10nText(
            en: 'Sprayed against the inside of the cheek, not inhaled.',
            tr: 'Yanağın içine sıkılır, solunmaz.',
            de: 'In die Wange sprühen, nicht einatmen.',
          ),
          commonMistake: L10nText(
            en: 'Spraying towards the throat, which stings and puts people '
                'off it on day one.',
            tr: 'Boğaza doğru sıkmak; yakar ve insanı daha ilk gün soğutur.',
            de: 'Richtung Rachen sprühen — das brennt und vergrault viele '
                'schon am ersten Tag.',
          ),
          source: _cochraneNrt,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.nicotineInhalator,
          name: L10nText(
            en: 'Inhalator',
            tr: 'İnhalatör',
            de: 'Inhalator',
          ),
          howItWorks: L10nText(
            en: 'A plastic holder with a nicotine cartridge. It keeps the '
                'hand-to-mouth habit, which for some people is most of it.',
            tr: 'Nikotin kartuşlu plastik bir tutamak. El-ağız alışkanlığını '
                'korur; bazıları için asıl mesele zaten odur.',
            de: 'Ein Kunststoffhalter mit Nikotinkartusche. Er erhält die '
                'Hand-zum-Mund-Gewohnheit, die für manche der Kern ist.',
          ),
          typicalUse: L10nText(
            en: 'Puffed shallowly into the mouth over about twenty minutes.',
            tr: 'Yaklaşık yirmi dakika boyunca ağza doğru yüzeysel çekilir.',
            de: 'Etwa zwanzig Minuten lang flach in den Mund gezogen.',
          ),
          commonMistake: L10nText(
            en: 'Inhaling deeply like a cigarette. The nicotine is absorbed '
                'in the mouth, not the lungs.',
            tr: 'Sigara gibi derin çekmek. Nikotin ağızda emilir, akciğerde '
                'değil.',
            de: 'Tief inhalieren wie bei einer Zigarette. Das Nikotin wird '
                'im Mund aufgenommen, nicht in der Lunge.',
          ),
          source: _cochraneNrt,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.combinationNrt,
          name: L10nText(
            en: 'Patch plus a fast form',
            tr: 'Bant + hızlı bir form',
            de: 'Pflaster plus schnelle Form',
          ),
          howItWorks: L10nText(
            en: 'The patch covers the background all day; the gum, lozenge '
                'or spray covers the spikes. Together they beat either one '
                'alone.',
            tr: 'Bant gün boyu arka planı kapatır; sakız, pastil veya sprey '
                'tepeleri karşılar. İkisi birlikte, tek başına her birinden '
                'daha iyidir.',
            de: 'Das Pflaster deckt den Grundpegel, Kaugummi, Lutschtablette '
                'oder Spray die Spitzen. Zusammen schlagen sie jede Form '
                'für sich.',
          ),
          typicalUse: L10nText(
            en: 'The usual starting point for anyone who smokes heavily or '
                'reaches for one soon after waking.',
            tr: 'Yoğun içen ya da uyandıktan kısa süre sonra sigaraya uzanan '
                'herkes için olağan başlangıç noktası.',
            de: 'Der übliche Einstieg für alle, die viel rauchen oder kurz '
                'nach dem Aufwachen zur ersten greifen.',
          ),
          commonMistake: L10nText(
            en: 'Treating it as "too much". Under-treatment is the far more '
                'common error, and it is the one that ends attempts.',
            tr: 'Bunu "fazla" saymak. Asıl yaygın hata az tedavi etmektir ve '
                'denemeleri bitiren de odur.',
            de: 'Es für „zu viel" halten. Unterdosierung ist der weitaus '
                'häufigere Fehler — und der, an dem Versuche scheitern.',
          ),
          source: _cochraneCombination,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.varenicline,
          name: L10nText(
            en: 'Varenicline',
            tr: 'Vareniklin',
            de: 'Vareniclin',
          ),
          howItWorks: L10nText(
            en: 'A tablet that both eases withdrawal and blunts the reward '
                'from smoking. The most effective single medicine there is.',
            tr: 'Hem yoksunluğu hafifleten hem de sigaranın verdiği ödülü '
                'körelten bir tablet. Tek başına en etkili ilaç.',
            de: 'Eine Tablette, die Entzug lindert und die Belohnung des '
                'Rauchens dämpft. Das wirksamste Einzelmedikament.',
          ),
          typicalUse: L10nText(
            en: 'Started a week or two before the quit date and continued '
                'for about twelve weeks.',
            tr: 'Bırakma tarihinden bir-iki hafta önce başlanır, yaklaşık '
                'on iki hafta sürdürülür.',
            de: 'Ein bis zwei Wochen vor dem Rauchstopp begonnen und etwa '
                'zwölf Wochen fortgeführt.',
          ),
          commonMistake: L10nText(
            en: 'Not asking about it. It is prescription-only, so it never '
                'comes up unless the person raises it.',
            tr: 'Hiç sormamak. Reçeteye tabidir; kişi kendisi açmazsa gündeme '
                'gelmez.',
            de: 'Nicht danach fragen. Es ist verschreibungspflichtig und '
                'kommt sonst nie zur Sprache.',
          ),
          source: _cochraneVarenicline,
        ),
        MedicineEntry(
          medicine: StopSmokingMedicine.bupropion,
          name: L10nText(
            en: 'Bupropion',
            tr: 'Bupropion',
            de: 'Bupropion',
          ),
          howItWorks: L10nText(
            en: 'A tablet that reduces the urge to smoke. An alternative when '
                'varenicline is not suitable.',
            tr: 'Sigara isteğini azaltan bir tablet. Vareniklin uygun '
                'olmadığında bir seçenek.',
            de: 'Eine Tablette, die den Rauchdrang senkt. Eine Alternative, '
                'wenn Vareniclin nicht infrage kommt.',
          ),
          typicalUse: L10nText(
            en: 'Started before the quit date, like varenicline.',
            tr: 'Vareniklin gibi, bırakma tarihinden önce başlanır.',
            de: 'Wie Vareniclin vor dem Rauchstopp begonnen.',
          ),
          commonMistake: L10nText(
            en: 'Assuming any tablet suits anyone. It interacts with several '
                'conditions and medicines, which is exactly why a clinician '
                'chooses it.',
            tr: 'Her tabletin herkese uyduğunu sanmak. Birçok hastalık ve '
                'ilaçla etkileşir; hekimin seçmesinin sebebi tam da budur.',
            de: 'Annehmen, jede Tablette passe zu jedem. Es hat mehrere '
                'Wechselwirkungen — genau deshalb wählt eine Fachkraft aus.',
          ),
          source: _cochraneBupropion,
        ),
      ];

  /// Over-the-counter forms, for someone who wants to start this week.
  List<MedicineEntry> overTheCounter() =>
      all().where((e) => !e.needsPrescription).toList();

  /// Prescription options, always shown behind a "ask a clinician" frame.
  List<MedicineEntry> prescriptionOnly() =>
      all().where((e) => e.needsPrescription).toList();

  MedicineEntry byMedicine(StopSmokingMedicine medicine) =>
      all().firstWhere((e) => e.medicine == medicine);
}

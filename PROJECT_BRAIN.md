<!-- project-brain:v1 -->
# PROJECT BRAIN — Halen: Quit Smoking Tracker

> **Status:** T7 kapandı: Today rozeti (deneme/premium/ücretsiz) + Widget ayarları native store'a yazıyor; Android launcher widget'ı koyu tema kanıtlı.
> **Phase:** BUILD · **Next:** T8 · **Updated:** 2026-09-18 · **Synced@:** cd46eec
> **Goal:** v1 #36ffac52 · **Goal status:** CONFIRMED

## 0. PROTOCOL

Binding for every AI working in this repo. Only the user edits §0 and §1. Section headings are machine anchors: never rename them. `brain.py` = `python <project-brain skill dir>/scripts/brain.py`; if unavailable, do its checks by hand.

### 0.1 What this file is
The single source of truth for this project. Chat history is disposable; this file is not. Cycle: **read → work → verify → update this file → commit → next.** If it is not written here, the next model does not know it.

### 0.2 Run loop (never stop early)
1. Session start: read header, §0, §1, §7 → run audit **A1** (§0.4).
2. Loop without pausing: pick task (§0.5) → do it → verify and close it (§0.8) → commit → immediately pick the next one. Never stop to report after a task. Never ask "shall I continue?". Never ask the user anything.
3. A §5 section fully closed → audit **A3**. No open tasks left (ignoring `[!]`) → audit **A4**. Audits that find problems create tasks and the loop continues.
4. Stop only when: **Phase: DONE** (A4 passed), or every remaining open task is `[!]` (then list them in §7). Before any stop: update §7, commit, push.
5. Context getting long is not a reason to stop: everything needed is in this file; after each commit keep only header, §0, §7 and the current task in mind. But if the harness warns the context/session is about to end → reach the next safe point (close or wip-commit the current task, update §7, commit+push). Never lose state mid-task.
6. One active session per project. Foreign commits or a moved `Synced@` = another worker was here: reconcile via A1 deep audit; never overwrite or revert their commits without evidence.

### 0.3 Token discipline (quality is never the trade)
- Read: header, §0, §1, §7 every session; other sections only when needed. Search (grep/glob) before opening files; open line ranges of big files; never re-read what you just wrote.
- Tool output: always filtered/limited (`tail`, `grep`, quiet flags). Never pull lockfiles, logs, build output or generated code into context.
- Batch independent tool calls in parallel.
- Chat: no preamble, no restating the task, no diff recaps; ≤3 lines. Detail belongs in this file.
- This file: terse fragments, `path:symbol` references instead of pasted code, each fact in one place. Exception: task specs (§0.7), audit evidence and revision rationale are explicit, never terse.
- Never write secrets, credentials, tokens or personal data into this file (it is committed and read by future models). Reference env var names only.
- Code: reuse existing code > stdlib > installed dependency > new code. Smallest diff that fixes the root cause. No speculative abstractions.
- Deliberate in proportion to tier: `[L]` act, `[M]` plan briefly, `[H]` think fully. Audits and revisions are always `[H]`.
- Never cut: correctness, running verification, audits, security, input validation, error handling that prevents data loss.

### 0.4 Audits (trust nothing unverified, including your predecessor)
Record every audit as an `AUDIT` row in §6: which audit, what was checked, result, task IDs created. Every finding becomes a task (§0.7) with `Note: from A<n>`.

**A0 — Creation** (right after this file is created, before any build task)
1. `brain.py check` passes with no FAIL; §4 matches reality.
2. Every §3 claim names the code that proves it; open 3 of them and confirm.
3. Traceability: every part of §2 missing or partial in §3 has a `GAP:` line naming task IDs; every acceptance criterion `AC<n>` is served by at least one task.
4. Executability probe: reread the first 5 open tasks as a model with zero chat history (or ask a cheap sub-agent to list what is ambiguous without doing them). Fix every ambiguity.

**A1 — Takeover** (every session start)
1. `brain.py check`; fix FAIL lines first. Its `NEXT:` line tells you what to do.
2. Sample: the last 3 closed tasks (check prints `VERIFY:`). For each: rerun `Done when`, read its diff (`git log --grep "T<id>"` → `git show`), confirm the diff really does what the task said, tests really assert, no debug/TODO leftovers, no unrelated edits.
3. Run the project's full test suite (and build/lint if present) once.
4. **Escalate to deep audit** if any of: a sample or the suite fails · commits outside protocol · map drift · goal hash changed · no previous `AUDIT` row · last closed tasks were done by a weaker model than you on `[M]`/`[H]` work. Deep audit = step 2 for every `[x]` since the last passing A1/A3/A4, plus spot-check §3 against code.
5. Wrong `[x]` → reopen as `[ ]` with `Note: reopened by A1 — <why>`, or add a fix task if other work already builds on it.
6. `Phase: DONE` and nothing new requested → steps 1–3 only; all pass → report done in ≤3 lines and stop.

**A2 — Task close** (every task; part of §0.8)
1. Run `Done when` yourself. A sub-agent's report is not verification.
2. Self-review your full diff: matches `Do`; edge cases and error paths handled; no unrelated edits; no debug/TODO leftovers; tests fail if the code is broken.
3. Tests/lint for the touched area pass (no regressions).
4. `[H]` tasks, security-relevant tasks and tasks done by sub-agents → independent review in a fresh context (sub-agent of at least the executor's tier) if the harness allows; otherwise a second self-review after rereading the task and the relevant §2 part.

**A3 — Milestone** (a §5 section just closed)
Full test suite + build. Compare that area of §3 with §2 in code; delete resolved `GAP:` lines; findings → tasks.

**A4 — Final** (no open tasks except `[!]`) — set `Phase: AUDIT`, then:
1. Clean build, full test suite, lint/typecheck: all pass.
2. Each `AC<n>`: prove it with a command or observable behaviour; tick it in §1 only with that evidence written in the `AUDIT` row.
3. §3 equals §2: no `GAP:` lines; walk §2 component by component and confirm each in code.
4. §1 constraints respected; nothing from "Out of scope" was built.
5. Whole-change review (`git diff <first brain commit>..HEAD`, area by area, fresh context if possible): security, error handling, dead code, duplication, leftover TODO/FIXME/debug, README/docs match reality.
6. `brain.py check` prints `OK`.
Any failure → tasks, `Phase: BUILD`, continue the loop. All pass → `Phase: DONE`, `Next: none`, summary in §7, commit `chore(brain): A4 final audit passed`.

### 0.5 Choosing and doing work
- One task at a time. Next = the `[~]` task if any, else the first `[ ]` in §5 order whose `Needs:` are all `[x]`. Mark it `[~] (claimed YYYY-MM-DD)` before starting.
- Everything must serve §1 and move §3 toward §2. A task that contradicts §1/§2 → do not do it; fix the plan via §0.9.
- Needs a human (credentials, payment, product/legal decision, destructive or irreversible action such as force-push, dropping data, prod deploy) → `[!] <reason>`, continue with the next task.
- Ambiguity → choose the conservative option, log an `ASSUMPTION` row in §6, continue.
- **Goal status: DRAFT** → only goal-independent tasks (map, audit, tests, bugs, build). Never build speculative features.

### 0.6 Discoveries while working (focus rule)
- **Blocks the current task** → add sub-task `T<id>.<n>` under it and do it now.
- **Serves the goal but does not block** → write a complete task (§0.7) under the matching §5 section, then **return to the current task immediately**. Do not start it; no "while I'm here" fixes.
- **Plan itself looks wrong** → finish or safely pause the current task, then apply §0.9.
- **Outside the goal** → one `OUT-OF-SCOPE` row in §6. Not a task.

### 0.7 Task format (write for a weaker model with zero chat history)
```
- [ ] T12 [L] Add Turkish date parser
  - Where: `src/utils/date.py` (new function next to `parse_iso`)
  - Do: 1) add `parse_tr_date(s: str) -> date` for "16.09.2026"; 2) raise `ValueError` on bad input; 3) add cases to `tests/test_date.py`
  - Done when: `pytest tests/test_date.py -q` passes
  - Needs: T11
```
- IDs are permanent: never renumber or reuse. New top-level task = highest ID + 1; sub-task = `T12.1`.
- Status: `[ ]` open · `[~]` in progress · `[x]` done · `[!]` blocked (reason) · `[-]` dropped (reason, e.g. `superseded by R2`).
- Tier: `[L]` mechanical, fully specified, no judgment · `[M]` clear spec, normal engineering · `[H]` design, ambiguity, security, audits, writing specs for others.
- `Where`, `Do`, `Done when` are mandatory for open tasks. Exact paths, symbol names, commands, expected output. Forbidden vague words: "etc.", "improve", "clean up", "as discussed", "handle properly". Cannot be that precise → tag `[H]` or split.
- `Done when` must be objectively checkable and must include a test or check that fails if the work is wrong.

### 0.8 Closing a task (all steps, one commit)
1. Audit A2 (§0.4). Fails → not done; fix, or reopen with a `Note:`.
2. Mark `[x] (YYYY-MM-DD, <model name>)`. Delete its `Where`/`Do` lines; keep `Done when`; add `→ <one-line result>` if useful.
3. Behaviour, interfaces, data flow or dependencies changed → update §3 (and its `GAP:` lines). Files added/removed/moved → update §4.
4. Header: Status, Phase, Next, Updated, and `Synced@` = `git rev-parse --short HEAD` taken **before** this commit.
5. Overwrite §7 (≤5 lines).
6. Commit code + this file together: `<type>(T<id>): <summary>` (feat/fix/refactor/test/docs/chore). Push to the current branch if a remote exists. Never force-push, never skip hooks. Push fails → keep the local commit, note it in §7, continue.
- Stopping mid-task → commit `wip(T<id>): <state>`, keep `[~]`, describe exactly what remains in §7.
- A task found broken after closing → reopen per §0.9a and repair with a new commit (`git revert` or smallest fix). Never rewrite history.
- No git → skip commits and git checks; everything else still applies.
- Brain-only commits (audits, revisions, goal changes): `docs(brain): <A<n>|R<n>|G<n>> <summary>`.

### 0.9 Changing the plan
**a) Task spec wrong or incomplete** (no architecture change): open task → edit in place and add `Note: revised YYYY-MM-DD — <why>`. Closed task whose result is wrong → reopen, or add a fix task if later work depends on it.

**b) Target architecture (§2) wrong** — any model may revise it autonomously, only through this gate:
1. Evidence, not taste: show that §2 cannot meet §1, violates a §1 constraint, or is demonstrably worse against §1 (cite files, measurements, docs, failing tests). "I would design it differently" is not evidence.
2. Never changes §1.
3. Reversing an earlier `DECISION`/`REVISION` requires new evidence that the earlier row did not have; cite that row.
4. Smallest revision that fixes the problem.
5. Log a `REVISION` row `R<n>`: problem + evidence, options considered, choice, impact.
6. Impact analysis over **every** task: keep · edit · drop as `[-] superseded by R<n>` · new tasks; closed work that no longer fits → migration/removal tasks.
7. Update §2, §3 `GAP:` lines, header; commit `docs(brain): R<n> <summary>`; continue the loop.

**c) Goal (§1) changed by the user** — in chat, or detected because `brain.py check` reports the goal hash changed:
1. If told in chat, write the new goal into §1 exactly as the user stated it (fill format gaps conservatively, log `ASSUMPTION`s).
2. Log a `GOAL-CHANGE` row `G<n>`: old goal summary → new goal summary. Header: `Goal: v<n+1> #<brain.py goal-hash>`, `Goal status: CONFIRMED`, `Phase: BUILD`.
3. Redesign §2 for the new goal (a REVISION per §0.9b, citing G<n>).
4. Impact analysis over every task as in b.6, including built features the new goal no longer wants (remove only if they conflict with the new goal or its constraints).
5. Run A0 steps 3–4 on the new plan. Commit `docs(brain): G<n> goal change`. Continue the loop.

**d) Goal itself looks flawed** (contradictory, impossible, clearly harmful to the user's intent): never edit §1. Log a `GOAL-CONCERN` row with evidence. Follow the most faithful feasible interpretation (logged as `ASSUMPTION`); tasks that truly cannot be done → `[!]`. Continue everything else.

### 0.10 Keeping this file small
When this file exceeds ~500 lines: move fully completed §5 sections to `PROJECT_BRAIN.archive.md` (append, dated) and leave one line `- [x] T1–T9 <section> → archive`. Move superseded §6 rows there too. Never archive open tasks, active decisions or the latest AUDIT row.

## 1. GOAL

Android ve iOS'ta yayınlanabilecek premium kalitede, sigara bırakmaya yardımcı,
bilimsel kaynak ve hesap sınırlarını açık sunan Halen: Quit Smoking Tracker geliştir.
Kullanıcının bütün eleştirilerini uygula; mevcut ve yeni hataları kök nedeninde düzelt,
test/gerçek cihaz/görsel denetimle kanıtla. Açık kaynak faydasını iyi anlat; GPL seçiminin
ticari dağıtıma izin verdiğini saklama. Ödeme native App Store/Google Play, ömür boyu
reklamsız seçenek; ilk7 gün tüm uygulanmış premium özellikler ve reklamsız kullanım.
Bütün işlerin protokol/mimari/yol haritası tek bu dosyada, düşük modelin devralabileceği
açıklıkta kalır. Gereksiz bağımlılık/boilerplate yok; mevcut kullanıcı değişiklikleri korunur.

**Acceptance criteria**
- [ ] AC1 Başlangıç: ücretsiz ve isteğe bağlı gerçek bildirim durumu, geri gezinme; günlük20/paket20, boş zorunlu fiyat/marka, yaş/TTFC/ritim/boy/kilo/süre, sağlam tüm girdi sınırları → T2,T4,T5,T6.
- [ ] AC2 Güven ve veri: JSON trial yenileyemez; tam yedek/rollback/veri silme; yerel şifreleme ve dürüst gizlilik → T3,T6,T26.
- [ ] AC3 Ürün UX: doğru bölge hattı/yeşil eylem, marka/ikon/premium rozeti, gerçek widget özelleştirme, açık kayıt/undo, dengeli organlar ve görünür sağlık çizelgesi → T1,T7–T11.
- [ ] AC4 Bilim: bütün grafiklerde birim/dönem/formül/kaynak/sınır; his beyanı tahminden ayrı; açık plan adımı/günlük grafik; bilinmeyen gün tasarruf değil; tarihsel tahmin ayrı → T12–T15.
- [ ] AC5 İçerik/tasarım: üç dil, okunur alternatif teknik görselleri ve rehberler, kanıt etiketi, iğnesiz kulak rehberi; sistem tema/Inter/erişilebilirlik/reduced motion → T16–T18.
- [ ] AC6 Yayın: GPL tam metni/lisans uyumu, fayda odaklı Hakkında; güvenilir IAP/restore/iptal; ölçülü uyumlu reklam ve consent; doğru mağaza/hukuk beyanları → T19–T21,T24.
- [ ] AC7 Teslim: tek brain, kaynak deposunda paket/sır yok, temiz build/test/lint, Android/iOS gerçek cihaz ve imzalı sürüm, bütün AC'ler kanıtlı → T22,T23,T25.

**Constraints:** Flutter/Dart/Riverpod/Drift; TR/EN/DE; Ponytail ultra; hesap olmadan yerel çekirdek;
mağaza ve hukuk kurallarına uyum; klinik ölçüm/tanı/garanti uydurma yok; GPL ticari yasak değildir.
**Out of scope:** otomatik arama, sigara/paket almaya teşvik, sağlık verisiyle reklam hedefleme,
izinsiz depo görünürlüğü/yayın, test kanıtı olmadan hatasızlık iddiası.
**Open questions:** none

## 2. TARGET ARCHITECTURE

Hedef doğrudan kullanıcı akışından türetilir:
- Flutter ekranları → Riverpod controller → doğrulanmış saf domain → transaction'lı Drift/SQLCipher.
  Form kontrolü repository/girdi sınırını ikame etmez. Yerel kişisel veri ve mağaza erişim kanıtı ayrıdır.
- Onboarding verisi tek SmokingProfile'a gider; şema gerektiğinde additive migration.
  UI dili ve destek ülkesi farklıdır. Bilinmeyen ülke yanlış numarayla doldurulmaz.
- Bugün: marka/rozet/ayar, açık plan adımı, kayıt/atlatma, olay grafiği, beden/organ özeti,
  kazanım/para, bırakma çizelgesi, SOS. Ayrıntı katmanı formülü ve sınırı açıklar.
- Modeller klinik ölçüm değildir; davranış puanı 0–100 puan olarak gösterilir. Katran etiketi
  akciğerde ölçüm sayılamaz. Kişisel saatlik geçmiş türetilmez; kayıtsız gün bilinmeyendir.
- İzin OS'den okunur; ret temel işlevi engellemez. Sağlık/paket satın alma teşvik alarmı yok.
- Premium:7 gün yerel deneme, JSON erişim oluşturamaz; yeniden kurulum engeli tam yerel depoda
  garanti edilemez. Native mağaza doğrulaması/refund/expiry/retry bağımsız test edilir.
- Reklam: ilk kurulum/onboarding/trial/premium/SOS/ödeme/sağlık ayrıntısı/widget'ta yok.
  Sonra ücretsiz uygun ekranlarda etiketli orta boy banner; app-open ancak uygun yükleme
  anında ve en çok24 saatte1, geç kalan reklam gösterilmez. Sağlık hedefleme yok.
- Bütün dil/tema yüzeyleri ortak tasarım token'ları; native widget seçenekleri gerçekten
  platforma aktarılır. Kaynaklı içerik/kanıt düzeyi; besin veya akupresür tedavi yerine geçmez.
- Yayın kapısı: bağımlılık/GPL mağaza uyumu, gerçek SDK gizlilik envanteri, sandbox satın alma,
  imzalı Android/iOS build, anonim kaynak/destek URL erişimi ve hukuk değerlendirmesi.

## 3. CURRENT ARCHITECTURE

- `lib/data/db/app_database.dart:71`: schemaVersion9 (v8 trialNudge, v9
  smokingProfile.declaredRhythmMinutes). Yeni paralel profil gereksiz.
- `lib/domain/onboarding.dart:OnboardingAnswers`, `lib/data/repositories/profile_repository.dart`:
  sayı/marka/ritim sınırları ve transaction öncesi guard; 9 adım (ritim 4. adım,
  bant orta noktası 20/45/90/150, "Emin değilim"=null).
  T4 geri dönüş düzeltmesi: welcome replacement ile kaldırıldığı için ilk adımda
  pop yoksa welcome yeniden açılır; aynı Riverpod cevap durumu korunur.
  PopScope sistem-geri olayını aynı _back akışına bağlar; fiyat metni adım dönüşünde korunur.
- `lib/data/backup_repository.dart`: trialStartedAt export/import kaldırıldı;5 test geçti.
  Yeni kişisel tabloların hepsi aktarılmıyor (bkz. T26: trialNudge dahil v8 alanı da
  kapsam dışında olabilir); veri silme kapsamı eksik olabilir.
- `lib/data/notification_service.dart`: isPermissionGranted OS'den okur
  (areNotificationsEnabled/checkPermissions), openSystemSettings plugin'in
  openAppNotificationSettings'i; `presentation/widgets/notification_permission_card.dart`
  splash ve Ayarlar'da ortak, resume'da yeniden okur. Day-5 trial nudge yalnız
  ayrı `trialNudge` tercihiyle (varsayılan false); premium'da iptal edilir.
- `lib/data/secure_key_store.dart`: Android resetOnError=false; db_opener dosya varlığını
  zorunlu databaseExists argümanıyla iletir. Mevcut DB için eksik/boş anahtar yeni anahtar
  yazmadan StateError verir; native okuma hatası yayılır.5 kanal testi.
- `lib/data/db_opener.dart`: dönüşten önce sqlite_master okunur; bozuk DB/yanlış key
  hatası main'e ulaşır, başarısız bağlantı kapatılır. `lib/app.dart` hata ekranında DB
  ayarlarını okumaz ve home ile / rotasını çakıştırmaz.3 gerçek SQLCipher +1 widget testi.
- `lib/presentation/widgets/quitline_card.dart`: kayıtlı bölge/cihaz bölgesi,TR/US/DE/UK
  alt bölgeleri;3 ekran ortak; numaralar yalnız çağrı düğmelerinde ve kopyalamada.
  Android16 dialer kanıtı 2026-09-18; iOS arama akışı kanıtı açık (T25).
- `lib/data/purchase_service.dart`: mevcut store entegrasyonu restore/async güvenlik denetimi
  bekliyor; callback kriptografik doğrulama kanıtı değil. Tam reklam entegrasyonu yok.
- `settings_screen.dart`: bildirim yoğunluğu Wrap/ChoiceChip; dar alanda sözcük bölmek
  yerine seçenek alt satıra geçer, aynı kaydetme/NotificationService akışı korunur.
  Seçili chip etiketi onPrimary; durum çubuğu ikonları ortak AppBarTheme
  systemOverlayStyle ile ekran parlaklığını izler (Android16 açık+koyu doğrulandı).
- 2026-09-17 güncel çalışma ağacı:331 test geçti; fatal-info analiz temiz.
  `test/widget/design_capture_test.dart` Drift çoklu-instance uyarıları var.
  Bu sonuçlar imzalı mobil build veya tüm AC'lerin kanıtı değildir.
- 2026-09-17: `flutter run -d emulator-5554 --debug --no-resident` başarılı;
  Android16/API36 x64,1080×1920 üzerinde mevcut profil silinmeden açıldı.
  Bugün/Grafikler/Plan/Rehber/SOS/Ayarlar ekranları gözlendi; SOS→Ayarlar→Android Back
  ikinci kontrollü denemede SOS sekmesini korudu. İlk turdaki beklenmeyen Grafikler dönüşü
  tekrar üretilemedi; tüm gezinme doğrulandı sayılmaz. Onboarding native turu henüz yapılmadı.
  Sonraki native doğrulama: e62194d+mevcut dirty tree aynı Android16'da user0 mevcut
  profille Bugün, izole Halen-QA/user10 temiz veride Welcome açıldı. User10'da
  Start→Step1→KEYCODE_BACK→Welcome gözlendi;8 adımlık tam tur hâlâ açık.
GAP: başlangıç beden girdileri ve giriş denetimi → T5,T6.
GAP: görsel ve kullanıcı akışı kapsamı → T7–T18.
GAP: yedek, hukuk, ödeme, reklam ve release kanıtı → T3,T19–T26.

## 4. FILE MAP

```text
halen-quit-smoking/
.github/workflows/ci.yml # CI
.idea/** # IDE kayıtları
android/** # Android native ve build
assets/** # Inter ve lisans
ios/** # iOS runner ve WidgetKit
lib/** # uygulama/domain/data/sunum/l10n
test/** # birim, widget, veri, görsel kontroller
screenshots/** # tanı çıktıları; tamamı onaylı değil
store/** # mağaza görsel varlıkları
tool/** # mevcut bakım betikleri
web/** # Flutter web iskeleti
windows/** # Windows geliştirme host'u
AGENTS.md # brain işaretçisi
PROJECT_BRAIN.md # tek yetkili protokol/plan
README.md # giriş/kurulum
PRIVACY_POLICY.md # kullanıcı gizlilik metni
LICENSE # mevcut kısa lisans bildirimi; T19 açık
CHANGELOG.md
analysis_options.yaml
l10n.yaml
pubspec.yaml
halen.iml
```

Ek izlenen kök dosyalar: `.gitignore` (hariç tutma), `.metadata` (Flutter),
`pubspec.lock` (sabit bağımlılıklar). `git ls-files` üçünü doğruladı; brain tarayıcısı
bu dosyaları listelemiyor, bu yüzden makine haritası dışında açıkça kayıtlılar.

## 5. TASKS

- [x] T1 [M] Ülkeye uygun, yeşil destek hattı (2026-09-18, Kimi K3)
  - Done when: `flutter test test/widget/quitline_card_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → 13 widget testi (TR/EN/DE, UK alt bölge, bilinmeyen bölge, 320dp×1.5×tema); Android16'da SOS/Ayarlar kartı Diğer→Türkiye, ALO171→dialer'da 171 önyüklü, arama yok (CALL izni manifest'te yok). Ölü settingsHelplines (Yeşilay176) üç dilden kaldırıldı; numara kaynakları koda 2026-09-16 tarihiyle yazıldı.

- [x] T2 [M] Bildirim durumu ve geri gezilebilir karşılama (2026-09-18, Kimi K3)
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → Şema v8 `settings.trialNudge` (varsayılan false); day-5 nudge yalnız bu tercihle. `NotificationPermissionCard` splash+Ayarlar ortak; areNotificationsEnabled/checkPermissions + openAppNotificationSettings ile. 4 yeni test; geri akışı T4'ün PopScope testleri ve 2026-09-17 native kanıtında. iOS izin diyaloğu kanıtı T25.

- [x] T3 [H] JSON ile deneme sıfırlama açığını kapat (2026-09-18, Kimi K3)
  - Done when: `flutter test test/data/backup_repository_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → b1c2566'daki izolasyon bağımsız gözden geçirmede doğrulandı (export 4 settings alanı yazar, import trial/satın alma yazmaz, forge reddi tek transaction); rollback testi sertleştirildi (forge ilk kayıt — transaction'sız çalıştırmada kırmızı kanıtlandı). Bakiye kapsam bulguları T26'ya işlendi.

- [x] T4 [M] Onboarding temel girdileri ve varsayılanlar (2026-09-18, Kimi K3)
  - Done when: `flutter test test/domain/onboarding_input_test.dart test/data/onboarding_validation_test.dart test/widget/onboarding_flow_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → 9 adım: ritim adımı TTFC ile fiyat arasında; şema v9 `smokingProfile.declaredRhythmMinutes` (null = "emin değilim"); `TaperController._seedInterval` kayıt yokken beyandan beslenir (yoksa 60). Widget turu 9 adım + domain sınır testi; native tur 1–5. adıma kadar yürüdü (ritim seçimi ve fiyat doğrulaması cihazda kanıtlı), eşzamanlı harici cihaz kullanımı yüzünden kesildi — bkz §6 2026-09-18.

- [x] T5 [M] Boy, kilo ve sigara yılı başlangıçta (2026-09-18, Kimi K3)
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → Onboarding 10. adım `_BodyStep`: boy 100–230, kilo 30–300, yıl 0..`OnboardingAnswers.maxPlausibleSmokingYears(ageBand)`; boş=null kalır (sahte ortalama yok). Akış OnboardingAnswers→ProfileRepository→SmokingProfile mevcut nullable alanlarına; ayarlar üzerinden düzenleme model_settings_section ile zaten var. Yaş bandı çelişkisi ve uç değerler domain testleriyle.

- [x] T6 [H] Bütün girişleri denetle (2026-09-18, Kimi K3)
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → `lib/domain/input_bounds.dart` ortak sınır seti; [H] bağımsız review bulguları kapatıldı: a) settings paket diyaloğu validated record döndürür (re-parse yok), b) typed-garbage opsiyonel alanda artık Save'i durdurur (eskiden sessiz null yazıyordu), c) economy/pack diyalogları controller sızıntısı kapatıldı, d) pack testi alan-tek-tek kırmızı-olur şekilde sertleşti. Onboarding zaten T4/T5 ile bağlı. Quit-plan/coping gibi serbest metin yüzeyleri trim/uzunlukla InputBounds.name kapsamında.

- [x] T7 [M] Premium rozeti ve gerçek widget özelleştirmesi (2026-09-18, Kimi K3)
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.
  → `PremiumBadge` (ücretsiz/deneme/sahip etiketi → paywall), şema v10 widget tercihleri (son-sigara gizleme + tema), `WidgetService.applyWidgetPrefs` native store'a yazar. Android provider prefs dosya/anahtar hatası düzeltildi (HomeWidgetPreferences, öneksiz anahtarlar); widget koyu tema launcher'da kanıtlı. iOS Swift renkleri de theme-key okuyor. 4 widget testi + format testi.

- [ ] T8 [M] Marka ve ana başlık (eski H08)
  - Where: `lib/presentation/screens/today/today_screen.dart; lib/core/design/**`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Mevcut uygulama ikonunu ortak vektör/asset ile tam ürün adının soluna getir. Halen okunur büyüklükte, alt açıklama daha küçük; "Today" marka başlığını bastırmaz. 320dp ve büyük fontta rozet/ayar/başlık taşmaz. Paket kimliğini pazarlama adına göre yeniden değiştirme. Kanıt: EN/TR/DE üst bar açık/koyu görüntüleri ve tap hedefleri.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T9 [M] Sigara kayıt düğmesi ve geri bildirim (eski H09)
  - Where: `lib/application/record_providers.dart; lib/presentation/screens/today/today_screen.dart; lib/presentation/screens/sos/sos_screen.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Bugün ve SOS kayıt yollarını izle. Kontrastlı mercan düğme; sigara kaydında fidan, başarı rengi veya kutlama yok. Kayıt/geri al/tek sonraki adım net; art arda dokunuş duplicate kayıt üretmez. Olumsuz renk kullanıcıyı suçlayan içerik gerektirmez. Kanıt: kayıt/undo/SOS/çift tıklama; yalnız olumlu başarının kutlama tetiklediği test.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T10 [M] Organ haritasının boşluğunu gider (eski H10)
  - Where: `lib/data/repositories/library_repository.dart; lib/presentation/screens/body/**`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Önce mevcut organ kataloğu ve ana ekran filtrelerini say; veri varsa yeniden ekleme. Ana ekrana dengeli 2×4 veya yatay kayar organ özeti, erişilebilir isimler ve tümü bağlantısı. Büyük ekranda boş sütun bırakma; küçükte taşma olmadan kaydır. Akciğer/kalp/damar/beyin/cilt vb. yalnız kaynaklı organları göster, seçince adı üstte. Kanıt: 320/390/420dp, landscape, büyük yazı, seçilen organ ayrıntısı ekran görüntüsü.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T11 [M] Organ içerikleri ve sağlık çizelgesinin konumu (eski H11)
  - Where: `lib/domain/health_timeline.dart; lib/presentation/screens/timeline/**; lib/presentation/screens/settings/settings_screen.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Sağlık çizelgesini Bugün ve vücut ayrıntısından görünür aç; Hakkında altında saklama. Bırakma zamanından otomatik geçen süre olduğunu, kutuların tamamlanma checkbox'ı olmadığını anlat. Henüz bırakma tarihi yoksa tarih seçimi ve genel bilgi önizlemesi. Genel iyileşme bilgisi kişisel organ sonucu değildir. Kanıt: tarihi yok/gelecek/geçmiş, kayıt sonrası değişim, erişilebilir zaman noktası etiketleri.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T12 [M] Psikolojik durum ve his günlüğü (eski H12)
  - Where: `lib/presentation/screens/status/status_flow_screen.dart; lib/application/module_providers.dart; lib/data/db/**`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Kartın amacı bir cümle: kendi kaydettiğin hisleri izlemek ve zor saatleri görmek. "Nasıl hissediyorsun?" kayıt eylemi, kayıt sonrası onay ve geçmiş çizgisi bulunur. Sakin/zorlayıcı bantların anlamı ve tahmin girdileri açıklanır; tahmin ve beyan ayrı stil/etiketle çizilir. Veri yokken kesin durum veya tanı üretme. Kanıt: his kaydı kalıcı, yeniden açınca görünür; sıfır kayıt, hata ve büyük yazı.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T13 [M] Grafik standardı, puan ve yük açıklaması (eski H13)
  - Where: `lib/presentation/widgets/charts/**; lib/domain/progress_index.dart; lib/domain/harm_load.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Her grafikte başlık, metrik, birim, dönem, kaynak türü, veri yok durumu, nasıl hesaplandı ve ayrıntı eylemi denetlenir. İlerleme=plan davranışı (78/100); yük=göreli model indeksi. Siyah kalın küçük başlık ile dev alt değer tutarsızlığını ortak tokens ile gider. Katran ana özetten erişilir; ciğerde ölçülen oran vaat edilmez. Kanıt: chart/semantics testleri; aynı başlık/ölçek standardı TR/EN/DE ve iki tema.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T14 [M] Bugün ne yapmalı, günlük grafik ve kazanımlar (eski H14)
  - Where: `lib/presentation/widgets/today/**; lib/application/plan_controller.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) "17/3" gibi değeri "Bugün 17 kayıt / hedef 3" olarak açık etiketle. Planın azaltma adımı ve bir sonraki öneri anlatılır; "şimdi sigara içmelisin" alarmı oluşturulmaz. "Bugün sana kalanlar" yerine "Bugünkü ilerlemen": atlatılan istek, kayıtlı tasarruf, sigarasız süre. 24 saat sigara olay grafiği günlük yanında; saat/kaç adet/boş veri net. Kanıt: sıfır/kota altı/kota üstü, gün sınırı, geçmiş kayıt silme sonrası hesap.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T15 [M] Para, tarihsel tahmin ve plan başlangıcı (eski H15)
  - Where: `lib/domain/economy.dart; lib/domain/savings.dart; lib/presentation/screens/economy/economy_screen.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Harcama, tasarruf, hedef ve geçmiş tahmini ayrı isim/birimle göster. 1 ay/1 yıl/tümü, bugünden geriye aralık. Kayıttan önceki dönem maliyeti güncel fiyatla yaklaşık olduğu etiketiyle; enflasyona göre gerçek tarihsel ödeme diye sunma. Eksik gün=bilinmiyor. Başlangıç tarihine çizgi/etiket; önceki dönem tahmini çizgi, kayıt sonrası gerçek veri. Kanıt: ilk gün sıfır sahte kazanç, eksik günler, fiyat değişimi, geleceğe taşan kayıt, yıl/ay/gün sınırı ve tasarruf hedefi doğrulaması.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T16 [M] Kriz araçları ve görsel kulak rehberi (eski H16)
  - Where: `lib/presentation/screens/sos/**; lib/presentation/widgets/sos_techniques_list.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) SOS içinde erteleme, nefes, yürüyüş, el/ağız oyalama ve mevcut kulak akupresürü görünür; "Nasıl geçti?/İçtim/Atlattım" erişimi kolay. Noktalar okunur kulak görselinde dokunulabilir ve metinle eşleşir. İğne kullanımı öğretme; akupresürün bırakma etkinliği belirsizse açıkça belirt. Organ tedavisi/nikotin temizleme etkisi uydurma. Kanıt: nokta seçimi, büyük yazı/koyu tema, süreyi durdurma, SOS reklam/paywall yok.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T17 [M] Rehber, beslenme ve makale çeşitliliği (eski H17)
  - Where: `lib/data/repositories/article_repository.dart; lib/data/repositories/library_repository.dart; lib/presentation/screens/articles/**`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Mevcut TR/EN/DE kataloglarını karşılaştır (dil başına içerik kaybı var mı). Tetikleyiciler, kayma sonrası dönüş, uyku, stres, destek kişisi, NRT danışmanlığı, alışkanlık yerine koyma, kahve/alkol ve ağız-el oyalama konularını kaynakla genişlet. Her yazı ne yapmalı, kanıt gücü, sınır, kaynak ve kısa okunur bölümler içerir. Alternatifler "geleneksel/sınırlı kanıt" etiketiyle; besin/akupresür tedavi yerine geçmez. Kanıt: üç dilde kategori/erişim, okunabilirlik, kaynak URL/kapsam ve iddia incelemesi.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T18 [M] Tema, animasyon ve erişilebilirlik (eski H18)
  - Where: `lib/core/theme.dart; lib/core/design/**; test/widget/design_layout_test.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Sistem tema varsayılanını doğrula; tüm ekranlarda Inter/tokens aynı. Kontrast, ikon+metin (yalnız renge bağımlı değil), en az 48dp etkileşim ve screen reader. Grafik ilk görünümde kısa çizilsin, reduceMotion'da son durum; kaydırmada baştan tekrar tekrar çizilmesin. Kanıt: layout/golden, 1.0/1.6/2.0 yazı, düşük hareket.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T19 [H] Hakkında, açık kaynak ve lisans (eski H19)
  - Where: `LICENSE; lib/presentation/screens/about/**; PRIVACY_POLICY.md`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Topluma fayda, kaynak inceleme/katkı, yerel şifreli veri anlatılır. "Gizli kod yok" yerine incelenebilir kaynak ve kullanılan bağımlılık/izinler somut gösterilir. Tam GPL metnini ve üçüncü taraf lisans ekranını ekle; mevcut LICENSE yalnız bağlantı. GitHub kaynak/gizlilik/destek erişimini oturumsuz doğrula. Yanlış destek numarası (ör. eski store taslağındaki Yeşilay176) yayımlanmaz. GPL ticari kullanım yasağı değildir. Kanıt: link/açılmama durumu, üç dil, lisans listesi ve repo görünürlüğü kanıtı.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T20 [H] Gerçek üretim ödemesi ve restore (eski H20)
  - Where: `lib/data/purchase_service.dart; lib/data/db/daos/purchase_dao.dart; lib/application/entitlement_providers.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) PurchaseService.start, stream, refresh, DB cache ve Riverpod UI zincirini birlikte incele. Stream async sonuçlarından önce restore tamamlandı sayılmaz; boş restore tek başına doğrulanmış iade sayılmaz. iOS SK1/SK2 semantiği ve expiration/revocation alanları resmi native kaynaklarla incelenir. Yerel satıra "owned" yazmak receipt doğrulaması değildir. Android token/iOS signed transaction doğrulanır. Eşzamanlı restore, hata sonrası tekrar, pending, refund, abonelik sonu ve reinstall test edilir. Sahte servis testleri ayrı, gerçek sandbox matrisi ayrı kaydedilir. Hesap/anahtar/API erişimi DIŞ BAĞIMLILIK; bu yüzden kod tamamlandı kutusu atılmaz.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T21 [H] Banner, app-open ve deneme sonrası reklamsız satın alma (eski H21)
  - Where: `lib/domain/entitlement.dart; pubspec.yaml; lib/presentation/screens/today/today_screen.dart; android/app/src/main/AndroidManifest.xml; ios/Runner/Info.plist`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) §2 reklam/izin sözleşmesi kurallarıyla önce saf eligibility/frequency politikası; ardından gerçek SDK lisans incelemesi, consent, test birimleri, kullanıcı reklam ayarları ve raporlama. Ağ yok/reklam yok durumu içerikte boş dev alan bırakmaz. Reklamdan dönünce kayıt kaybolmaz. Deneme/premium sırasında istek bile atılmaz. Kanıt: gün0/gün6/gün7, OS dönüşü, günlük cap, arka plan, SOS ve premium negatif testleri; gerçek SDK incelemesi ve hesap kimlikleri yayın öncesi gereklidir.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T22 [M] Belgeler ve üretim çıktısı temizliği (eski H22)
  - Where: `.gitignore; README.md; PROJECT_BRAIN.md; halen-release.apk`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Kökte tek PROJECT_BRAIN.md; skill A0 ve init commit sonrası yalnız scan ADOPT çıktısındaki eski MIMARI.md silinir. README linklerini düzelt. Store açıklamaları ekte; gizlilik kullanıcı belgesi kalır. Kökteki APK'yı yalnız hedefi doğrulayarak kaldır; build/ normal üretim klasörü kalır, Git'e girmez. *.apk/*.aab/*.ipa, imza sırları ve geçici çıktılar ignore edilir. Pubspec.lock uygulamanın tekrarlanabilir derlemesi için takip edilir. Kanıt: git status/check-ignore/ls-files; eski belge yollarına kırık link yok.
  - Done when: `python C:/Users/rubicon/.agents/skills/project-brain/scripts/brain.py check .` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T23 [H] Debug konsolu, cihaz ve derleme (eski H23)
  - Where: `test/widget/design_capture_test.dart; android/**; ios/**; lib/data/db/connection.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Gerçek emulator logunu al: Flutter exception, overflow, plugin/method channel, DB çoklu instance ve zamanlayıcı problemlerini tek tek kök nedenle düzelt. Drift uyarısını global susturma; testlerin DB/executor yaşam döngüsünü incele. SDK warning'i crash ile karıştırma. home_widget Kotlin uyarısını uyumlu sürüm/native geçişle değerlendir; sırf uyarı için kırıcı yükseltme yapma. Kanıt: temiz analyze, tam test, debug smoke, APK/AAB; iOS macOS/Xcode archive ayrı.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T24 [H] Store beyanları, gizlilik ve hukuk (eski H24)
  - Where: `PRIVACY_POLICY.md; android/app/src/main/AndroidManifest.xml; ios/Runner/PrivacyInfo.xcprivacy; PROJECT_BRAIN.md`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Gerçek SDK/native izin ağ envanteriyle App Privacy/Data Safety/Health declaration taslağı hazırla; ülke/yaş hedefi, destek/gizlilik URL'si, KVKK/GDPR veri işleme ve reklam consent kararını eşleştir. İzin reddi/premium/free veri akışı açıklanır. Apple/Google kurallarını yayın günü yeniden oku; hukuk uygunluğunu test geçti diye ilan etme. Hesap formları ve hukuki kararlar DIŞ BAĞIMLILIK. Kanıt: konsol kayıtları, anonim URL erişimi, imzalı sürüm gerçek SDK envanteri.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T25 [H] Mağaza metinleri, final turu ve teslim (eski H25)
  - Where: `PROJECT_BRAIN.md; screenshots/**; store/**`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Ekteki taslakları gerçek özelliklerle yeniden yaz; 30 karakter sınırı ve anahtar kelime limitleri kontrol edilir. Kilit ekranı/özelleştirme gibi cihazda doğrulanmamış özelliği mevcutmuş gibi pazarlama. Üç dilde gerçek ekran görüntüleri üret. T1–T24 gereksinimlerini tek tek kanıtla, yeni kullanıcı→trial→free→purchase→restore ve ret/offline/reset/import akışlarını Android/iOS'ta gez. Her açık dış kapıyı raporla. İmzalı paketlerin hash/sürümü, test kanıtı, commit/push hash'i ve eksikleri §7'e yaz.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T26 [H] Yedek kapsamı ve veri silme bütünlüğü (eski H26)
  - Where: `lib/data/backup_repository.dart; lib/data/db/tables.dart; test/data/backup_repository_test.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) BackupRepository eski tabloları aktarırken yeni mood/support/cessation/pack/settings alanlarını kapsamıyor; wipe de tüm kişisel tabloları silmiyor olabilir. Şema ile export/import/delete listesini satır satır eşleştir. Format migration/geri uyumluluk, referans bütünlüğü ve tüm kişisel verinin silinmesini kanıtla. Satın alma/trial yedek dışında kalır. Bozuk dosyada kısmi silme olmaz; backup'ın düz metin olduğu açıklanır. Kanıt: bütün yeni alanlarda round-trip, tüm kişisel tablo temizliği, rollback.
  - T3 inceleme bulguları (2026-09-18, dış gözden geçirme): (a) `_wipeUserData` yalnız 9 tabloyu siliyor; MoodLog, SupportLog, IndexSnapshot, PlanState, SavingsGoal, CessationPlan, CopingPlan, MoodScreen, PackPurchase ve timeline.acknowledgedMilestones kalıyor. (b) `acknowledgedMilestones` export ediliyor ama import never geri yazmıyor. (c) `setQuitTs` UPDATE-based; temiz cihazda satır yoksa import sessizce kaybolur — import öncesi `getState()` ile satırı yarat veya insert-or-replace yap. (d) "round-trips all user data" testi adının vaat ettiği kadarını kapsamıyor (plans/adjustments/triggers/products/timeline/settings assert'leri yok). (e) 2026-09-18'den itibaren kapsam listesine ekle: settings.trialNudge (v8) ve smokingProfile.declaredRhythmMinutes (v9).
  - Done when: `flutter test test/data/backup_repository_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [x] T18.1 [M] Emülatörde görülen kontrast ve bildirim etiketi (2026-09-18, Kimi K3)
  - Done when: TR/EN/DE küçük ekran ve 1.6× yazı testleri geçer; Android16 açık/koyu ekran görüntülerinde durum çubuğu okunur, Standart kırpılmaz/bölünmez ve seçim çalışır.

- [ ] T23.1 [H] Android güvenli depolama açılış hatasını veri kaybetmeden incele
  - Note: 2026-09-17 güvenli ara; korumalar ve mevcut/temiz açılış kanıtlandı, eski sürüm migration matrisi açık. Hata susturmak için veri silinmez; gözlenen T18.1 görsel kusuruna geçildi.
  - Where: `lib/data/secure_key_store.dart; lib/data/db_opener.dart; android/app/src/main/res/xml/**; test/data/**`
  - Do: Güncel debug kurulumu sonrası FlutterSecureStorage EncryptedSharedPreferences initialization failed / Could not decrypt key / fallback günlüğünü kaynak sürümü ve eski kurulum durumuyla incele. Anahtar değerlerini/loglarını dışarı çıkarma; veriyi/keystore'u silerek hatayı gizleme. Mevcut DB anahtarını koruyan davranışı ve anahtar yoksa boş DB yaratmama gereksinimini doğrula; gerekirse küçük kök-neden düzeltmesi yap.
  - Done when: Eski kurulumdan yükseltme ve temiz kurulum ayrı emülatör senaryolarında kanıtlı; mevcut DB okunur, anahtar kaybı veri üstüne yazmaz; regresyon testi ve log incelemesi geçer. Fallback'in güvenli olduğu kanıtlanmadan kapatma.
  - Note: from A1 native smoke 2026-09-17; PID31443 açılış günlüğü. Hata sonrası mevcut profil görüntülendi, bunun sebebi henüz belirlenmedi.

- [x] T23.2 [H] Veritabanı açılışını hata ekranından önce gerçekten doğrula (2026-09-17, GPT-5)
  - Done when: `flutter test test/data/db_opener_test.dart test/widget/startup_failure_test.dart` yanlış anahtar/bozuk dosyada açılış hatasını, değişmeyen dosya baytlarını, geçerli/temiz DB ve DB okumayan hata ekranını kanıtlar; tam324 test ve analiz geçti.
  - Note: T23.1 içindeki açılış güvenliği alt-işi. Yerel SQLCipher dosyalarıyla red→green; Android eski ESP migration sorunu bununla kapanmaz.

## 6. DECISION LOG

Newest first.

| Date | Type | What | Why / evidence |
|---|---|---|---|
| 2026-09-18 | AUDIT | T7 A2: şema v10 + rozet/settings/native zincir; tam349…353 test temiz; emulator-5554 launcher'da widget eklendi (Halen 3×1), widgetTheme=dark → preview #1E4D45/#F5A623 pikselleri (.dart_tool/t7/widget-band.png) ve run-as prefs listesi kanıt | run-as okuması: widgetShowLast=false, widgetTheme=dark, todaySummary=0/17. Android provider önceden yanlış dosya/anahtar okuyordu (HomeWidgetPrefs + flutter. prefix) — T7 doğrularken bulundu ve düzeltildi. |
| 2026-09-18 | AUDIT | T6 A2 (bağımsız gözden geçirme, general-purpose sub-agent): pack/model/economy/purchases yüzeyleri tek sınır setinde birleşti, 5 widget + 5 domain testi eklendi, tam349 test temiz | Review bulguları (input_bounds katında thunk duplication, economy controller leak, garbage→null session silme, save-after-reparse) tamamen kapatıldı. Settings pack diyaloğu artık PackEditResult döndürüyor. deep-link/widget yüzeyleri kodda sabit/uygulama-üretimli, kullanıcıdan yaşam yolu almıyor: temiz. |
| 2026-09-18 | AUDIT | T5 A2: 10. adım beden verisi, `maxPlausibleSmokingYears` yaş-beli güvenliği, body parse blank/null ayrımı; 2 yeni domain testi + akış testi persist assertion; tam339 test ve analiz temiz | T5 tek başına şema değişikliği yapmadı (boy/kilo/yıl v2 kolonları). iOS/native ayrı değil — widget akışı yeterli ve yazılı kanıt görev tanımında native istemiyor. |
| 2026-09-18 | AUDIT | T3 A2: bağımsız taze-bağlam gözden geçirme 1/2/5/6. iddiayı doğruladı; rollback testini transaction'sız çalıştırmada kırmızı-gösterir biçimde güçlendirdim; 5 backup testi + tam336 test temiz | Gözden geçirme bulguları (wipe kapsamı, milestones round-trip kaybı, quitTs insert-öncesi boşluk, zayıf round-trip adı) T26'nın Do'suna eklendi. Red-green kanıtı: `_wipeUserData` transaction dışına taşınınca test başarısız oldu, geri alınca yeşil. Kod davranışı değişmedi. |
| 2026-09-18 | AUDIT | T4 A2: şema v9 ritim alanı, 9. adım UI, taper seed zinciri, domain+akış testleri; tam337 test ve fatal-info analiz temiz | Şema 8→9 additive; declaredRhythmMinutes 20/45/90/150 bant ortası veya null. flow testi tüm 9 adımı geri/ileri+fiyat korunumuyla yürür; domain testi 10–720 sınırını kurar. APK SHA256 1c6d88f0ce55fa1f9afc17f9ff239f2b77d9ffc3caf8e5f101bd8eb7cb22f950: native tur karşılama→Adım5'e kadar (ritim sorusu .dart_tool/t4/step4-rhythm.png, 30–60 seçimi, fiyat "12,50" Form doğrulaması) geçti; sonra harici cihaz kullanıcısı akışı kesti (aynı emülatörde başka uygulamalar odak alıyor), adım 6–9 native tamamlanamadı. |
| 2026-09-18 | AUDIT | T2 A2 + native kanıt: şema v8 (trialNudge default false), permission card splash+Ayarlar, 4 yeni widget testi; tam336 test + fatal-info analiz temiz | APK SHA256 4ae85e81a217bbc47f7d3d42ad2cc7d63dbd97dce135920e1462278be2fce6d6. Android16 user0: izin açıkken kart "Bildirimler açık"; pm revoke (süreç ölür, Bugün'e döner) → Ayarlar'da kapalı açıklaması + izin + kısayol; "Sistem ayarlarını aç" → com.android.settings/.Settings$AppNotificationSettingsActivity; "Bildirimlere izin ver" → OS diyaloğu → Allow → kart açık. Splash ilk açılış varyantı widget testleriyle; geri akışı T4 PopScope testleri. Projeksiyon-not: user10 SystemUI bu imajda UI automator'ı takıyor (null root node), user10 kaldırılamadı — zararsız bırakıldı. settings_screen staged sürümünden About tile hunk'ı (T19) ayrı tutuldu. |
| 2026-09-18 | AUDIT | T1 A2:13 quitline widget testi ve tam332 test geçti; Android16'da SOS/Ayarlar'daki ortak kart Diğer bölgede numarasız, Türkiye seçiminde ALO171+YEDAM115; arama düğmesi Google Dialer'ı 171 önyüklü açtı, mCalls boş | settingsHelplines (Yeşilay176 içeren ölü dize) üç ARB'den silindi, gen-l10n yenilendi (başka görevlerin ARB ekleri generated'a senkronlandı; buildable ve analiz temiz). Manifest'te CALL izni yok; _call yalnız tel: intent'i. Yeşil 0xFF166534 ve 48dp doğrulama testleri mevcut. Dialer kanıtı .dart_tool/t1/dialer.png (Git dışı). iOS çevirici kanıtı T25'e ait. |
| 2026-09-18 | AUDIT | A1 devralma + T18.1 native kapatma: brain check FAIL yok; T23.2 örneği (e62194d diff'i erken şema okuma+temiz kapanış) doğrulandı; tam332 test ve fatal-info analiz temiz; Android16 user0 açık/koyu beş sekme + Ayarlar durum çubuğu pikselle doğrulandı, Standart tek chip, seçim çalıştı | Debug APK SHA256 5e17b1ed965eabc282b680b9cd5504d1ea2172bd4b3566007246676b815c0bc8, mevcut profil korunarak kuruldu. Açık tema: bg~244/ikon~98 tüm ekranlarda; koyu: bg~18/ikon~255. Kanıt PNG'leri .dart_tool/t181/ (Git dışı). Yoğun seçimi OS bildirim izni diyaloğu açtı, Allow sonrası seçim kalıcı; Standart geri seçildi. Seçili ChoiceChip etiketi artık onPrimary (lib/core/theme.dart). Ayarlar'dan About girişi gibi T19 dirty hunk'ları bu commit dışında bırakıldı. |
| 2026-09-17 | AUDIT | T18.1 bildirim düzeni alt-akışı: TR/EN/DE ×1.0/1.6 yazı,320dp üzerinde6 test geçti; tam331 test ve fatal-info analiz temiz | RenderParagraph seçim kutusu her etiket için tek satır kanıtı; Kapalı seçimi DB ve sahte NotificationService'de doğrulandı. Sabit dört sütun yerine Wrap/ChoiceChip kullanıldı; yeni bağımlılık yok. appAbout hunk'ı commit dışında. Native yeni seçim düzeni/koyu kontrast hâlâ açık, görev kapatılmadı. |
| 2026-09-17 | AUDIT | T18.1 kontrast alt-akışı: ortak AppBarTheme systemOverlayStyle tema parlaklığına bağlandı; açık→koyu→açık widget testi, tam325 test ve fatal-info analiz temiz | Şeffaf AppBar'ın otomatik seçimi açık zeminde beyaz ikon üretiyordu. Android16 güncel debug kurulumu sonrası Grafikler açık tema koyu ikonları .dart_tool/halen-overlay2.png ile görüldü. Koyu native kontrol ve Standart etiketi henüz açık; görev kapanmadı. Eski kişisel kayıtlar değiştirilmedi, PNG Git dışında. |
| 2026-09-17 | AUDIT | T23.1/T23.2 native karşılaştırma: aynı debug APK user0 ve yeni Halen-QA/user10 üzerinde açıldı | APK SHA256 235cde961fe531a13b823afc55df8c04124a115455e0419683f1e90bb20d0178. User0 PID2909 mevcut profil; user10 PID4062 temiz veride Welcome ve Step1→Android Back→Welcome PNG'lerle doğrulandı (.dart_tool/halen-clean3.png,halen-step1.png,halen-back.png). User10 günlüğü No data found in EncryptedSharedPreferences, decrypt/Flutter fatal hatası yok. Plugin10.3.2 initialize içindeki eski ESP yoklaması catch sonrası custom cipher deposuna devam ediyor; user0 eski ESP verisinin neden çözülemediği ve eski sürüm migration matrisi hâlâ açık. Hiçbir veri/key silinmedi, key içeriği okunmadı; işlem sonunda am get-current-user=0. Halen-QA10 sonraki testler için bırakıldı. Kod değişmedi; son tam324 test sonucu geçerli, bu tur tekrar koşulmadı. |
| 2026-09-17 | AUDIT | T23.2 A2: yanlış key/bozuk DB testleri önce hata üretmediği için başarısız, eager sorgu sonrası geçti; hata ekranı testindeki home-/ assertion ve DB ayar erişimi düzeldi |3 gerçek SQLCipher dosya testi +1 widget testi; aynı şifreli dosyanın baytları korunur ve doğru key ile tekrar açılır. Tüm çağrılar main/db_opener; hata cleanup finally ile orijinal stack korunur. İkinci güvenlik self-review tamamlandı, tam324 test/fatal-info analiz temiz. İlk tam testin1622 öncesi süreç tutamacı kaybolduğu için sonuç varsayılmadı, tekrar çalıştırıldı. app.dart yalnız ilgili hunk'lar stage edildi; About değişiklikleri dışarıda. |
| 2026-09-17 | AUDIT | T23.1 alt-düzeltme A2:5 secure-key testi, tam320 test, fatal-info analiz temiz; çağrıların tamamı ve ikinci güvenlik self-review yapıldı | resetOnError native kanala false gider; ilk kurulum 64-hex anahtarı bir kez yazar; mevcut DB null/boş key veya platform okuma hatası yazma/silme yapmaz. Android16 yeniden derleme/güncelleme/PID32307 mevcut profille Bugün açıldı; .dart_tool/halen-keyguard.png gözlendi. APK SHA256 acb3c7d6d4f201ad4b016eac1cf35157826c0993ee637125bc6762d93b6a8fee. ESP fallback hatası hâlâ var: T23.1 kapanmadı. Yeni bağımlılık, veri temizleme veya key çıktısı yok. |
| 2026-09-17 | DECISION | T4 güvenli ara, T23.1 veri güvenliği önce | flutter_secure_storage10.3.2 AndroidOptions resetOnError varsayılan true; yerel paket kaynağı otomatik veri silme davranışını belgeliyor. Açılışta mevcut DB varsa eksik anahtara yenisini yazmamak gerekiyor. ESP fallback Java catch ayrı davranış; bu koruma eski ESP hatasını çözdü diye raporlanmaz. Lazy DB açılışı ayrı T23.2. |
| 2026-09-17 | AUDIT | T23 native smoke: Android16 API36 emulator-5554, güncel dirty tree debug derlendi/kuruldu;6 ekran gözlemi, SOS→Ayarlar→Back kontrollü dönüş geçti | APK SHA256 275bffa68b2351cd4857bbde8dab96fabedbfae0554182bffaec5f53a1a6bc4a. PID31443 filtresinde Flutter exception/RenderFlex/fatal crash gözlenmedi; secure-storage hata/fallback T23.1, durum çubuğu/Standart etiketi T18.1. home_widget KGP uyarısı T23'te açık. Geçici PNG'ler .dart_tool/halen-{smoke,graphs,plan,guide,sos,settings}.png; mevcut profil içeriği Git'e eklenmedi. Bu emülatör turu tüm özellikler/iOS/yayın kanıtı değildir. |
| 2026-09-16 | AUDIT | A1:314 test geçti; T4 sistem-geri alt-akışı A2: regresyon önce Step3 bulunamadığı için başarısız, PopScope sonrası geçti; tam315 test ve fatal-info analiz temiz | OS geri olayı ekran _back metoduna bağlı değildi. Test fiyat adımı→TTFC→fiyat metni korunumu→welcome ve profil oluşmamasını doğrular. Diff yalnız bu akış/test/brain; T4 açık, native iOS swipe ve Android cihaz kanıtı henüz yok. |
| 2026-09-16 | AUDIT | A1 + T4 alt-akış A2: ilk adım Back regresyonu önce0 welcome bularak başarısız, düzeltmeden sonra geçti; tam314 test ve analiz temiz | Splash replacement kök neden; Navigator root ise splash replacement, mevcut stack varsa pop.23 adetlik cevap geri dönüşte korundu. T4 bütünü kapanmadı. |
| 2026-09-16 | DECISION | T4 ritim için mevcut PlanState.intervalMinutes akışı incelendi | TaperController.runDailyStep başlangıç değerini kullanıyor. Yeni kişisel ritim verisini doğrulanmış başlangıç olarak bağlamadan yalnız gösterim ekleme; T26 yedeğine de dahil et. |
| 2026-09-16 | DECISION | Init e361947 sonrası tek ADOPT kaynağı MIMARI.md kaldırıldı;26 açık/kısmi,0 tamamlandı taşındı | Eski belge Git geçmişinden geri alınabilir. README ve AGENTS brain'e yönlenir; ürün kapsamı daraltılmadı. |
| 2026-09-16 | GOAL-CHANGE | Kullanıcı proje-devralma becerisinin kurallarını açıkça önceliklendirdi | Dosya adı/protokol MIMARI değil skill PROJECT_BRAIN olur; ürün hedefi korunur. |
| 2026-09-16 | DECISION | MIMARI.md'den 26 açık/kısmi görev devralındı;0 tamamlandı kabul edildi | Eski H kimlikleri T1–T26'da izlenir; eski protokol kopyalanmadı, target ürün amacından yeniden türetildi. |
| 2026-09-16 | AUDIT | A0:3 kod iddiası doğrulandı; AC1–AC7 görev eşlemesi, ilk5 görev devralma incelemesi yapıldı | Şema7, trial ayrımı, repository guard; brain check FAIL yok. Geçiş boyunca legacy uyarısı bekleniyor; init sonrası kaldırılır. |
| 2026-09-16 | AUDIT | A1 devralma:313 test geçti, flutter analyze --fatal-infos temiz | Çoklu Drift instance uyarıları T23; gerçek cihaz/görseller henüz nihai değil; kapalı görev yok. |
| 2026-09-16 | ASSUMPTION | Görevlerdeki otomatik test komutu yalnız alt kanıt | Mağaza/hukuk/cihaz kanıtı olmayan madde kapatılamaz. |

## 7. HANDOFF

T7 kapandı; sıradaki T8 (marka + ana başlık: ikon + ürün adı üst bar).
Widget ayarları canlı native store'a yazıyor; launcher widget'ı koyu tema ile duruyor. Emülatörde widget eklendi (kaldırmak istersen ana ekranda uzun bas → kaldır).
Açıklar: T8–T18 görsel/UX, T19–T26; onboarding native son 4 adım T4'te kesildi (cihaz kontrolü), iOS mağaza kapıları T20+.

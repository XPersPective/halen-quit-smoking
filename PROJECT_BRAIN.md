<!-- project-brain:v1 -->
# PROJECT BRAIN — Halen: Quit Smoking Tracker

> **Status:** T4 ilk-adım geri dönüşü düzeldi; ritim girdisi ve mobil gezinme denetimi açık.
> **Phase:** BUILD · **Next:** T4 · **Updated:** 2026-09-16 · **Synced@:** 2544080
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

- `lib/data/db/app_database.dart:71`: schemaVersion7. Yeni paralel profil gereksiz.
- `lib/domain/onboarding.dart:OnboardingAnswers`, `lib/data/repositories/profile_repository.dart`:
  sayı/marka sınırları ve transaction öncesi guard; mevcut8 adım fiyat/marka Form'u.
  T4 geri dönüş düzeltmesi: welcome replacement ile kaldırıldığı için ilk adımda
  pop yoksa welcome yeniden açılır; aynı Riverpod cevap durumu korunur.
- `lib/data/backup_repository.dart`: trialStartedAt export/import kaldırıldı;5 test geçti.
  Yeni kişisel tabloların hepsi aktarılmıyor; veri silme kapsamı eksik olabilir.
- `lib/presentation/widgets/quitline_card.dart`: kayıtlı bölge/cihaz bölgesi,TR/US/DE/UK
  alt bölgeleri;3 ekran ortak. Native arama ve aralıklı raster görünmezlik henüz açık.
- `lib/data/purchase_service.dart`: mevcut store entegrasyonu restore/async güvenlik denetimi
  bekliyor; callback kriptografik doğrulama kanıtı değil. Tam reklam entegrasyonu yok.
- 2026-09-16 güncel çalışma ağacı:314 test geçti; fatal-info analiz temiz.
  `test/widget/design_capture_test.dart` Drift çoklu-instance uyarıları var.
  Bu sonuçlar imzalı mobil build veya tüm AC'lerin kanıtı değildir.
GAP: başlangıç izin/ritim/beden/geri akışı → T2,T4,T5,T6.
GAP: görsel ve kullanıcı akışı kapsamı → T1,T7–T18.
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

- [ ] T1 [M] Ülkeye uygun, yeşil destek hattı (eski H01)
  - Where: `lib/presentation/widgets/quitline_card.dart; test/widget/quitline_card_test.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Sorun: İngilizce arayüzde Türkiye numarası öne çıkıyor. SOS, Ayarlar ve başlangıç ekranındaki tüm çağrıları bul; tek ülke kataloğunu kullan. TR ALO171/YEDAM115, US/UK/DE hizmetlerini resmi kaynaklarından doğrula, kaynak ve kontrol tarihini yaz. Ülke değiştirme kısa yolu ve yerel ülke etiketi sun; bilinmeyen ülkeye yanlış telefon atma. Yeşil, en az 48dp dokunma alanı; hata/çevirici yok durumunda numara kopyalama. Kanıt: TR/EN/DE ve İngilizce+Türkiye/İngilizce+UK kombinasyon testi; gerçek cihazda çevirici açılır ama otomatik arama yapılmaz.  Uygulama kararı: ortak QuitlineCard SOS/Ayarlar/18 yaş altı ekranında kullanılır. Seçim mevcut shared_preferences içinde yalnız destek bölgesi olarak tutulur; UI dilinden ülke türetilmez. Cihaz TR/US/DE önerilebilir, GB için İngiltere/İskoçya/ Galler ayrımı kullanıcıya bırakılır. Desteklenmeyen bölgede yerel uzman yönlendirmesi gösterilir. 16 Eylül resmi kontrolleri: ALO171 (alo171.saglik.gov.tr), YEDAM115 (yedam.org.tr/telefon-ile-danismanlik), CDC 1-800-784-8669 (cdc.gov/tobacco/hcp/patient-care/quitlines-and-other-resources.html), BIÖG 0800 8 31 31 31 (rauchfrei-info.de/unterstuetzung/telefonberatung/), NHS İngiltere 0300 123 1044, İskoçya 0800 84 84 84, Galler 0800 085 2219 (nhs.uk/live-well/quit-smoking/nhs-stop-smoking-services-help-you-quit/). Eski "UK NHS" tüm Birleşik Krallık için genellenmez; "Yeşilay 176" kaldırılır.
  - Done when: `flutter test test/widget/quitline_card_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T2 [M] Bildirim durumu ve geri gezilebilir karşılama (eski H02)
  - Where: `lib/presentation/screens/splash_screen.dart; lib/data/notification_service.dart; lib/presentation/screens/onboarding/onboarding_screen.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Splash/onboarding geçişlerini ve NotificationService çağrılarını incele. Yetki durumunu ilk açılış ve ayarlardan dönüşte OS'den al. İzin varsa onaylı görünüm, ret varsa açıklama ve ayar kısa yolu; ileri/geri çalışır, girilmiş bilgiler korunur. Ücretsiz izin isteği ve premium pazarlama birbirine bağlanmaz. Pazarlama hatırlatması için ayrı kullanıcı tercihi gerekir; deneme bitiş bildirimi otomatik reklam izni sayılmaz. Kanıt: izin verilmiş/reddedilmiş/sonradan kaldırılmış senaryoları; Android/iOS cihaz.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T3 [H] JSON ile deneme sıfırlama açığını kapat (eski H03)
  - Where: `lib/data/backup_repository.dart; test/data/backup_repository_test.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) BackupRepository settings.trialStartedAt alanını export/import'tan çıkar. Eski yedekte varsa yok say; mevcut deneme ve store cache değişmez. Onboarding'e JSON eylemi koyma, Ayarlar > Verilerim altında veri taşıma olarak sun. Null/gelecek/eski trial tarihi ve sahte entitlement içeren import premium açamaz. Yerel yeniden kurulum sınırını §2 reklam/izin sözleşmesi'te açık tut; dışa aktarmayı kaldırmak lisans doğrulaması yerine geçmez. Kanıt: değiştirilmiş JSON ile süresi bitmiş denemenin yenilenmediği, normal kayıtların aktarıldığı ve bozuk import'un rollback testi.
  - Done when: `flutter test test/data/backup_repository_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [~] T4 [M] Onboarding temel girdileri ve varsayılanlar (eski H04) (claimed 2026-09-16)
  - Where: `lib/domain/onboarding.dart; lib/application/onboarding_controller.dart; lib/data/repositories/profile_repository.dart; lib/presentation/screens/onboarding/onboarding_screen.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) OnboardingAnswers/controller/repository/UI zincirini beraber düzenle. Günlük adet varsayılanı 20, paket adedi 20. Adet tam sayı; 1.2, negatif, sıfır, NaN, aşırı değer kabul edilmez, "1.2" sessizce 12'ye dönüştürülmez. Fiyat başlangıçta boş ve pozitif sonlu sayı zorunlu; virgül/nokta yerel yazımı destekle. Yaş aralığı, ilk sigaraya süre, günlük ritim ve marka açık sorulur; boş/yalnız boşluk marka ileri geçirmez. Sayfa üzerinde kısa hata göster, uygulamayı çökertme. Marka sonradan değiştirilebilir. Kanıt: tüm adımlar geri/ileri, geçersiz klavye/yapıştırma girdisi, doğru kalıcılık testi.  Uygulama kararı: mevcut sekiz adım korunur; fiyat ve marka adımlarında Flutter Form doğrulaması, repository sınırında aynı domain kuralları kullanılır. Günlük adet 1–60 tam sayı slider (varsayılan20), paket 1–100 tam sayı, fiyat >0 ve <=1.000.000 sonlu yerel ondalık sayı; marka trim sonrası 1–100 karakter. Bunlar klinik sınırlar değil girdi/ürün sınırlarıdır. Geçersiz paket girdisi sessizce20 olmaz, boş marka önceki markayı geri getirmez. Boy/kilo/yıl ve ritim eklemesi T5 kapsamında henüz açık.
  - Done when: `flutter test test/domain/onboarding_input_test.dart test/data/onboarding_validation_test.dart test/widget/onboarding_flow_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T5 [M] Boy, kilo ve sigara yılı başlangıçta (eski H05)
  - Where: `lib/domain/onboarding.dart; lib/data/db/tables.dart; lib/presentation/widgets/model_settings_section.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Mevcut nullable SmokingProfile alanlarını tekrar kullan. Onboarding'de boy(cm), kilo(kg), sigara yılı ve kullanıldığı amaç göster. Yaşla çelişen süre, sonlu olmayan sayı ve makul aralık dışı değer reddedilir. "Bilmiyorum/paylaşmak istemiyorum" nullable kalır, sahte ortalama kullanıcı verisi gibi saklanmaz. Ayarlardan düzenleme ilgili modeli yeniler. Doğum tarihi/rehber gibi gereksiz hassas veri ekleme. Kanıt: migration, onboarding→profil→model zinciri; bilinmeyen değer ve sınır testi.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T6 [H] Bütün girişleri denetle (eski H06)
  - Where: `lib/presentation/**; lib/data/backup_repository.dart; lib/application/pack_providers.dart`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) TextField/TextFormField, slider, backup, deep link, widget ve DB girişlerini envanterle. Adet=int, para=pozitif sonlu, hedef adı=trim/uzunluk sınırı, tarih/geçmiş=anlamlı aralık. Bütçe, paket satın alma, birikim hedefi ve model ayarları aynı domain kurallarını kullanır. Negatif/future kayıt ve duplicate event davranışı belirlenir. Kanıt: her güven sınırına en az bir kötü veri regresyonu; işlem rollback ve hata metni.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

- [ ] T7 [M] Premium rozeti ve gerçek widget özelleştirmesi (eski H07)
  - Where: `lib/presentation/screens/today/today_screen.dart; lib/data/widget_service.dart; ios/HalenWidget/**; android/app/src/main/kotlin/**`
  - Do: 1) Mevcut kod ve testle gereksinimlerin karşılanma durumunu doğrula. 2) Bugün üst barında Ayarlar yanında tıklanabilir Premium/Deneme rozeti; kalan gün, 7 gün sonrasında hangi özelliklerin değişeceği ve ömür boyu adsiz seçenek görünür. Widget için Ayarlar > Widget'lar: ekleme yönergesi, mevcut native boyut önizlemesi, desteklenen gösterge/tema seçimleri ve kaydet; ilk günden denemede kullanılabilir. Android provider ve iOS WidgetKit/App Group'a aynı ayar yazılır; desteklenmeyen seçenek pazarlanmaz. Kanıt: seçim kalıcılığı/deneme kapısı, gerçek launcher/WidgetKit görüntüsü.
  - Done when: `flutter analyze --fatal-infos ve flutter test` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

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
  - Done when: `flutter test test/data/backup_repository_test.dart` geçer; yukarıdaki Kanıt senaryolarının her biri gözlenmiş sonuçla kaydedilir. Platform/hukuk kanıtı gerekiyorsa otomatik test tek başına kapatmaz.

## 6. DECISION LOG

Newest first.

| Date | Type | What | Why / evidence |
|---|---|---|---|
| 2026-09-16 | AUDIT | A1 + T4 alt-akış A2: ilk adım Back regresyonu önce0 welcome bularak başarısız, düzeltmeden sonra geçti; tam314 test ve analiz temiz | Splash replacement kök neden; Navigator root ise splash replacement, mevcut stack varsa pop.23 adetlik cevap geri dönüşte korundu. T4 bütünü kapanmadı. |
| 2026-09-16 | DECISION | T4 ritim için mevcut PlanState.intervalMinutes akışı incelendi | TaperController.runDailyStep başlangıç değerini kullanıyor. Yeni kişisel ritim verisini doğrulanmış başlangıç olarak bağlamadan yalnız gösterim ekleme; T26 yedeğine de dahil et. |
| 2026-09-16 | DECISION | Init e361947 sonrası tek ADOPT kaynağı MIMARI.md kaldırıldı;26 açık/kısmi,0 tamamlandı taşındı | Eski belge Git geçmişinden geri alınabilir. README ve AGENTS brain'e yönlenir; ürün kapsamı daraltılmadı. |
| 2026-09-16 | GOAL-CHANGE | Kullanıcı proje-devralma becerisinin kurallarını açıkça önceliklendirdi | Dosya adı/protokol MIMARI değil skill PROJECT_BRAIN olur; ürün hedefi korunur. |
| 2026-09-16 | DECISION | MIMARI.md'den 26 açık/kısmi görev devralındı;0 tamamlandı kabul edildi | Eski H kimlikleri T1–T26'da izlenir; eski protokol kopyalanmadı, target ürün amacından yeniden türetildi. |
| 2026-09-16 | AUDIT | A0:3 kod iddiası doğrulandı; AC1–AC7 görev eşlemesi, ilk5 görev devralma incelemesi yapıldı | Şema7, trial ayrımı, repository guard; brain check FAIL yok. Geçiş boyunca legacy uyarısı bekleniyor; init sonrası kaldırılır. |
| 2026-09-16 | AUDIT | A1 devralma:313 test geçti, flutter analyze --fatal-infos temiz | Çoklu Drift instance uyarıları T23; gerçek cihaz/görseller henüz nihai değil; kapalı görev yok. |
| 2026-09-16 | ASSUMPTION | Görevlerdeki otomatik test komutu yalnız alt kanıt | Mağaza/hukuk/cihaz kanıtı olmayan madde kapatılamaz. |

## 7. HANDOFF

T4 fiyat/marka/sayı db4a737; ilk-adım Back düzeltmesi bu commit'te;314 test ve analiz geçti.
Sonraki: T4 günlük ritim sorusunu controller→repository→PlanState/TaperController zincirine bağla, kötü girdi/kalıcılık testi ekle.
T4 native sistem-geri/görsel kontrol, T5 boy/kilo/yıl ve T2 OS izin durumu açık; task kapatılmadı.
Başka işlere ait geniş dirty tree korunuyor; yalnız incelenmiş task hunk'ları stage edilir.
Son remote doğrulama2544080; iOS/ödeme/reklam hesap kapıları T20–T25, hedef BUILD.

Mağaza taslağı geçmiş referansı: 7da72d7:MIMARI.md §6; T25 yeniden yazar, eski iddialar yayımlanmaz.

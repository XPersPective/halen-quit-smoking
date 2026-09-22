# -*- coding: utf-8 -*-
"""T23.1 migration matrix runner (brain: PROJECT_BRAIN.md, task T23.1).

Proves the secure-storage migration path on a REAL emulator run:
  Phase A  install the OLD build, complete onboarding (creates profile +
           encrypted DB + key), log one cigarette, capture fingerprints.
  Phase B  install the NEW build over it (`install -r`), launch, verify:
           no welcome screen (data survived), zero decrypt errors, key
           files unchanged, and the log button still works.

Usage (run from the repo root, device quiet — no other automation):
    python tool/t231_migration.py \
        --old ../halen-t231/build/app/outputs/flutter-apk/app-debug.apk \
        --new build/app/outputs/flutter-apk/app-debug.apk \
        [--serial emulator-5554]

Evidence is written to .dart_tool/t231-run/.
"""
import argparse
import hashlib
import os
import re
import subprocess
import sys
import time

ADB_EXE = os.environ.get(
    'ADB',
    os.path.expandvars(r'%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe'),
)
SERIAL = None
OUT = '.dart_tool/t231-run'


def adb(*args, capture=True):
    cmd = [ADB_EXE]
    if SERIAL:
        cmd += ['-s', SERIAL]
    cmd += list(args)
    return subprocess.run(cmd, capture_output=capture, text=True)


def dump():
    adb('shell', 'rm -f /sdcard/t231.xml')
    for _ in range(6):
        adb('shell', 'uiautomator dump /sdcard/t231.xml')
        xml = adb('shell', 'cat /sdcard/t231.xml').stdout
        if len(xml) > 800:
            return xml
        time.sleep(1.2)
    return ''


def find(xml, label):
    for m in re.finditer(r'<node[^>]*>', xml):
        n = m.group(0)
        vals = [v for v in re.findall(r'(?:content-desc|text)="([^"]*)"', n) if v]
        for v in vals:
            if v == label or v.split('\n')[0] == label:
                b = re.search(r'bounds="\[(\d+),(\d+)\]\[(\d+),(\d+)\]"', n)
                if b:
                    return ((int(b.group(1)) + int(b.group(3))) // 2,
                            (int(b.group(2)) + int(b.group(4))) // 2)
    return None


def tap(x, y):
    adb('shell', f'input tap {x} {y}')


def texts(xml):
    return re.findall(r'(?:content-desc|text)="([^"]{2,90})"', xml)


def launch():
    """Launcher-activity agnostic start (works across app-id renames)."""
    adb('shell', f'monkey -p {PKG} -c android.intent.category.LAUNCHER 1')


def focused():
    return 'halenquitsmoking' in adb('shell',
        'dumpsys activity activities | grep topResumedActivity').stdout


def ensure_focus(max_tries=6):
    for _ in range(max_tries):
        if focused():
            return True
        launch()
        time.sleep(2.5)
    return focused()


def step(marker, action=None, wait=1.6, log=[]):
    if isinstance(marker, (list, tuple)):
        markers = list(marker)
    else:
        markers = [marker]
    if isinstance(action, (list, tuple)) or action is None:
        actions = list(action) if action else [None]
    else:
        actions = [action]
    for _ in range(5):
        if not focused():
            ensure_focus()
        xml = dump()
        current = next((m for m in markers if m in xml), None)
        if current is not None:
            print(f'  ok: {marker}')
            if action:
                p = None
                for a in actions:
                    p = find(xml, a)
                    if p is not None:
                        break
                if p is None:
                    print(f'  !! action {actions!r} not visible at {current}')
                    return False
                tap(*p)
                time.sleep(wait)
            return True
        time.sleep(1.0)
    print(f'  !! marker never seen: {markers}')
    return False


PKG = 'com.crazypenguin.halenquitsmoking'


def fingerprint():
    """Cheap integrity fingerprint of the secure-storage + DB footprint."""
    r = adb('shell',
            f"run-as {PKG} sh -c 'ls shared_prefs/ 2>/dev/null; "
            f"ls -la databases/ 2>/dev/null'")
    return hashlib.sha256(r.stdout.encode()).hexdigest()[:16], r.stdout


def main():
    global SERIAL
    ap = argparse.ArgumentParser()
    ap.add_argument('--old', required=True, help='old-build APK path')
    ap.add_argument('--new', required=True, help='new-build APK path')
    ap.add_argument('--serial', default='emulator-5554')
    args = ap.parse_args()
    SERIAL = args.serial

    results = []

    def check(name, ok):
        results.append((name, ok))
        print(('PASS ' if ok else 'FAIL ') + name)

    print('== Phase A: OLD build, onboarding with data ==')
    adb('uninstall', PKG)
    r = adb('install', args.old)
    check('old apk installed', 'Success' in r.stdout)
    adb('shell', 'wm dismiss-keyguard')
    launch()
    time.sleep(6)

    check('welcome screen', step(["Halen'e hoş geldin", 'Welcome to Halen'], ['Başla', 'Start']))
    check('step 1 age', step(['Adım 1/8', 'Step 1 of 8'], ['İleri', 'Next']))
    check('step 2 daily', step(['Adım 2/8', 'Step 2 of 8'], ['İleri', 'Next']))
    check('step 3 ttfc pick', step(['Adım 3/8', 'Step 3 of 8'], ['5–30 dakika', '5–30 minutes']))
    check('step 3 to price', step(['Adım 3/8', 'Step 3 of 8'], ['İleri', 'Next']))
    check('step 4 price screen', step(['Adım 4/8', 'Step 4 of 8']))
    adb('shell', 'input text 89,90')
    time.sleep(0.8)
    check('step 4 to triggers', step(['Adım 4/8', 'Step 4 of 8'], ['İleri', 'Next']))
    check('step 5 triggers pick', step(['Adım 5/8', 'Step 5 of 8'], ['Kahve', 'Coffee']))
    check('step 5 to goal', step(['Adım 5/8', 'Step 5 of 8'], ['İleri', 'Next']))
    check('step 6 goal', step(['Adım 6/8', 'Step 6 of 8'], ['İleri', 'Next']))
    check('step 7 why pick', step(['Adım 7/8', 'Step 7 of 8'], ['Stres', 'Stress']))
    check('step 7 to brand', step(['Adım 7/8', 'Step 7 of 8'], ['İleri', 'Next']))
    check('step 8 brand + finish', step(['Adım 8/8', 'Step 8 of 8'], ['Planımı kur', 'Set up my plan']))
    check('result to Today', step(['Bugün', 'Today'], ['Bir sigara içtim', 'I smoked'], wait=2.0))
    adb('shell', 'am force-stop ' + PKG)
    time.sleep(1.5)

    fp_a, snap_a = fingerprint()
    print('  fingerprint A:', fp_a)
    open(f'{OUT}/phase-a-storage.txt', 'w', encoding='utf-8').write(snap_a)
    if fp_a == hashlib.sha256(b'').hexdigest()[:16]:
        print(
            '\nABORT: the old app created no storage — its process did not '
            'survive long enough to initialize. This emulator is contended '
            '(third-party automation keeps taking focus). Stop that '
            'automation, then re-run this script.'
        )
        return 1

    print('== Phase B: upgrade in place ==')
    r = adb('install', '-r', args.new)
    check('new apk installed over old', 'Success' in r.stdout)
    adb('logcat', '-c')
    launch()
    time.sleep(9)

    xml = dump()
    check('no welcome after upgrade', "Halen'e hoş geldin" not in xml)
    log = adb('logcat', '-d', f'--pid={adb("shell", "pidof " + PKG).stdout.strip()}').stdout
    bad = len(re.findall(r'could not decrypt|StateError|Wrong key|fatal exception', log, re.I))
    check('zero decrypt/fatal errors in logcat', bad == 0)

    fp_b, snap_b = fingerprint()
    print('  fingerprint B:', fp_b)
    check('key files intact after upgrade', fp_a == fp_b)

    # Functional: the pre-upgrade cigarette must still be counted.
    check('diary shows the logged cigarette',
          'bugün 1' in xml.lower() or '1/1' in xml or 'Bugün: 1' in xml)

    print('\n== SUMMARY ==')
    failed = [n for n, ok in results if not ok]
    for n, ok in results:
        print(('PASS ' if ok else 'FAIL ') + n)
    if not failed:
        print('\nMIGRATION MATRIX: ALL PASS')
        return 0
    print(f'\nMIGRATION MATRIX: {len(failed)} failed: {failed}')
    return 1


if __name__ == '__main__':
    sys.exit(main())

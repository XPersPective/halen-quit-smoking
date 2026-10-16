"""Renders images/featureGraphic.png + icon.png for every Play locale (headless Edge)."""
import base64, html, pathlib, shutil, subprocess, sys, tempfile

sys.path.insert(0, str(pathlib.Path(__file__).parent))
import build

EDGE = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
ICON = pathlib.Path(__file__).resolve().parents[2] / "store" / "icon-512.png"
RTL = {"ar", "fa", "ur", "iw-IL"}

TEMPLATE = """<!doctype html><html lang="{lang}" dir="{dir}"><head><meta charset="utf-8">
<style>
html,body{{margin:0;width:1024px;height:500px;overflow:hidden}}
body{{background:linear-gradient(180deg,#256650 0%,#1a4a3a 100%);
 font-family:"Segoe UI","Nirmala UI","Leelawadee UI","Myanmar Text","Malgun Gothic","Yu Gothic UI","Microsoft YaHei UI","Microsoft JhengHei UI","Sylfaen","Segoe UI Historic",sans-serif;
 color:#fff;display:flex;align-items:center;justify-content:center}}
.wrap{{display:flex;align-items:center;gap:56px;width:884px;height:360px}}
img{{width:300px;height:300px;border-radius:66px;flex:none;box-shadow:0 10px 30px rgba(0,0,0,.25)}}
.t{{flex:1;min-width:0;display:flex;flex-direction:column;justify-content:center;height:360px}}
h1{{margin:0 0 14px;font-size:118px;line-height:1.05;font-weight:700;letter-spacing:-2px}}
h2{{margin:0 0 14px;font-size:42px;line-height:1.2;font-weight:600;color:#e8f4ee}}
p{{margin:0;font-size:25px;line-height:1.3;color:#a9d6c0}}
</style></head><body><div class="wrap"><img src="data:image/png;base64,{icon}">
<div class="t"><h1>Halen</h1><h2 id="s">{slogan}</h2><p id="u">{sub}</p></div></div>
<script>
const box=document.querySelector('.t');
for(const [id,min] of [['s',22],['u',15]]){{const el=document.getElementById(id);
 let fs=parseFloat(getComputedStyle(el).fontSize);
 while(box.scrollHeight>box.clientHeight+1 && fs>min){{fs-=1;el.style.fontSize=fs+'px';}}}}
</script></body></html>"""


def main(only=None):
    data = build.load()
    icon_b64 = base64.b64encode(ICON.read_bytes()).decode()
    tmp = pathlib.Path(tempfile.mkdtemp(prefix="halen-fg-"))
    n = 0
    for loc, key in build.PLAY_LOCALES.items():
        if only and loc not in only:
            continue
        d = data[key]
        page = tmp / f"{loc}.html"
        page.write_text(TEMPLATE.format(
            lang=loc, dir="rtl" if loc in RTL else "ltr", icon=icon_b64,
            slogan=html.escape(d["slogan"]), sub=html.escape(d["sub"])), encoding="utf-8")
        out = build.PLAY / loc / "images" / "featureGraphic.png"
        out.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run([EDGE, "--headless=new", "--disable-gpu", "--hide-scrollbars",
                        "--force-device-scale-factor=1", "--window-size=1024,500",
                        f"--screenshot={out}", page.as_uri()],
                       check=True, capture_output=True, timeout=90)
        shutil.copyfile(ICON, out.parent / "icon.png")
        n += 1
    print("rendered", n)


if __name__ == "__main__":
    main(set(sys.argv[1:]) or None)

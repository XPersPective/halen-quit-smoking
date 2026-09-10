# -*- coding: utf-8 -*-
"""Generates the launcher icon from the app's own mark (premium brief 5.5).

The app shipped with Flutter's default blue logo, which is the single most
visible "unfinished" signal a product can have: it is what somebody sees on
their home screen before they open anything.

The mark is the one the splash already uses — concentric rings, a breath
rather than a cigarette — on the product's petrol green. Deliberately not a
crossed-out cigarette: the app's whole tone is about what someone is moving
towards, and a home-screen icon that shouts SMOKING at every glance is both
off-tone and something people do not want on a shared phone.

Adaptive icons need the mark inside the safe zone (the outer ~28% of an
adaptive icon can be masked away by the launcher), so the foreground layer is
drawn at 60% of the canvas.
"""
import io
import os

from PIL import Image, ImageDraw

PETROL = (30, 91, 71, 255)
PETROL_DEEP = (15, 46, 35, 255)
MINT = (169, 214, 190, 255)
AMBER = (233, 162, 59, 255)

# Legacy square launcher icons.
LEGACY = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

# Adaptive layers are always 108dp; the safe zone is the middle 72dp.
ADAPTIVE = {
    'mipmap-mdpi': 108,
    'mipmap-hdpi': 162,
    'mipmap-xhdpi': 216,
    'mipmap-xxhdpi': 324,
    'mipmap-xxxhdpi': 432,
}

RES = 'android/app/src/main/res'


def draw_mark(size, scale, supersample=8):
    """The app's signature shape, centred, at [scale] of the canvas.

    Concentric closed rings read as a bullseye — a target, a record button, a
    Wi-Fi glyph — none of which this product is. So the mark is the gauge arc
    the app actually draws on its scores: an open 260-degree sweep with a cap
    where the value sits. It reads as progress rather than aim, and it is the
    one shape somebody who has used the app will already recognise.
    """
    big = size * supersample
    image = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    centre = big / 2
    radius = big * scale / 2

    # PIL angles run clockwise from 3 o'clock; the gauge opens at the bottom.
    start, sweep = 140, 260
    track_width = max(1, int(radius * 0.20))

    def arc(fraction, colour, degrees, width):
        r = radius * fraction
        draw.arc(
            [centre - r, centre - r, centre + r, centre + r],
            start=start,
            end=start + degrees,
            fill=colour,
            width=width,
        )

    # The unfilled track, then the filled part of the sweep.
    arc(1.0, (255, 255, 255, 46), sweep, track_width)
    arc(1.0, MINT, int(sweep * 0.72), track_width)

    # The cap: where the value has reached.
    import math
    angle = math.radians(start + sweep * 0.72)
    cap = (centre + radius * math.cos(angle), centre + radius * math.sin(angle))
    cap_r = track_width * 0.72
    draw.ellipse(
        [cap[0] - cap_r, cap[1] - cap_r, cap[0] + cap_r, cap[1] + cap_r],
        fill=MINT,
    )

    # An amber core, the colour the app reserves for what is in the body.
    r = radius * 0.30
    draw.ellipse([centre - r, centre - r, centre + r, centre + r], fill=AMBER)

    return image.resize((size, size), Image.LANCZOS)


def rounded_square(size, radius_fraction=0.22, supersample=8):
    big = size * supersample
    image = Image.new('RGBA', (big, big), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    draw.rounded_rectangle(
        [0, 0, big - 1, big - 1],
        radius=int(big * radius_fraction),
        fill=PETROL,
    )
    return image.resize((size, size), Image.LANCZOS)


def write(path, image):
    directory = os.path.dirname(path)
    if not os.path.isdir(directory):
        os.makedirs(directory)
    image.save(path)
    return path


def main():
    written = []

    for folder, size in LEGACY.items():
        icon = rounded_square(size)
        icon.alpha_composite(draw_mark(size, 0.62))
        written.append(write(os.path.join(RES, folder, 'ic_launcher.png'), icon))

    for folder, size in ADAPTIVE.items():
        background = Image.new('RGBA', (size, size), PETROL)
        written.append(
            write(os.path.join(RES, folder, 'ic_launcher_background.png'),
                  background))
        # 0.42 of the 108dp canvas keeps the mark inside the 72dp safe zone
        # whatever mask the launcher applies.
        foreground = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        foreground.alpha_composite(draw_mark(size, 0.42))
        written.append(
            write(os.path.join(RES, folder, 'ic_launcher_foreground.png'),
                  foreground))

    # The monochrome layer Android 13+ uses for themed icons.
    for folder, size in ADAPTIVE.items():
        mono = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        mark = draw_mark(size, 0.42)
        white = Image.new('RGBA', (size, size), (255, 255, 255, 255))
        mono.paste(white, (0, 0), mark.split()[3])
        written.append(
            write(os.path.join(RES, folder, 'ic_launcher_monochrome.png'),
                  mono))

    # A 1024 store icon, flat (no rounding: the stores apply their own).
    store = Image.new('RGBA', (1024, 1024), PETROL_DEEP)
    store.alpha_composite(draw_mark(1024, 0.60))
    written.append(write('store/icon-1024.png', store))

    for path in written:
        print(path)
    print('\n%d files' % len(written))


if __name__ == '__main__':
    main()

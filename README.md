# ega-pride
A multiple-choice pride flag quiz. Requires DOS and EGA. Only 5 flags at the moment. Compiled with Microsoft QuickBasic 4.5.

![screenshot; shows the rainbow flag and asks if it's the rainbow, intersex or pansexual flag](snap.png)

Table of contents:
* [Technical info](#technical-info)
* [Sources of flags](#sources-of-flags)

## Technical info
All flags have a horizontal resolution of 320 pixels.
Vertical resolution varies.
In 320*200 mode at 4:3 aspect ratio, the pixel aspect ratio is 5:6, so the flags are stretched horizontally by 6/5 to compensate.

Original aspect ratio &ndash; target aspect ratio &ndash; target resolution:
* 3:2 &ndash; 9:5 &ndash; 320*178
* 5:3 &ndash; 2:1 &ndash; 320*160
* 13:8 &ndash; 39:20 &ndash; 320*164

The PNG images under `flags/` have reduced size and color count but the original colors.

## Sources of flags
Original aspect ratio in parentheses.
* [intersex](https://commons.wikimedia.org/wiki/File:Intersex_Pride_Flag.svg) (3:2)
* [transgender](https://commons.wikimedia.org/wiki/File:Transgender_Pride_flag.svg) (5:3)
* [nonbinary](https://commons.wikimedia.org/wiki/File:Nonbinary_flag.svg) (3:2) (not yet included)
* [pansexual](https://commons.wikimedia.org/wiki/File:Pansexuality_Pride_Flag.svg) (5:3)
* [asexual](https://commons.wikimedia.org/wiki/File:Asexual_Pride_Flag.svg) (5:3)
* [rainbow](https://commons.wikimedia.org/wiki/File:Gay_Pride_Flag.svg) (13:8 or more precisely 259:160)

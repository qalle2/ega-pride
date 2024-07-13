# ega-pride
A multiple-choice pride flag quiz. Requires DOS and EGA. Only nine flags at the moment. Compiled with Microsoft QuickBasic 4.5.

![screenshot; shows the rainbow flag and asks if it's the rainbow, intersex or pansexual flag](snap.png)

Table of contents:
* [Technical info](#technical-info)
* [Sources of flags](#sources-of-flags)
* [To do](#to-do)

## Technical info
All flags have a horizontal resolution of 320 pixels.
Vertical resolution varies.
In 320*200 mode at 4:3 aspect ratio, the pixel aspect ratio is 5:6, so the flags are stretched horizontally by 6/5 to compensate.

Original aspect ratio &ndash; target aspect ratio &ndash; approximate target resolution (vertical resolution may be tweaked a little so horizontal stripes are of equal thickness):
* 3:2 &ndash; 9:5 &ndash; 320*178
* 5:3 &ndash; 2:1 &ndash; 320*160
* 13:8 &ndash; 39:20 &ndash; 320*164
* 16:9 &ndash; 32:15 &ndash; 320*150

The PNG images under `flags/` have reduced size and color count but the original colors.

## Sources of flags
Original aspect ratio in parentheses.
* [aromantic](https://commons.wikimedia.org/wiki/File:Aromantic_Pride_Flag.svg) (5:3)
* [asexual](https://commons.wikimedia.org/wiki/File:Asexual_Pride_Flag.svg) (5:3)
* [bisexual](https://commons.wikimedia.org/wiki/File:Bisexual_Pride_Flag.svg) (5:3)
* [intersex](https://commons.wikimedia.org/wiki/File:Intersex_Pride_Flag.svg) (3:2)
* [lesbian](https://commons.wikimedia.org/wiki/File:Lesbian_Pride_Flag_2019.svg) (16:9)
* [nonbinary](https://commons.wikimedia.org/wiki/File:Nonbinary_flag.svg) (3:2)
* [pansexual](https://commons.wikimedia.org/wiki/File:Pansexuality_Pride_Flag.svg) (5:3)
* [rainbow](https://commons.wikimedia.org/wiki/File:Gay_Pride_Flag.svg) (13:8 or more precisely 259:160)
* [transgender](https://commons.wikimedia.org/wiki/File:Transgender_Pride_flag.svg) (5:3)

## To do
* get more flags [here](https://github.com/qalle2/nes-pride) (see "sources of flags")

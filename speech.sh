#!/bin/bash
say() { local IFS=+;omxplayer -o hdmi "http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=$*&tl=Pt-br"; }
say $*

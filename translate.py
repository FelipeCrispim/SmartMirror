import urllib
import subprocess
import sys

subprocess.call(["mpg123","http://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q="+sys.argv[1]+"&tl=Pt-br"], shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
import tweepy
import sys
import csv

def get_time_line(screen_name, out):
	consumer_key = '40mq26okBuI028ks2OMOvgKgi'
	consumer_secret = 'gth6CVhz1DwfOkUIuA8rYLv47VUFgN6UDFgD1W68UAJ0Xe61Jr'
	access_key = '230900774-gjjICUPMFlwUg0iXNoEywgfXXh3ntNDxc9SGw0jM'
	access_secret = 'NuWG9BVfFlm6QdejcG0JtSnbngJXJ8oGhntNkTryPQni7'

	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_key, access_secret)
	api = tweepy.API(auth)

	st = []

	for status in tweepy.Cursor(api.home_timeline).items(10):
		st.append([status.text.encode("utf-8")])
	
	with open(out+'%s.csv' % screen_name, 'wb') as f:
		writer = csv.writer(f)
		writer.writerow(["text"])
		writer.writerows(st)
	#print st
	

def main():
	get_time_line(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
    main()

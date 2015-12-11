import urllib

input_file = open("../data/urls.txt", "r")

write_path = "../images/"
for line in input_file:
  URL = line
  filename = write_path + URL.split("/")[-1]
  urllib.urlretrieve(URL, filename.strip())

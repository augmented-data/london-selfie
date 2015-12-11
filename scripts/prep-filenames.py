#prep-filenames.py

import os
import pandas as pd

src_path  = "../images/"
 
image_type = ".jpg"

image_paths = []  
for root, dirs, files in os.walk(src_path):
  image_paths.extend([os.path.join(root, f) for f in files if f.endswith(image_type)])

image_filenames = [image_path.split("/")[-1] for image_path in image_paths]

df = pd.read_csv("../data/urls.txt", header = None)

urls = list(df[0])

rel_urls = [url for url in urls if url.split("/")[-1] in image_filenames]

out_df = pd.DataFrame({"image_url" : rel_urls})

out_df.to_csv("../data/clearn-urls.csv", index = False)
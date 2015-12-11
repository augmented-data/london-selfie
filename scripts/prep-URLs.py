import os
import pandas as pd

url_pre = "https://s3-us-west-2.amazonaws.com/london-selfie/candidate-london-imgs/"

src_path, image_type = "../candidate-images/", ".jpg"
 
image_paths = []  
for root, dirs, files in os.walk(src_path):
    image_paths.extend([os.path.join(root, f) for f in files if f.endswith(image_type)])

urls = [url_pre + image_path.split("/")[-1] for image_path in image_paths]

df = pd.DataFrame({'image_url': urls})

df.to_csv("../data/london-image-candidates.csv", index = False)
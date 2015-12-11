import pandas as pd
import numpy as np

in_file = "../data/london-image-candidates.csv"
out_file = "../data/london-montage-urls-batches-60.csv"
num_cols = 60


df = pd.read_csv(in_file)
image_urls = list(df["image_url"])

N = len(image_urls)
adjustment = num_cols*(int(N%num_cols>0) + N/num_cols) - N

wrapped_urls = image_urls + image_urls[:adjustment]

oneD = np.array(wrapped_urls)
twoD = oneD.reshape(int(N%num_cols>0) + N/num_cols,num_cols)
res = pd.DataFrame(twoD)

col_names = ["image" + str(i) for i in range(1,num_cols+1)]
res.columns = col_names

res.to_csv(out_file, index = False)
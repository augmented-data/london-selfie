## parse-confusion-matrix.R
##

single.face = read.delim("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/AliseLabels_raw/00_1_face_textfile.txt", header = FALSE, stringsAsFactors = FALSE)
multiple.faces = read.delim("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/AliseLabels_raw/00_2_or_more_textfile.txt", header = FALSE, stringsAsFactors = FALSE)

single.face$filename = sapply(single.face$V1, FUN = function(x) strsplit(x, split = "\\\\")[[1]][length(strsplit(x, split = "\\\\")[[1]])])
single.face$filename = sapply(single.face$filename, FUN = function(x) gsub(" ", "", x, fixed = TRUE))
multiple.faces$filename = sapply(multiple.faces$V1, FUN = function(x) strsplit(x, split = "\\\\")[[1]][length(strsplit(x, split = "\\\\")[[1]])])
multiple.faces$filename = sapply(multiple.faces$filename, FUN = function(x) gsub(" ", "", x, fixed = TRUE))


files = read.delim("~/Desktop/filename_samples.txt", header = FALSE, stringsAsFactors = FALSE)
files$filename = sapply(files$V1, FUN = function(x) strsplit(x, split = "/")[[1]][length(strsplit(x, split = "/")[[1]])])
files$face.label = "No faces"
files$face.label[which(files$filename %in% single.face$filename)] = "Single face"
files$face.label[which(files$filename %in% multiple.faces$filename)] = "Multiple faces"


#opencv = read.csv("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/broadway_sample.csv", header = TRUE, stringsAsFactors= FALSE)
opencv = read.csv("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/OpenCV_labels/faces_alt_tree_broadway.csv", header = TRUE, stringsAsFactors= FALSE)
get.filename = function(x) {
  splitted = strsplit(x, split = "/")[[1]]
  return(splitted[length(splitted)])
}
opencv$filename = sapply(opencv$file_path, get.filename)
files.opencv = merge(opencv[,c("filename", "num_faces")], files, all = FALSE)
files.opencv$OpenCV.label = "No faces"
files.opencv$OpenCV.label[which(files.opencv$num_faces ==1)] = "Single face"
files.opencv$OpenCV.label[which(files.opencv$num_faces >1)] = "Multiple faces"

files.opencv$binary.face.label = "No faces"
files.opencv$binary.face.label[which(files.opencv$face.label != "No faces")] = "Yes faces"
files.opencv$binary.OpenCV = "No faces"
files.opencv$binary.OpenCV[which(files.opencv$OpenCV.label != "No faces")] = "Yes faces"

files.opencv.unique = unique(files.opencv)
library(caret)
confusionMatrix(files.opencv.unique$OpenCV.label, files.opencv.unique$face.label)
confusionMatrix(files.opencv.unique$binary.OpenCV, files.opencv.unique$binary.face.label, positive = "Yes faces")

# setup.opencv.df = function(path, face_label){
#   df = read.csv(path, header = TRUE, stringsAsFactors = FALSE)
#   names(df)[2] = paste0(names(df)[2], "_", face_label)
#   df$filename = sapply(df$file_path, get.filename)
#   df$file_path = NULL
#   return(df)
# }
# 
# opencv.alt.tree = setup.opencv.df("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/OpenCV_labels/faces_alt_tree_broadway.csv", "alt.tree")
# opencv.alt.2 = setup.opencv.df("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/OpenCV_labels/faces_alt2_broadway.csv", "alt.2")
# opencv.alt = setup.opencv.df("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/OpenCV_labels/faces_alt_broadway.csv", "alt")
# opencv.default = setup.opencv.df("~/Dropbox/Broadway_paper/broadway_samples_to_label/data-labels/OpenCV_labels/faces_default_broadway.csv", "default")
# 
# library(plyr)
# rm(files.opencvalt)
# opencv = join_all(list(opencv.alt.tree, opencv.alt.2, opencv.alt, opencv.default))
# files.opencv = merge(opencv, files, all = FALSE)
# files.opencv$median.opencv = apply(files.opencv[,c("num_faces_alt.tree", "num_faces_alt.2", "num_faces_alt", "num_faces_default")], 1, median)
# files.opencv$OpenCV.label = "No faces"
# files.opencv$OpenCV.label[which(files.opencv$median.opencv ==1)] = "Single face"
# files.opencv$OpenCV.label[which(files.opencv$median.opencv >1)] = "Multiple faces"

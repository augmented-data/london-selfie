##
## clean-turk.R
##

setwd("~/Documents/london-selfie/")

df = read.csv("data/download.csv", header = TRUE, stringsAsFactors = FALSE)

df$Answer.tag2[which(df$Answer.tag2 == "20!")] = "20M"
df$Answer.tag2[which(df$Answer.tag2 == "25")] = "25F"
df$Answer.tag2[which(df$Answer.tag2 == "20")] = "20F"
df$Answer.tag2[which(df$Answer.tag2 == "35")] = "35M"

df$age.tag = sapply(df$Answer.tag2, FUN = function(x) as.numeric(gsub("[^0-9]", "", x)))
df$gender.tag = sapply(c(1:nrow(df)), FUN = function(i) toupper(strsplit(df$Answer.tag2[i], split = as.character(df$age.tag[i]))[[1]][2]))

df$gender.tag[which(df$gender.tag == " F")] = "F"


df.rel = df[,c("AssignmentId", "WorkerId", "Input.image_url", "age.tag", "gender.tag")]

library(plyr)

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

get.votes = function(df.x){
  ages.gender = c(df.x$age.tag, df.x$gender.tag)
  names(ages.gender)[c(1:3)] = paste0("age.tag.", c(1:3))
  names(ages.gender)[c(4:6)] = paste0("gender.tag.", c(1:3))
  res = as.data.frame(t(ages.gender))
  res$median.age = median(df.x$age.tag)
  res$mean.age = mean(df.x$age.tag)
  res$gender.mode = Mode(df.x$gender.tag)
  return(res)
}


df.clean = ddply(df, .(Input.image_url), get.votes)
write.csv(df.clean, file = "./data/MT-london-selfies.csv", row.names = FALSE, quote = FALSE)


get.filename = function(x) {
  splitted = strsplit(x, split = "/")[[1]]
  return(splitted[length(splitted)])
}

custom.df = data.frame(sapply(df.clean$Input.image_url, get.filename))
names(custom.df)[1] = "filepath"
custom.df$median.age = df.clean$median.age
custom.df$filepath = paste0("/Users/myazdaniUCSD/Documents/london-selfie/images/", custom.df$filepath)

write.csv(custom.df, file = "./data/img_hist_age.csv", row.names = FALSE, quote = FALSE)

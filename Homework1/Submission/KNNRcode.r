
# To install EBImage package:

source("https://bioconductor.org/biocLite.R")
biocLite("EBImage")
library(EBImage)
library(class)
library(caret)
library(pbapply)


path <- "C:\\Users\\owner\\Documents\\Clemson University\\ML Math 9810_9880\\"
image_dir <- "C:\\Users\\owner\\Documents\\Clemson University\\ML Math 9810_9880\\train"

# example.cat=readImage(file.path(image_dir, "cat.0.jpg"))
# display(example.cat)
# 
# example.dog=readImage(file.path(image_dir, "dog.0.jpg"))
# display(example.dog)

width <- 28
height <- 28


extract_feature <- function(dir_path, width, height, is_cat = TRUE, add_label = TRUE) {
  img_size <- width*height
  ## List images in path
  images_names <- list.files(dir_path)
  if (add_label) {
    ## Select only cats or dogs images
    images_names <- images_names[grepl(ifelse(is_cat, "cat", "dog"), images_names)]
    ## Set label, cat = 0, dog = 1
    label <- ifelse(is_cat, 0, 1)
  }
  print(paste("Start processing", length(images_names), "images"))
  ## This function will resize an image, turn it into greyscale
  feature_list <- pblapply(images_names, function(imgname) {
    ## Read image
    img <- readImage(file.path(dir_path, imgname))
    ## Resize image
    img_resized <- resize(img, w = width, h = height)
    ## Set to grayscale
    grayimg <- channel(img_resized, "gray")
    ## Get the image as a matrix
    img_matrix <- grayimg@.Data
    ## Coerce to a vector
    img_vector <- as.vector(t(img_matrix))
    return(img_vector)
  })
  ## bind the list of vector into matrix
  feature_matrix <- do.call(rbind, feature_list)
  feature_matrix <- as.data.frame(feature_matrix)
  ## Set names
  names(feature_matrix) <- paste0("pixel", c(1:img_size))
  if (add_label) {
    ## Add label
    feature_matrix <- cbind(label = label, feature_matrix)
  }
  return(feature_matrix)
}

cats_data <- extract_feature(dir_path = image_dir, width = width, height = height)
dogs_data <- extract_feature(dir_path = image_dir, width = width, height = height,
is_cat = FALSE)

dim(cats_data)
dim(dogs_data)

saveRDS(cats_data, "cat.rds")
saveRDS(dogs_data, "dog.rds")

X1=as.matrix(cats_data[,-1])
Y1=as.vector(cats_data[,1])
X2=as.matrix(dogs_data[,-1])
Y2=as.vector(dogs_data[,1])

X=rbind(X1,X2)
Y=c(Y1,Y2)

complete.dat=data.frame(cbind(Y,X))
ind=unlist(createDataPartition(complete.dat$Y, p = .9, times = 1))
train.dat <- complete.dat[ind,]
dim(train.dat)

test.dat=complete.dat[-ind,]
dim(test.dat)


train.Y=train.dat$Y
factor.train.Y=as.factor(train.Y)
train.X=train.dat[,-1]


test.Y=test.dat$Y
factor.test.Y=as.factor(test.Y)
test.X=test.dat[,-1]

# KNN.func<-function(X0,Y,Xo,k){
#   d<-sqrt(apply(t(t(Xo)-X0)^2,1,sum))
#   id<-order(d)[1:k]
#   yhat<-mean(Y[id])
#   return(yhat)
# }

###########################################
# k=15
train.pred15=knn(train.X,train.X,train.Y,k=15)
train.err15=mean(train.pred15!=train.Y)
confusionMatrix(train.pred15,factor.train.Y)

t1=Sys.time()
test.pred15=knn(train.X,test.X,train.Y,k=15)
t2=Sys.time()
test.err15 <- mean(test.pred15!=test.Y)
confusionMatrix(test.pred15,factor.test.Y)

###########################################
# k=5
train.pred5=knn(train.X,train.X,train.Y,k=5)
train.err5=mean(train.pred5!=train.Y)
confusionMatrix(train.pred5,factor.train.Y)

t3=Sys.time()
test.pred5=knn(train.X,test.X,train.Y,k=5)
t4=Sys.time()
test.err5 <- mean(test.pred5!=test.Y)
confusionMatrix(test.pred5,factor.test.Y)

###########################################
# k=1
train.pred1=knn(train.X,train.X,train.Y,k=1)
train.err1=mean(train.pred1!=train.Y)
confusionMatrix(train.pred1,factor.train.Y)

t5=Sys.time()
test.pred1=knn(train.X,test.X,train.Y,k=1)
t6=Sys.time()
test.err1 <- mean(test.pred1!=test.Y)
confusionMatrix(test.pred1,factor.test.Y)

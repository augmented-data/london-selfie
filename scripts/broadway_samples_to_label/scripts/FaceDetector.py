import numpy as np
from sklearn.base import BaseEstimator, ClassifierMixin
import cv2

class FaceDetector(BaseEstimator, ClassifierMixin):
  def __init__(self,  cascadePath = "/Applications/OpenCV/opencv-2.4.8/data/haarcascades/haarcascade_frontalface_alt.xml", scaleFactor = 1.1, minNeighbors = 3):
    self.cascadePath = cascadePath
    self.scaleFactor = scaleFactor
    self.minNeighbors = minNeighbors
    self.objectClassifier = cv2.CascadeClassifier(cascadePath)

  def _equalizedGray(self, image):
    im = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return cv2.equalizeHist(im)
  
  def _getImage(self, image_path):
    im = cv2.imread(image_path)
    im = cv2.resize(im, (150,150))
    gray = self._equalizedGray(im)
    return gray

  def fit(self, X, y = None):
    assert (type(X) == list), "X must be list"
    return self

  def predict(self, X, y = None):
    print "using", self.cascadePath
    res = []
    for x in X:
      gray = self._getImage(x)
      found_objects = self.objectClassifier.detectMultiScale(gray, scaleFactor = self.scaleFactor, minNeighbors = self.minNeighbors)
      res.append(np.sign(len(found_objects)))
    res_arr = np.array(res)
    return res_arr.ravel()

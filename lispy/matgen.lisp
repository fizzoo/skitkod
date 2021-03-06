(defun make-uniform-matrix (i j)
  "Makes a uniform matrix"
  (let ((m (make-array (list i j))))
    (dotimes (i-i i)
      (dotimes (j-i j)
        (setf (aref m i-i j-i) (/ 1 j))))
    m))

(defun sum-row-matrix (m row)
  "Sums up a row of a 2d array"
  (loop for j from 0 to (1- (array-dimension m 1)) summing
       (aref m row j)))

(defun normalize-matrix (m)
  "Normalizes a matrix of probabilities, making it row-stochastic"
  (dotimes (i (array-dimension m 0))
    (let ((sum (sum-row-matrix m i)))
      (dotimes (j (array-dimension m 1))
        (setf (aref m i j) (/ (aref m i j) sum))))))

(defun add-noise-matrix (m &optional (value 0.01) (iterations 32))
  "Modify matrix m, adding some value on random positions, and then normalize."
  (dotimes (i iterations)
    (let* ((rand-i (random (array-dimension m 0)))
           (rand-j (random (array-dimension m 1)))
           (value-j (+ (aref m rand-i rand-j) value)))
      (setf (aref m rand-i rand-j) value-j)))
  (normalize-matrix m))

(defun add-diagonal-bias-matrix (m &optional (value 0.1))
  "Adds a diagonal bias of size value"
  (cond ((not (= (array-dimension m 0)
                 (array-dimension m 1)))
         (error "Mismatching column size, can't add diagonal bias!"))
        (t
         (dotimes (i (array-dimension m 0))
           (setf (aref m i i) (+ (aref m i i) value)))
         (normalize-matrix m))))

(defun make-good-transition-matrix (size)
  "Makes a good random transition matrix, i.e. some noise and diagonal
bias"
  (let ((m (make-uniform-matrix size size)))
    (add-diagonal-bias-matrix m)
    (add-noise-matrix m)
    m))


;; (defparameter *uniform* (make-uniform-matrix 2 3))
;; (add-noise-matrix *uniform*)
;; (print *uniform*)
;; (defparameter *uniform-diag* (make-uniform-matrix 3 3))
;; (add-diagonal-bias-matrix *uniform-diag*)
;; (add-noise-matrix *uniform-diag*)
;; (print *uniform-diag*)

(make-good-transition-matrix 4)

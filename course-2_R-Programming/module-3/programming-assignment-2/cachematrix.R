## Matrix inversion with a built-in cache to avoid repeated computation.
## assumption: the matrix is square and is invertible.

## Function to assert a condition.
assert_equal <- function(one, two, message) {
  if (!identical(one, two)) {
    stop(message)
  }
}

## Function to assert a condition is TRUE.
assert_true <- function(one, message) {
  assert_equal(one, TRUE, message)
}

is_square_matrix <- function(m) {
  ncol(m) == nrow(m)
}

## makeCacheMatrix(x)
## creates a special "matrix" object that can cache its inverse.
##
## parameters:
## - x: a matrix. Defaults to a new empty matrix. Must be square and invertible.
makeCacheMatrix <- function(x = matrix()) {
  assert_true(is_square_matrix(x),
              "The matrix must be square (and invertible).")
  inverse <- NULL
  set <- function(new_x) {
    x <<- new_x
    inverse <<- NULL
  }
  get <- function()
    x
  set_inverse <- function(new_inverse)
    inverse <<- new_inverse
  get_inverse <- function()
    inverse
  list(
    set = set,
    get = get,
    set_inverse = set_inverse,
    get_inverse = get_inverse
  )
}


## cacheSolve(x)
## Computes the inverse of a special "matrix" returned by makeCacheMatrix()
##
## parameters:
## - x: the result of makeCacheMatrix()
cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  existing_inverse <- x$get_inverse()
  if (!is.null(existing_inverse)) {
    message("Returning the cached inverse")
    return(existing_inverse)
  }
  message("Computing the inverse")
  m <- x$get()
  inverse <- solve(m, ...)
  x$set_inverse(inverse)
  inverse
}

## Tests for cacheMatrix.R
##
## Conditions are asserted via assert_equal()
source("cacheMatrix.R")

## Test makeCacheMatrix(x)
m1 <- matrix(1:4, 2, 2)
cache_matrix_1 <- makeCacheMatrix(m1)
m1_get <- cache_matrix_1$get()
assert_equal(m1, m1_get, "Inner matrix should be the same as original.")

m3 <- matrix(c(1, 4, 5, 4, 2, 6, 5, 6, 3), ncol = 3)
cache_matrix_1$set(m3)
m3_get <- cache_matrix_1$get()
assert_equal(m3, m3_get, "Inner matrix should be the same as new original.")

## Test cacheSolve(x)
inverse_1 <- cacheSolve(cache_matrix_1)
assert_equal(solve(m3), inverse_1, "Inverse is correct")
# Call again, should use the cache
inverse_2 <- cacheSolve(cache_matrix_1)
assert_equal(solve(m3), inverse_2, "Inverse is as expected")
print("Tests passed OK")

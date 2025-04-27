properTryCatch <- function(my_code, my_finally) {
    tryCatch(
        withCallingHandlers(my_code(), # withCallingHandlers(): so can handle warning, yet still continue
            error = function(e) {
                print(e)
            },
            warning = function(w) {
                print(w)
                invokeRestart("muffleWarning")
            }
        ),
        error = function(e) {
            print("!! ERROR !!")
            print(e)
            print("recovered from error")
        },
        finally = {
            print("[finally]")
            my_finally()
        }
    )
}

print_section <- function(message) {
    separator <- "=== === ==="

    print_line <- function() {
        print(paste(separator, separator, separator))
    }

    print_line()
    print(paste(separator, message, separator))
    print_line()
}

short_summary <- function(my_data) {
    cat("Rows:", nrow(my_data), "Columns:", ncol(my_data), "\n")
}

str_big <- function(my_data) {
    str(my_data, list.len = nrow(my_data))  # disable truncation
}

wait_for_enter <- function() {
    print("Press [enter] to continue")
    scan("stdin", character(), n=1)
}

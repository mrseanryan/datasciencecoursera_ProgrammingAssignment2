is_installed <- function(pkg) {
    nzchar(system.file(package = pkg))
}

install_if_missing <- function(package_name) {
    print(paste("Checking for ", package_name))
    if (!require(package_name) && !is_installed(package_name)) {
        print(paste("Installing ", package_name))
        r_mirror_nl <- "https://mirrors.evoluso.com/CRAN/"
        install.packages(package_name, repos = r_mirror_nl)
    }
}

download_if_missing <- function(data_dir, data_filename, data_url) {
    if (!file.exists(data_dir)) {
        dir.create(data_dir)
    }
    dest_file <- paste(data_dir, data_filename, sep = "/")

    if (file.exists(dest_file)) {
        print("File already downloaded!")
    } else {
        download.file(data_url, destfile = dest_file, method = "curl") # curl helps with https (on Mac)
    }
    list.files(data_dir)

    dest_file <- paste(data_dir, data_filename, sep = "/")

    print(paste("dest_file: ", dest_file))

    return(dest_file)
}

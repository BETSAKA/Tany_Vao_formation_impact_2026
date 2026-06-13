library(dplyr)
library(stringr)
library(aws.s3)
library(purrr)

# #
# aws.s3::put_object(
#   file = "data/grille_matched.rds",
#   object = "diffusion/tany_vao_2026/data/grille_matched.rds",
#   bucket = "projet-betsaka",
#   region = "",
#   multipart = TRUE)

# A function to put data from local machine to S3
put_to_s3 <- function(from, to) {
  aws.s3::put_object(
    file = from,
    object = to,
    bucket = "projet-betsaka",
    region = "",
    multipart = TRUE)
}

# A function to iterate/vectorize copy
get_from_s3 <- function(from, to) {
  aws.s3::save_object(
    object = from,
    bucket = "projet-betsaka",
    file = to,
    overwrite = FALSE,
    region = "")
}

# To put files
my_files_local <- list.files("data/gadm", full.names = TRUE, recursive = TRUE)
my_files_local
my_files_dest <- paste0("diffusion/tany_vao_2026/", my_files_local)

map2(my_files_local, my_files_dest, put_to_s3)

# to get files
# Listing files in bucket
my_files_s3 <- get_bucket_df(bucket = "projet-betsaka",
                             prefix = "diffusion/tany_vao_2026/data",
                             region = "") %>%
  pluck("Key")

my_files_dest <- str_remove(my_files_s3, "diffusion/tany_vao_2026/")

setdiff(my_files_dest, my_files_s3)
map2(my_files_s3, my_files_dest, get_from_s3)

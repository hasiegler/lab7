#' Clusters observations into groups using kmeans clustering
#'
#' @param dat A Data Frame
#' @k Number of clusters
#'
#' @return A list of cluster assignments and the total sum of squares
#'
#' @import dplyr
#'
#' @export
k_means <- function(dat, k) {

    rand <- sample(1:nrow(dat), k)

    clusters <- dat[rand,]

    cluster_vec <- c()
    last_vec <- c(0)
    iter <- 0
    stop <- 0

    while (stop == 0) {

        iter <- iter + 1

        for (i in 1:nrow(dat)) {

            dist <- dat[i,] %>%
                rbind(clusters) %>%
                dist()

            i_cluster <- dist[1:k] %>%
                which.min()

            cluster_vec[i] <- i_cluster

        }

        if (all(cluster_vec == last_vec)) {
            stop <-  1

        }

        last_vec <- cluster_vec

        clusters <- dat %>%
            cbind(cluster_vec) %>%
            group_by(cluster_vec) %>%
            summarize_all(mean)

        clusters <- clusters[, -1]

    }

    overall <- dat %>%
        summarize_all(mean)

    total <- 0
    ss <- c()

    for (i in 1:nrow(dat)) {

        ss <- dat[i,] %>%
            rbind(overall) %>%
            dist()
        total <- total + ss

    }

    list <- list(cluster_vec, total[1])
    return(list)

}



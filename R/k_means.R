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
k_means <- function(dat, k, pca = FALSE) {

    if(pca == TRUE){
        dat <- princomp(dat)
        dat <- dat$scores %>%
            as.data.frame() %>%
            select(Comp.1, Comp.2)
    }

    rand <- sample(1:nrow(dat), k)

    clusters <- dat[rand,]

    cluster_vec <- c()
    last_vec <- c(0)
    dists <- c()
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

            dist <- dist[1:k] %>%
                min()

            cluster_vec[i] <- i_cluster

            dists[i] <- dist

        }

        if (all(cluster_vec == last_vec)) {
            stop <-  1
        }

        SSTO = round(sum(dists^2))

        last_vec <- cluster_vec

        clusters <- dat %>%
            cbind(cluster_vec) %>%
            group_by(cluster_vec) %>%
            summarize_all(mean)

        clusters <- clusters[, -1]

    }

    list <- list('Clustering vector' = cluster_vec, 'SSTO' = SSTO)
    return(list)
}




library(HSAUR2)
library(cluster)
library(ggplot2)
library(dplyr)
library(plotly)

data("planets")
planets

# Estandarización
df_std <- scale(planets)

#Aplicación de PAM
resultado <- pam(df_std, k=4)

# cluster al que pertenece cada obs.
resultado$clustering
# los 4 medoides
resultado$medoids

# Data frame con etiquetas cluster
df_plot <- as.data.frame(df_std)
df_plot$cluster <- factor(resultado$clustering)

# los medoides obtenidos
medoids <- as.data.frame(resultado$medoids)


# Gráfico con ggplot
ggplot(df_plot, aes(x = mass, y = period, color = cluster)) +
  geom_point(alpha = 0.6) +
  geom_point(data = medoids, aes(x = mass, y = period),
             color = "red", size = 5, shape = 8) +
  labs(title = "Clusters PAM con medoides")


#----------------------------------------------------------------------------------

costs <- vector()

for (k in 1:10) {
  pam_fit <- pam(df_std, k)
  costs[k] <- pam_fit$objective[1]   # suma de distancias intra-cluster
}

plot(1:10, costs, type = "b", pch = 19,
     xlab = "Número de clusters K",
     ylab = "Suma de distancias intra-cluster",
     main = "Método del codo con PAM")

#----------------------------------------------------------------------------------

sil_width <- numeric(9)
for (k in 2:10) {
  pam_fit <- pam(df_std, k)
  sil_width[k-1] <- pam_fit$silinfo$avg.width
}
plot(2:10, sil_width, type = "b", pch = 19,
     xlab = "Número de clusters K",
     ylab = "Silhouette promedio",
     main = "Selección de K con silhouette")

#----------------------------------------------------------------------------------

#K medoids con 2 clusters
resultado_k2 <- pam(df_std, k=2)

# Data frame con etiquetas cluster
df_plot_k2 <- as.data.frame(df_std)
df_plot_k2$cluster <- factor(resultado_k2$clustering)

# los medoides obtenidos
medoids_k2 <- as.data.frame(resultado_k2$medoids)


# Gráfico con ggplot
ggplot(df_plot_k2, aes(x = mass, y = period, color = cluster)) +
  geom_point(alpha = 0.6) +
  geom_point(data = medoids_k2, aes(x = mass, y = period),
             color = "red", size = 5, shape = 8) +
  labs(title = "Clusters PAM con 2 medoides")

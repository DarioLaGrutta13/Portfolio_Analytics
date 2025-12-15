rm(list = ls()) #Limpiar entorno

setwd("C:/Users/dario/OneDrive/Escritorio/Unab/Inferencia y Patrones/TP1")
vinos <- read.csv2("winequality-red.csv", dec = ".")

names(vinos)


library(dplyr)

#Escalamos el modelo
modelo <- lm(quality~., data = vinos )
summary(modelo)

#Estadísticamente significativas:
#volatile.acidity / chlorides /free.sulfur.dioxide /total.sulfur.dioxide /pH /sulphates /alcohol

vinos_reducido <- vinos[c("quality", "volatile.acidity", "chlorides",
                          "free.sulfur.dioxide",
                           "total.sulfur.dioxide",
                          "pH", "sulphates", "alcohol")]


#----------------------------------------------------------------------------------------
#Implementación de Análisi generado en el Libro complementario

library(leaps)
modelo1 <- regsubsets(quality~ ., vinos, nvmax = 11)
bestmodelo1 <- summary(modelo1)


names(bestmodelo1)
# "which"  "rsq"    "rss"    "adjr2"  "cp"     "bic"    "outmat" "obj"   

bestmodelo1$rsq
#0.2267344 0.3170024 0.3358973 0.3437824 0.3514942 0.3571736 0.3594709 0.3599265 0.3601728
#[10] 0.3602764 0.3605517

#Notamos que a mayor cantidad de variables mejora el Rsquared pero llegando a las últimas variables 
#estanca su valor ya no siendo tan significativa la agregacion de las mismas


#Graficamos para observar lo que esta pasando
par(mfrow = c(2, 1))


#Vemos la suma de los residuos al cuadrado y cómo disminuye al aumentar variables

plot(bestmodelo1$rss, xlab = "Num. de Variables",
       ylab = "RSS", type = "l")

#Rsquared ajustado y aumenta su relacion al agregar varables pero sobre el final cae levemente
plot(bestmodelo1$rsq, xlab = "Num. de Variables",
       ylab = "R²", type = "l")

#Se corrobora la seleccion de las variables estadisticamente más significativas

#--------------------------------------------------------------------------------
# Predicciones y particion del dataset

library(glmnet)
library(caret)

set.seed(123)
particion <- createDataPartition(vinos_reducido$quality, p = 0.8, list = FALSE )
train_set <- vinos_reducido[particion, ]
test_set <- vinos_reducido[-particion, ]

#Matrices para Ridge y Lasso

#glmnet requiere que las variables predictoras estén en formato de matriz y la variable respuesta 
#como vector numérico.

x_train <- model.matrix(quality ~ . , data = train_set)[, -1]  
y_train <- train_set$quality

x_test <- model.matrix(quality ~ . , data = test_set)[, -1]  
y_test <- test_set$quality

#definimos modelos con las variables finales para luego establecer predicciones
modelo.lineal <- lm(quality ~ ., data = train_set)

summary(modelo.lineal)

#-----------------------------------------------------------------------------------

# Mejor lambda, el que minimiza el MSE aplicando validación cruzada

#Ridge
cv_ridge <- cv.glmnet(x_train, y_train, alpha = 0)
ridgelambda <- cv_ridge$lambda.min


cat(
  "\n=========================================\n",
  sprintf("El mejor Lambda para Ridge es: %10.6f", ridgelambda),
  sprintf("\n=========================================\n")
)

#Lasso
cv_lasso <- cv.glmnet(x_train, y_train, alpha = 1)
lassolambda <- cv_lasso$lambda.min  


cat(
  "\n=========================================\n",
  sprintf("El mejor Lambda para Lasso es: %10.6f", lassolambda),
  sprintf("\n=========================================\n")
)
#-----------------------------------------------------------------------------------

#Predicciones de los modelos para futuras operaciones

pred.ridge <- predict(cv_ridge, s = ridgelambda, newx = x_test)
pred.lasso <- predict(cv_lasso, s = lassolambda, newx = x_test)
pred.lineal <- predict(modelo.lineal, newdata = test_set)

#-----------------------------------------------------------------------------------

#MSE

mse_ridge <- mean((y_test - pred.ridge)^2)
mse_lasso <- mean((y_test - pred.lasso)^2)
mse_lineal <- mean((y_test - pred.lineal)^2)

#-----------------------------------------------------------------------------------

# RMSE
rmse_ridge <- sqrt(mean((y_test - pred.ridge)^2))
rmse_lasso <- sqrt(mean((y_test - pred.lasso)^2))
rmse_lineal <- sqrt(mean((y_test - pred.lineal)^2))


#-----------------------------------------------------------------------------------

#r-squared

r2_ridge <- 1 - sum((y_test - pred.ridge)^2) / sum((y_test - mean(y_test))^2)
r2_lasso <- 1 - sum((y_test - pred.lasso)^2) / sum((y_test - mean(y_test))^2)
r2_lineal <- summary(modelo.lineal)$r.squared


#-----------------------------------------------------------------------------------

#Comparación Final de las Métricas

cat(
  "\n==================== COMPARACIÓN DE MODELOS =====================\n",
  sprintf("\n%-25s %10s %10s %10s", "Modelo", "MSE", "RMSE", "R²"),
  "\n---------------------------------------------------------------\n",
  sprintf("\n%-28s %10.6f %10.6f %10.6f", "Regresión Lineal", mse_lineal, rmse_lineal, r2_lineal),
  sprintf("\n%-27s %10.6f %10.6f %10.6f", "Ridge", mse_ridge, rmse_ridge, r2_ridge),
  sprintf("\n%-27s %10.6f %10.6f %10.6f", "Lasso", mse_lasso, rmse_lasso, r2_lasso),
  "\n================================================================\n"
)


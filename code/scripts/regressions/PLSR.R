# partial least squares regression
library(pls)

# import csv
credit = read.csv("data/scaled-credit.csv")

# import indices
source("code/scripts/Train-Test.R")

# set seed
set.seed(159)

pls_reg = plsr(as.vector(credit[train_set_indices, 12]) ~ as.matrix(credit[train_set_indices, 1:11]), 
validation = "CV")

#best model
library(pander)
bestmodel = which.min(pls_reg$validation$PRESS)

# plot CV errors MSEP
png("images/plsr-validation.png")
validationplot(pls_reg, val.type = "MSEP", main = "PLSR Cross Validated Error")
abline(v = 7, lty = 2)
dev.off()

###### prediction plot ################################################################### 
plot(predict(pls_reg, as.matrix(credit[test_set_indices, 1:11]), ncomp = bestmodel), 
     type = "l", col = "red",main = "PLSR Predicted and Actual Credit Balances", 
     ylab = "Normalized Credit Balance")

lines(credit[test_set_indices, 12], col = "black")

legend(0, 3, legend = c("Predicted", "Actual"), fill = c("red", "black"), bty = "n")
##########################################################################################

pls_tMSE = mean((pls_pred - credit[test_set_indices, 12])^2) 

# prediction on full data set
pls_final = plsr(as.vector(credit[ ,12]) ~ as.matrix(credit[ ,1:11]),
                      ncomp = bestmodel)

# save regressions
save(pls_reg, bestmodel, pls_tMSE, pls_final, file = "data/PLS-Regression.RData")




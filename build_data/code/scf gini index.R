library(haven)
yourData1 = read_dta("C:/Users/elisa/Documents/GitHub/ps1-data-elisataveras/build_data/output/dtascf.dta")

# define the vector of weights
w<-yourData1$wgt 

# select the vector of incomes (e.g., the incomes from transfers YTA)
y1<-yourData1$earning
y2<-yourData1$inc
y3<-yourData1$wealth


install.packages("acid")
library(acid)
giniE=weighted.gini(y1,w)[1]
giniI=weighted.gini(y2,w)[1]
giniw=weighted.gini(y3,w)[1]
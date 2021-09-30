#Load data

covid <- read.table("pblc_bhv_covid.csv",sep = ',', header=TRUE)

#Plot predictors against cases

with(covid,plot(distancing,cases))
with(covid,plot(bar_visit,cases))
with(covid,plot(large_events,cases))
with(covid,plot(mask_prop,cases))
with(covid,plot(other_mask_prop,cases))
with(covid,plot(public_transit,cases))
with(covid,plot(resto_visit,cases))
with(covid,plot(worked_outside,cases))

#Take some logs
with(covid,plot(log(distancing),cases))

#Compute cov matrix to detect for collinearity
cor_mat <- cor(as.matrix(subset(covid,select=-date)))

cor_mat[9,abs(cor_mat[9,])>0.6]


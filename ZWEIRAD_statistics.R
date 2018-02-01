cat("\014")
rm(list=ls(all=TRUE))
options(scipen = 999)
library(plyr) 
library(ggplot2)

# summarySE ---------------------------------------------------------------
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}
##########################################################################
##########################################################################

# Original data --------------------------------------------------------
Input<-"C:/work/Accident data/CIDAS_new database_20160206/R/"     #find directory new database
ZWEIRAD_1<-readRDS(paste(Input,"cd12_1.rds",sep = ""))
ZWEIRAD_2<-readRDS(paste(Input,"cd12_2.rds",sep = ""))
ZWEIRAD<-merge(ZWEIRAD_1,ZWEIRAD_2,all=T)                    #concatenate two tables
ZWEIRAD<-unique(ZWEIRAD)                                     #exclude duplicate data
ZWEIRAD<-ZWEIRAD[which(ZWEIRAD$ZWART != 14),]                #ZWART=14 has unknown element
Input_OLD<-"C:/work/Accident data/CIDAS_old database/2016Feb_R/"  #find directory old database
ZWEIRAD_OLD<-readRDS(paste(Input_OLD,"cd16.rds",sep = ""))
ZWEIRAD_OLD<-unique(ZWEIRAD_OLD)                             #exclude duplicate data

# Data preparation --------------------------------------------------------
BICYCLE_3<-subset(ZWEIRAD,ZWART == 3)                # 3- bicycle
BICYCLE_4<-subset(ZWEIRAD,ZWART == 4)                # 4- motorized bicycle
EBIKE_5<-subset(ZWEIRAD,ZWART == 5)                  # 5- pedal moped
EBIKE_6<-subset(ZWEIRAD,ZWART == 6)                  # 6- moped
EBIKE_7<-subset(ZWEIRAD,ZWART == 7)                  # 7- moped with less than 50 cc
OTHER<-subset(ZWEIRAD,ZWART == 8)                    # 8- other
UNKNOWN<-subset(ZWEIRAD,ZWART == 9)                  # 9- unknown
MOTORCYCLE_10<-subset(ZWEIRAD,ZWART == 10)           # 10- motorcyle with less than 125 cc
MOTORCYCLE_11<-subset(ZWEIRAD,ZWART == 11)           # 11- motorcycle
MOTORCYCLE_12<-subset(ZWEIRAD,ZWART == 12)           # 12- scooter up to 80 cc
MOTORCYCLE_13<-subset(ZWEIRAD,ZWART == 13)           # 13- scooter over 80 cc
MOTORCYCLE_14<-subset(ZWEIRAD,ZWART == 14)           # 14- motorcycle with sidecar
MOTORCYCLE_15<-subset(ZWEIRAD,ZWART == 15)           # 15- trike
MOTORCYCLE_16<-subset(ZWEIRAD,ZWART == 16)           # 16- quad

BICYCLE<-merge(BICYCLE_3,BICYCLE_4,all=T)                                         #catergory bicycle
EBIKE<-merge(merge(EBIKE_5,EBIKE_6,all=T),EBIKE_7,all=T)                          #category ebike
MOTORCYCLE<-merge(merge(MOTORCYCLE_10,MOTORCYCLE_11,all=T),MOTORCYCLE_13,all=T)   #category motorcycle

M1<-subset(ZWEIRAD_OLD,二轮车种类 == 1)                # 1- bicycle
M2<-subset(ZWEIRAD_OLD,二轮车种类 == 2)                # 2- 2-wheel unclassified
M3<-subset(ZWEIRAD_OLD,二轮车种类 == 3)                # 3- 2-wheel <50cc <40kph
M5<-subset(ZWEIRAD_OLD,二轮车种类 == 5)                # 5- 2-wheel >50cc >40kph

BICYCLE_OLD<-M1                                                                        #109 cases from 952
M2_MOTORCYCLE<-subset(M2,发动机类型 %in% c(1,2))
M2_EBIKE<-subset(M2,发动机类型 %in% c(3))
M3_MOTORCYCLE<-subset(M3,发动机类型 %in% c(1,2))
M3_EBIKE<-subset(M3,发动机类型 %in% c(3))
M5_MOTORCYCLE<-subset(M5,发动机类型 %in% c(1,2))
M5_EBIKE<-subset(M5,发动机类型 %in% c(3))
MOTORCYCLE_OLD<-merge(M2_MOTORCYCLE,merge(M3_MOTORCYCLE,M5_MOTORCYCLE,all=T),all=T)    #387 cases from 952
EBIKE_OLD<-merge(M2_EBIKE,merge(M3_EBIKE,M5_EBIKE,all=T),all=T)                        #351 cases from 952

# handlebar height ------------------------------------------------------------------
BICYCLE_HANDLEBAR_HEIGHT1<-BICYCLE$LENKH
BICYCLE_HANDLEBAR_HEIGHT2<-BICYCLE_OLD$车把离地高度
BICYCLE_HANDLEBAR_HEIGHT<-c(BICYCLE_HANDLEBAR_HEIGHT1,BICYCLE_HANDLEBAR_HEIGHT2)   #concatenate bicycle handlebar height data from 2 database
EBIKE_HANDLEBAR_HEIGHT1<-EBIKE$LENKH
EBIKE_HANDLEBAR_HEIGHT2<-EBIKE_OLD$车把离地高度
EBIKE_HANDLEBAR_HEIGHT<-c(EBIKE_HANDLEBAR_HEIGHT1,EBIKE_HANDLEBAR_HEIGHT2)
MOTORCYCLE_HANDLEBAR_HEIGHT1<-MOTORCYCLE$LENKH
MOTORCYCLE_HANDLEBAR_HEIGHT2<-MOTORCYCLE_OLD$车把离地高度
MOTORCYCLE_HANDLEBAR_HEIGHT<-c(MOTORCYCLE_HANDLEBAR_HEIGHT1,MOTORCYCLE_HANDLEBAR_HEIGHT2)

BICYCLE_HANDLEBAR_HEIGHT<-BICYCLE_HANDLEBAR_HEIGHT[which(!is.na(BICYCLE_HANDLEBAR_HEIGHT))]  #exclude NA
BICYCLE_HANDLEBAR_HEIGHT<-BICYCLE_HANDLEBAR_HEIGHT[which(BICYCLE_HANDLEBAR_HEIGHT!=999)]     #exclude 999 unkown state
EBIKE_HANDLEBAR_HEIGHT<-EBIKE_HANDLEBAR_HEIGHT[which(!is.na(EBIKE_HANDLEBAR_HEIGHT))]
EBIKE_HANDLEBAR_HEIGHT<-EBIKE_HANDLEBAR_HEIGHT[which(EBIKE_HANDLEBAR_HEIGHT!=999)]
MOTORCYCLE_HANDLEBAR_HEIGHT<-MOTORCYCLE_HANDLEBAR_HEIGHT[which(!is.na(MOTORCYCLE_HANDLEBAR_HEIGHT))]
MOTORCYCLE_HANDLEBAR_HEIGHT<-MOTORCYCLE_HANDLEBAR_HEIGHT[which(MOTORCYCLE_HANDLEBAR_HEIGHT!=999)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_HANDLEBAR_HEIGHT))            #get bicycle number
EBIKE_NUMBER<-as.numeric(length(EBIKE_HANDLEBAR_HEIGHT))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_HANDLEBAR_HEIGHT))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")                #define variable for figure title
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_HANDLEBAR_HEIGHT,EBIKE_HANDLEBAR_HEIGHT,MOTORCYCLE_HANDLEBAR_HEIGHT,outline=FALSE,ylim=(c(80,120)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Handlebar height',cex=1.5),ylab=list('height(cm)',cex=1))
text(1,97,'98',cex=0.9)          #add median value to figure
text(2,99,'100',cex=0.9)
text(3,97,'98',cex=0.9)
#####ggplot2 can only plot data frame####
HANDLEBAR_HEIGHT<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_HANDLEBAR_HEIGHT,EBIKE_HANDLEBAR_HEIGHT,MOTORCYCLE_HANDLEBAR_HEIGHT))
HANDLEBAR_HEIGHT_SUMMARY<-summarySE(HANDLEBAR_HEIGHT, measurevar="Value", groupvars="Type")  #get CI and SE of dataset
HANDLEBAR_HEIGHT_SUMMARY2<-HANDLEBAR_HEIGHT_SUMMARY
HANDLEBAR_HEIGHT_SUMMARY2$Type<-factor(HANDLEBAR_HEIGHT_SUMMARY2$Type)
ggplot(HANDLEBAR_HEIGHT_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(85,105))+                         #modify y label's interval
  ggtitle("handlebar height")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_HANDLEBAR_HEIGHT)
summary(EBIKE_HANDLEBAR_HEIGHT)
summary(MOTORCYCLE_HANDLEBAR_HEIGHT)
#standard deviation
sd(BICYCLE_HANDLEBAR_HEIGHT)   
sd(EBIKE_HANDLEBAR_HEIGHT)
sd(MOTORCYCLE_HANDLEBAR_HEIGHT)

# handlebar width ---------------------------------------------------------
BICYCLE_HANDLEBAR_WIDTH1<-BICYCLE$LENKB
BICYCLE_HANDLEBAR_WIDTH2<-BICYCLE_OLD$车把宽度.未知填999
BICYCLE_HANDLEBAR_WIDTH<-c(BICYCLE_HANDLEBAR_WIDTH1,BICYCLE_HANDLEBAR_WIDTH2)
EBIKE_HANDLEBAR_WIDTH1<-EBIKE$LENKB
EBIKE_HANDLEBAR_WIDTH2<-EBIKE_OLD$车把宽度.未知填999
EBIKE_HANDLEBAR_WIDTH<-c(EBIKE_HANDLEBAR_WIDTH1,EBIKE_HANDLEBAR_WIDTH2)
MOTORCYCLE_HANDLEBAR_WIDTH1<-MOTORCYCLE$LENKB
MOTORCYCLE_HANDLEBAR_WIDTH2<-MOTORCYCLE_OLD$车把宽度.未知填999
MOTORCYCLE_HANDLEBAR_WIDTH<-c(MOTORCYCLE_HANDLEBAR_WIDTH1,MOTORCYCLE_HANDLEBAR_WIDTH2)

BICYCLE_HANDLEBAR_WIDTH<-BICYCLE_HANDLEBAR_WIDTH[which(!is.na(BICYCLE_HANDLEBAR_WIDTH))]
BICYCLE_HANDLEBAR_WIDTH<-BICYCLE_HANDLEBAR_WIDTH[which(BICYCLE_HANDLEBAR_WIDTH!=999)]
EBIKE_HANDLEBAR_WIDTH<-EBIKE_HANDLEBAR_WIDTH[which(!is.na(EBIKE_HANDLEBAR_WIDTH))]
EBIKE_HANDLEBAR_WIDTH<-EBIKE_HANDLEBAR_WIDTH[which(EBIKE_HANDLEBAR_WIDTH!=999)]
MOTORCYCLE_HANDLEBAR_WIDTH<-MOTORCYCLE_HANDLEBAR_WIDTH[which(!is.na(MOTORCYCLE_HANDLEBAR_WIDTH))]
MOTORCYCLE_HANDLEBAR_WIDTH<-MOTORCYCLE_HANDLEBAR_WIDTH[which(MOTORCYCLE_HANDLEBAR_WIDTH!=999)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_HANDLEBAR_WIDTH))
EBIKE_NUMBER<-as.numeric(length(EBIKE_HANDLEBAR_WIDTH))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_HANDLEBAR_WIDTH))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_HANDLEBAR_WIDTH,EBIKE_HANDLEBAR_WIDTH,MOTORCYCLE_HANDLEBAR_WIDTH,outline=FALSE,ylim=(c(40,80)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Handlebar width',cex=1.5),ylab=list('width(cm)',cex=1))
text(1,54,'55',cex=0.9)
text(2,62,'63',cex=0.9)
text(3,66,'67',cex=0.9)

HANDLEBAR_WIDTH<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_HANDLEBAR_WIDTH,EBIKE_HANDLEBAR_WIDTH,MOTORCYCLE_HANDLEBAR_WIDTH))
HANDLEBAR_WIDTH_SUMMARY<-summarySE(HANDLEBAR_WIDTH, measurevar="Value", groupvars="Type")
HANDLEBAR_WIDTH_SUMMARY2<-HANDLEBAR_WIDTH_SUMMARY
HANDLEBAR_WIDTH_SUMMARY2$Type<-factor(HANDLEBAR_WIDTH_SUMMARY2$Type)
ggplot(HANDLEBAR_WIDTH_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(50,70))+                         #modify section
  ggtitle("handlebar width")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_HANDLEBAR_WIDTH)
summary(EBIKE_HANDLEBAR_WIDTH)
summary(MOTORCYCLE_HANDLEBAR_WIDTH)

sd(BICYCLE_HANDLEBAR_WIDTH)
sd(EBIKE_HANDLEBAR_WIDTH)
sd(MOTORCYCLE_HANDLEBAR_WIDTH)

# saddle height -----------------------------------------------------------
BICYCLE_SADDLE_HEIGHT1<-BICYCLE$SATTH
BICYCLE_SADDLE_HEIGHT2<-BICYCLE_OLD$座垫离地高度
BICYCLE_SADDLE_HEIGHT<-c(BICYCLE_SADDLE_HEIGHT1,BICYCLE_SADDLE_HEIGHT2)
EBIKE_SADDLE_HEIGHT1<-EBIKE$SATTH
EBIKE_SADDLE_HEIGHT2<-EBIKE_OLD$座垫离地高度
EBIKE_SADDLE_HEIGHT<-c(EBIKE_SADDLE_HEIGHT1,EBIKE_SADDLE_HEIGHT2)
MOTORCYCLE_SADDLE_HEIGHT1<-MOTORCYCLE$SATTH
MOTORCYCLE_SADDLE_HEIGHT2<-MOTORCYCLE_OLD$座垫离地高度
MOTORCYCLE_SADDLE_HEIGHT<-c(MOTORCYCLE_SADDLE_HEIGHT1,MOTORCYCLE_SADDLE_HEIGHT2)

BICYCLE_SADDLE_HEIGHT<-BICYCLE_SADDLE_HEIGHT[which(!is.na(BICYCLE_SADDLE_HEIGHT))]
BICYCLE_SADDLE_HEIGHT<-BICYCLE_SADDLE_HEIGHT[which(BICYCLE_SADDLE_HEIGHT!=999)]
EBIKE_SADDLE_HEIGHT<-EBIKE_SADDLE_HEIGHT[which(!is.na(EBIKE_SADDLE_HEIGHT))]
EBIKE_SADDLE_HEIGHT<-EBIKE_SADDLE_HEIGHT[which(EBIKE_SADDLE_HEIGHT!=999)]
MOTORCYCLE_SADDLE_HEIGHT<-MOTORCYCLE_SADDLE_HEIGHT[which(!is.na(MOTORCYCLE_SADDLE_HEIGHT))]
MOTORCYCLE_SADDLE_HEIGHT<-MOTORCYCLE_SADDLE_HEIGHT[which(MOTORCYCLE_SADDLE_HEIGHT!=999&MOTORCYCLE_SADDLE_HEIGHT>30)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_SADDLE_HEIGHT))
EBIKE_NUMBER<-as.numeric(length(EBIKE_SADDLE_HEIGHT))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_SADDLE_HEIGHT))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_SADDLE_HEIGHT,EBIKE_SADDLE_HEIGHT,MOTORCYCLE_SADDLE_HEIGHT,outline=FALSE,ylim=(c(60,100)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Saddle',cex=1.5),ylab=list('height(cm)',cex=1))
text(1,81,'82',cex=0.9)
text(2,74,'75',cex=0.9)
text(3,76,'77',cex=0.9)

SADDLE_HEIGHT<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_SADDLE_HEIGHT,EBIKE_SADDLE_HEIGHT,MOTORCYCLE_SADDLE_HEIGHT))
SADDLE_HEIGHT_SUMMARY<-summarySE(SADDLE_HEIGHT, measurevar="Value", groupvars="Type")
SADDLE_HEIGHT_SUMMARY2<-SADDLE_HEIGHT_SUMMARY
SADDLE_HEIGHT_SUMMARY2$Type<-factor(SADDLE_HEIGHT_SUMMARY2$Type)
ggplot(SADDLE_HEIGHT_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(65,85))+                         #modify section
  ggtitle("saddle height")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_SADDLE_HEIGHT)
summary(EBIKE_SADDLE_HEIGHT)
summary(MOTORCYCLE_SADDLE_HEIGHT)

sd(BICYCLE_SADDLE_HEIGHT)
sd(EBIKE_SADDLE_HEIGHT)
sd(MOTORCYCLE_SADDLE_HEIGHT)

# distance handle bar to bench --------------------------------------------
BICYCLE_DISTANCE1<-BICYCLE$LENKSAT
BICYCLE_DISTANCE2<-BICYCLE_OLD$鞍状座垫中心至把手中心的距离
BICYCLE_DISTANCE<-c(BICYCLE_DISTANCE1,BICYCLE_DISTANCE2)
EBIKE_DISTANCE1<-EBIKE$LENKSAT
EBIKE_DISTANCE2<-EBIKE_OLD$鞍状座垫中心至把手中心的距离
EBIKE_DISTANCE<-c(EBIKE_DISTANCE1,EBIKE_DISTANCE2)
MOTORCYCLE_DISTANCE1<-MOTORCYCLE$LENKSAT
MOTORCYCLE_DISTANCE2<-MOTORCYCLE_OLD$鞍状座垫中心至把手中心的距离
MOTORCYCLE_DISTANCE<-c(MOTORCYCLE_DISTANCE1,MOTORCYCLE_DISTANCE2)

BICYCLE_DISTANCE<-BICYCLE_DISTANCE[which(!is.na(BICYCLE_DISTANCE))]
BICYCLE_DISTANCE<-BICYCLE_DISTANCE[which(BICYCLE_DISTANCE<200)]
EBIKE_DISTANCE<-EBIKE_DISTANCE[which(!is.na(EBIKE_DISTANCE))]
EBIKE_DISTANCE<-EBIKE_DISTANCE[which(EBIKE_DISTANCE<200&EBIKE_DISTANCE>20)]
MOTORCYCLE_DISTANCE<-MOTORCYCLE_DISTANCE[which(!is.na(MOTORCYCLE_DISTANCE))]
MOTORCYCLE_DISTANCE<-MOTORCYCLE_DISTANCE[which(MOTORCYCLE_DISTANCE<200&MOTORCYCLE_DISTANCE>20)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_DISTANCE))
EBIKE_NUMBER<-as.numeric(length(EBIKE_DISTANCE))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_DISTANCE))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_DISTANCE,EBIKE_DISTANCE,MOTORCYCLE_DISTANCE,outline=FALSE,ylim=(c(30,120)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Distance handle bar to bench',cex=1.5),ylab=list('distance(cm)',cex=1))
text(1,53,'55',cex=0.9)
text(2,58,'60',cex=0.9)
text(3,64,'66',cex=0.9)

DISTANCE<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_DISTANCE,EBIKE_DISTANCE,MOTORCYCLE_DISTANCE))
DISTANCE_SUMMARY<-summarySE(DISTANCE, measurevar="Value", groupvars="Type")
DISTANCE_SUMMARY2<-DISTANCE_SUMMARY
DISTANCE_SUMMARY2$Type<-factor(DISTANCE_SUMMARY2$Type)
ggplot(DISTANCE_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(52,72))+                         #modify section
  ggtitle("distance handlerbar to bench")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_DISTANCE)
summary(EBIKE_DISTANCE)
summary(MOTORCYCLE_DISTANCE)

sd(BICYCLE_DISTANCE)
sd(EBIKE_DISTANCE)
sd(MOTORCYCLE_DISTANCE)

# overall length ----------------------------------------------------------
BICYCLE_OVERALL_LENGTH1<-BICYCLE$ZLANG
BICYCLE_OVERALL_LENGTH2<-BICYCLE_OLD$总长度.未知填999
BICYCLE_OVERALL_LENGTH<-c(BICYCLE_OVERALL_LENGTH1,BICYCLE_OVERALL_LENGTH2)
EBIKE_OVERALL_LENGTH1<-EBIKE$ZLANG
EBIKE_OVERALL_LENGTH2<-EBIKE_OLD$总长度.未知填999
EBIKE_OVERALL_LENGTH<-c(EBIKE_OVERALL_LENGTH1,EBIKE_OVERALL_LENGTH2)
MOTORCYCLE_OVERALL_LENGTH1<-MOTORCYCLE$ZLANG
MOTORCYCLE_OVERALL_LENGTH2<-MOTORCYCLE_OLD$总长度.未知填999
MOTORCYCLE_OVERALL_LENGTH<-c(MOTORCYCLE_OVERALL_LENGTH1,MOTORCYCLE_OVERALL_LENGTH2)

BICYCLE_OVERALL_LENGTH<-BICYCLE_OVERALL_LENGTH[which(!is.na(BICYCLE_OVERALL_LENGTH))]
BICYCLE_OVERALL_LENGTH<-BICYCLE_OVERALL_LENGTH[which(BICYCLE_OVERALL_LENGTH<500)]
EBIKE_OVERALL_LENGTH<-EBIKE_OVERALL_LENGTH[which(!is.na(EBIKE_OVERALL_LENGTH))]
EBIKE_OVERALL_LENGTH<-EBIKE_OVERALL_LENGTH[which(EBIKE_OVERALL_LENGTH<350)]
MOTORCYCLE_OVERALL_LENGTH<-MOTORCYCLE_OVERALL_LENGTH[which(!is.na(MOTORCYCLE_OVERALL_LENGTH))]
MOTORCYCLE_OVERALL_LENGTH<-MOTORCYCLE_OVERALL_LENGTH[which(MOTORCYCLE_OVERALL_LENGTH<500&MOTORCYCLE_OVERALL_LENGTH>50)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_OVERALL_LENGTH))
EBIKE_NUMBER<-as.numeric(length(EBIKE_OVERALL_LENGTH))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_OVERALL_LENGTH))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_OVERALL_LENGTH,EBIKE_OVERALL_LENGTH,MOTORCYCLE_OVERALL_LENGTH,outline=FALSE,ylim=(c(130,230)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Overall length',cex=1.5),ylab=list('length(cm)',cex=1))
text(1,163,'165',cex=0.9)
text(2,172,'174',cex=0.9)
text(3,188,'190',cex=0.9)

OVERALL_LENGTH<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_OVERALL_LENGTH,EBIKE_OVERALL_LENGTH,MOTORCYCLE_OVERALL_LENGTH))
OVERALL_LENGTH_SUMMARY<-summarySE(OVERALL_LENGTH, measurevar="Value", groupvars="Type")
OVERALL_LENGTH_SUMMARY2<-OVERALL_LENGTH_SUMMARY
OVERALL_LENGTH_SUMMARY2$Type<-factor(OVERALL_LENGTH_SUMMARY2$Type)
ggplot(OVERALL_LENGTH_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(150,190))+                         #modify section
  ggtitle("overall length")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_OVERALL_LENGTH)
summary(EBIKE_OVERALL_LENGTH)
summary(MOTORCYCLE_OVERALL_LENGTH)

sd(BICYCLE_OVERALL_LENGTH)
sd(EBIKE_OVERALL_LENGTH)
sd(MOTORCYCLE_OVERALL_LENGTH)

# maximum width -----------------------------------------------------------
BICYCLE_MAXIMUM_WIDTH1<-BICYCLE$ZBREIT
BICYCLE_MAXIMUM_WIDTH2<-BICYCLE_OLD$车最宽处宽度.未知填999
BICYCLE_MAXIMUM_WIDTH<-c(BICYCLE_MAXIMUM_WIDTH1,BICYCLE_MAXIMUM_WIDTH2)
EBIKE_MAXIMUM_WIDTH1<-EBIKE$ZBREIT
EBIKE_MAXIMUM_WIDTH2<-EBIKE_OLD$车最宽处宽度.未知填999
EBIKE_MAXIMUM_WIDTH<-c(EBIKE_MAXIMUM_WIDTH1,EBIKE_MAXIMUM_WIDTH2)
MOTORCYCLE_MAXIMUM_WIDTH1<-MOTORCYCLE$ZBREIT
MOTORCYCLE_MAXIMUM_WIDTH2<-MOTORCYCLE_OLD$车最宽处宽度.未知填999
MOTORCYCLE_MAXIMUM_WIDTH<-c(MOTORCYCLE_MAXIMUM_WIDTH1,MOTORCYCLE_MAXIMUM_WIDTH2)

BICYCLE_MAXIMUM_WIDTH<-BICYCLE_MAXIMUM_WIDTH[which(!is.na(BICYCLE_MAXIMUM_WIDTH))]
BICYCLE_MAXIMUM_WIDTH<-BICYCLE_MAXIMUM_WIDTH[which(BICYCLE_MAXIMUM_WIDTH<200)]
EBIKE_MAXIMUM_WIDTH<-EBIKE_MAXIMUM_WIDTH[which(!is.na(EBIKE_MAXIMUM_WIDTH))]
EBIKE_MAXIMUM_WIDTH<-EBIKE_MAXIMUM_WIDTH[which(EBIKE_MAXIMUM_WIDTH<200)]
MOTORCYCLE_MAXIMUM_WIDTH<-MOTORCYCLE_MAXIMUM_WIDTH[which(!is.na(MOTORCYCLE_MAXIMUM_WIDTH))]
MOTORCYCLE_MAXIMUM_WIDTH<-MOTORCYCLE_MAXIMUM_WIDTH[which(MOTORCYCLE_MAXIMUM_WIDTH<200)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_MAXIMUM_WIDTH))
EBIKE_NUMBER<-as.numeric(length(EBIKE_MAXIMUM_WIDTH))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_MAXIMUM_WIDTH))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_MAXIMUM_WIDTH,EBIKE_MAXIMUM_WIDTH,MOTORCYCLE_MAXIMUM_WIDTH,outline=FALSE,ylim=(c(40,90)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Maximum width',cex=1.5),ylab=list('width(cm)',cex=1))
text(1,57,'55.5',cex=0.9)
text(2,65.5,'64',cex=0.9)
text(3,71.5,'70',cex=0.9)

MAXIMUM_WIDTH<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_MAXIMUM_WIDTH,EBIKE_MAXIMUM_WIDTH,MOTORCYCLE_MAXIMUM_WIDTH))
MAXIMUM_WIDTH_SUMMARY<-summarySE(MAXIMUM_WIDTH, measurevar="Value", groupvars="Type")
MAXIMUM_WIDTH_SUMMARY2<-MAXIMUM_WIDTH_SUMMARY
MAXIMUM_WIDTH_SUMMARY2$Type<-factor(MAXIMUM_WIDTH_SUMMARY2$Type)
ggplot(MAXIMUM_WIDTH_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(51,71))+                         #modify section
  ggtitle("maximum width")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_MAXIMUM_WIDTH)
summary(EBIKE_MAXIMUM_WIDTH)
summary(MOTORCYCLE_MAXIMUM_WIDTH)

sd(BICYCLE_MAXIMUM_WIDTH)
sd(EBIKE_MAXIMUM_WIDTH)
sd(MOTORCYCLE_MAXIMUM_WIDTH)

# wheelbase ---------------------------------------------------------------
BICYCLE_WHEELBASE1<-BICYCLE$RADST
BICYCLE_WHEELBASE2<-BICYCLE_OLD$轴距
BICYCLE_WHEELBASE<-c(BICYCLE_WHEELBASE1,BICYCLE_WHEELBASE2)
EBIKE_WHEELBASE1<-EBIKE$RADST
EBIKE_WHEELBASE2<-EBIKE_OLD$轴距
EBIKE_WHEELBASE<-c(EBIKE_WHEELBASE1,EBIKE_WHEELBASE2)
MOTORCYCLE_WHEELBASE1<-MOTORCYCLE$RADST
MOTORCYCLE_WHEELBASE2<-MOTORCYCLE_OLD$轴距
MOTORCYCLE_WHEELBASE<-c(MOTORCYCLE_WHEELBASE1,MOTORCYCLE_WHEELBASE2)

BICYCLE_WHEELBASE<-BICYCLE_WHEELBASE[which(!is.na(BICYCLE_WHEELBASE))]
BICYCLE_WHEELBASE<-BICYCLE_WHEELBASE[which(BICYCLE_WHEELBASE<200)]
EBIKE_WHEELBASE<-EBIKE_WHEELBASE[which(!is.na(EBIKE_WHEELBASE))]
EBIKE_WHEELBASE<-EBIKE_WHEELBASE[which(EBIKE_WHEELBASE<200)]
MOTORCYCLE_WHEELBASE<-MOTORCYCLE_WHEELBASE[which(!is.na(MOTORCYCLE_WHEELBASE))]
MOTORCYCLE_WHEELBASE<-MOTORCYCLE_WHEELBASE[which(MOTORCYCLE_WHEELBASE<200)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_WHEELBASE))
EBIKE_NUMBER<-as.numeric(length(EBIKE_WHEELBASE))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_WHEELBASE))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_WHEELBASE,EBIKE_WHEELBASE,MOTORCYCLE_WHEELBASE,outline=FALSE,ylim=(c(85,145)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Wheelbase',cex=1.5),ylab=list('length(cm)',cex=1))
text(1,102.5,'104',cex=0.9)
text(2,118.5,'120',cex=0.9)
text(3,120.5,'122',cex=0.9)

WHEELBASE<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_WHEELBASE,EBIKE_WHEELBASE,MOTORCYCLE_WHEELBASE))
WHEELBASE_SUMMARY<-summarySE(WHEELBASE, measurevar="Value", groupvars="Type")
WHEELBASE_SUMMARY2<-WHEELBASE_SUMMARY
WHEELBASE_SUMMARY2$Type<-factor(WHEELBASE_SUMMARY2$Type)
ggplot(WHEELBASE_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(98,125))+                         #modify section
  ggtitle("wheelbase")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_WHEELBASE)
summary(EBIKE_WHEELBASE)
summary(MOTORCYCLE_WHEELBASE)

sd(BICYCLE_WHEELBASE)
sd(EBIKE_WHEELBASE)
sd(MOTORCYCLE_WHEELBASE)

# unladen weight ----------------------------------------------------------
BICYCLE_999<-BICYCLE[which(BICYCLE$LLCKZZL != 999),]
BICYCLE_9999<-BICYCLE_999[which(BICYCLE_999$LLCKZZL != 9999),]
BICYCLE_99999<-BICYCLE_9999[which(BICYCLE_9999$LLCKZZL != 99999),]

EBIKE_999<-EBIKE[which(EBIKE$LLCKZZL != 999),]
EBIKE_9999<-EBIKE_999[which(EBIKE_999$LLCKZZL != 9999),]
EBIKE_99999<-EBIKE_9999[which(EBIKE_9999$LLCKZZL != 99999),]

MOTORCYCLE_999<-MOTORCYCLE[which(MOTORCYCLE$LLCKZZL != 999),]
MOTORCYCLE_9999<-MOTORCYCLE_999[which(MOTORCYCLE_999$LLCKZZL != 9999),]
MOTORCYCLE_99999<-MOTORCYCLE_9999[which(MOTORCYCLE_9999$LLCKZZL != 99999),]

BICYCLE_UNLADEN_WEIGHT<-c(BICYCLE_99999$LLCKZZL)
EBIKE_UNLADEN_WEIGHT<-c(EBIKE_99999$LLCKZZL)
MOTORCYCLE_UNLADEN_WEIGHT<-c(MOTORCYCLE_99999$LLCKZZL)

BICYCLE_UNLADEN_WEIGHT<-BICYCLE_UNLADEN_WEIGHT[which(!is.na(BICYCLE_UNLADEN_WEIGHT))]
BICYCLE_UNLADEN_WEIGHT<-BICYCLE_UNLADEN_WEIGHT[which(BICYCLE_UNLADEN_WEIGHT<60)]
EBIKE_UNLADEN_WEIGHT<-EBIKE_UNLADEN_WEIGHT[which(!is.na(EBIKE_UNLADEN_WEIGHT))]
EBIKE_UNLADEN_WEIGHT<-EBIKE_UNLADEN_WEIGHT[which(EBIKE_UNLADEN_WEIGHT<100)]
MOTORCYCLE_UNLADEN_WEIGHT<-MOTORCYCLE_UNLADEN_WEIGHT[which(!is.na(MOTORCYCLE_UNLADEN_WEIGHT))]
MOTORCYCLE_UNLADEN_WEIGHT<-MOTORCYCLE_UNLADEN_WEIGHT[which(MOTORCYCLE_UNLADEN_WEIGHT<200)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_UNLADEN_WEIGHT))
EBIKE_NUMBER<-as.numeric(length(EBIKE_UNLADEN_WEIGHT))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_UNLADEN_WEIGHT))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

boxplot(BICYCLE_UNLADEN_WEIGHT,EBIKE_UNLADEN_WEIGHT,MOTORCYCLE_UNLADEN_WEIGHT,outline=FALSE,col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Unladen weight',cex=1.5),ylab=list('weight(kg)',cex=1))
text(1,24,'20',cex=0.9)
text(2,64,'60',cex=0.9)
text(3,109,'105',cex=0.9)

UNLADEN_WEIGHT<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_UNLADEN_WEIGHT,EBIKE_UNLADEN_WEIGHT,MOTORCYCLE_UNLADEN_WEIGHT))
UNLADEN_WEIGHT_SUMMARY<-summarySE(UNLADEN_WEIGHT, measurevar="Value", groupvars="Type")
UNLADEN_WEIGHT_SUMMARY2<-UNLADEN_WEIGHT_SUMMARY
UNLADEN_WEIGHT_SUMMARY2$Type<-factor(UNLADEN_WEIGHT_SUMMARY2$Type)
ggplot(UNLADEN_WEIGHT_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(0,105))+                         #modify section
  ggtitle("unladen weight")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_UNLADEN_WEIGHT)
summary(EBIKE_UNLADEN_WEIGHT)
summary(MOTORCYCLE_UNLADEN_WEIGHT)

sd(BICYCLE_UNLADEN_WEIGHT)
sd(EBIKE_UNLADEN_WEIGHT)
sd(MOTORCYCLE_UNLADEN_WEIGHT)

# TYRE --------------------------------------------------------------------
TYRE<-read.csv("C:/work/Accident data/tyre.csv")
BICYCLE_TYRE<-subset(TYRE,ZWART %in% c(3,4))
EBIKE_TYRE<-subset(TYRE,ZWART %in% c(5,6,7))
MOTORCYCLE_TYRE<-subset(TYRE,ZWART %in% c(10,11,13))

BICYCLE_TYRE_DIAMETER<-c(BICYCLE_TYRE$FTYRE)
EBIKE_TYRE_DIAMETER<-c(EBIKE_TYRE$ZRFDV)
MOTORCYCLE_TYRE_DIAMETER<-c(MOTORCYCLE_TYRE$ZRFDV)

BICYCLE_TYRE_DIAMETER<-BICYCLE_TYRE_DIAMETER[which(!is.na(BICYCLE_TYRE_DIAMETER))]
BICYCLE_TYRE_DIAMETER<-BICYCLE_TYRE_DIAMETER[which(BICYCLE_TYRE_DIAMETER<50)]
EBIKE_TYRE_DIAMETER<-EBIKE_TYRE_DIAMETER[which(!is.na(EBIKE_TYRE_DIAMETER))]
EBIKE_TYRE_DIAMETER<-EBIKE_TYRE_DIAMETER[which(EBIKE_TYRE_DIAMETER<50&EBIKE_TYRE_DIAMETER>0)]
MOTORCYCLE_TYRE_DIAMETER<-MOTORCYCLE_TYRE_DIAMETER[which(!is.na(MOTORCYCLE_TYRE_DIAMETER))]
MOTORCYCLE_TYRE_DIAMETER<-MOTORCYCLE_TYRE_DIAMETER[which(MOTORCYCLE_TYRE_DIAMETER<50)]
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_TYRE_DIAMETER))
EBIKE_NUMBER<-as.numeric(length(EBIKE_TYRE_DIAMETER))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_TYRE_DIAMETER))
bicycle<-paste('bicycle','(',BICYCLE_NUMBER,')',sep="")
ebike<-paste('ebike','(',EBIKE_NUMBER,')',sep="")
motorcycle<-paste('motorcycle','(',MOTORCYCLE_NUMBER,')',sep="")

BICYCLE_TYRE_DIAMETER<-2.54*BICYCLE_TYRE_DIAMETER
EBIKE_TYRE_DIAMETER<-2.54*EBIKE_TYRE_DIAMETER
MOTORCYCLE_TYRE_DIAMETER<-2.54*MOTORCYCLE_TYRE_DIAMETER

boxplot(BICYCLE_TYRE_DIAMETER,EBIKE_TYRE_DIAMETER,MOTORCYCLE_TYRE_DIAMETER,outline=FALSE,ylim=(c(15,75)),col='bisque1',names=c(bicycle,ebike,motorcycle))
title(main=list('Tyre diameter',cex=1.5),ylab=list('diameter(cm)',cex=1))
text(1,59.3,'61',cex=0.9)
text(2,39,'41',cex=0.9)
text(3,41.7,'43',cex=0.9)

TYRE_DIAMETER<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER),rep("ebike",EBIKE_NUMBER),rep("motorcycle",MOTORCYCLE_NUMBER)),Value=c(BICYCLE_TYRE_DIAMETER,EBIKE_TYRE_DIAMETER,MOTORCYCLE_TYRE_DIAMETER))
TYRE_DIAMETER_SUMMARY<-summarySE(TYRE_DIAMETER, measurevar="Value", groupvars="Type")
TYRE_DIAMETER_SUMMARY2<-TYRE_DIAMETER_SUMMARY
TYRE_DIAMETER_SUMMARY2$Type<-factor(TYRE_DIAMETER_SUMMARY2$Type)
ggplot(TYRE_DIAMETER_SUMMARY2, aes(x=Type, y=Value)) + 
  geom_bar(position=position_dodge(), stat="identity",width=.5,aes(fill=Type)) +   #add type
  geom_errorbar(aes(ymin=Value-ci, ymax=Value+ci),
                width=.2,color='black',                    # Width of the error bars
                position=position_dodge(.9))+
  geom_text(aes(label = round(Value,0)), vjust = 5.5, colour = "black")+  #add label and adjust label position
  coord_cartesian(ylim=c(30,62))+                         #modify section
  ggtitle("tyre diameter")+
  theme(plot.title=element_text(hjust=0.5)) +              #put the title in the middle
  guides(fill=FALSE)                                       #delete legend

summary(BICYCLE_TYRE_DIAMETER)
summary(EBIKE_TYRE_DIAMETER)
summary(MOTORCYCLE_TYRE_DIAMETER)

sd(BICYCLE_TYRE_DIAMETER)
sd(EBIKE_TYRE_DIAMETER)
sd(MOTORCYCLE_TYRE_DIAMETER)

########cluster analysis#########
BICYCLE_999<-BICYCLE[which(BICYCLE$LLCKZZL != 999),]
BICYCLE_9999<-BICYCLE_999[which(BICYCLE_999$LLCKZZL != 9999),]
BICYCLE_99999<-BICYCLE_9999[which(BICYCLE_9999$LLCKZZL != 99999),]

EBIKE_999<-EBIKE[which(EBIKE$LLCKZZL != 999),]
EBIKE_9999<-EBIKE_999[which(EBIKE_999$LLCKZZL != 9999),]
EBIKE_99999<-EBIKE_9999[which(EBIKE_9999$LLCKZZL != 99999),]

MOTORCYCLE_999<-MOTORCYCLE[which(MOTORCYCLE$LLCKZZL != 999),]
MOTORCYCLE_9999<-MOTORCYCLE_999[which(MOTORCYCLE_999$LLCKZZL != 9999),]
MOTORCYCLE_99999<-MOTORCYCLE_9999[which(MOTORCYCLE_9999$LLCKZZL != 99999),]

BICYCLE_K<-BICYCLE_99999[which(BICYCLE_99999$LLCKZZL<60),]
EBIKE_K<-EBIKE_99999[which(EBIKE_99999$LLCKZZL<100),]
MOTORCYCLE_K<-MOTORCYCLE_99999[which(MOTORCYCLE_99999$LLCKZZL<200),]
BICYCLE_K<-subset(BICYCLE_K,select=c(FALL,LLCKZZL)) 
EBIKE_K<-subset(EBIKE_K,select=c(FALL,LLCKZZL)) 
MOTORCYCLE_K<-subset(MOTORCYCLE_K,select=c(FALL,LLCKZZL)) 
BICYCLE_NUMBER<-as.numeric(length(BICYCLE_K$LLCKZZL))
EBIKE_NUMBER<-as.numeric(length(EBIKE_K$LLCKZZL))
MOTORCYCLE_NUMBER<-as.numeric(length(MOTORCYCLE_K$LLCKZZL))
BICYCLE_K<-data.frame(Type=c(rep("bicycle",BICYCLE_NUMBER)),BICYCLE_K)
EBIKE_K<-data.frame(Type=c(rep("ebike",EBIKE_NUMBER)),EBIKE_K)
MOTORCYCLE_K<-data.frame(Type=c(rep("motorcycle",MOTORCYCLE_NUMBER)),MOTORCYCLE_K)
LLC<-merge(BICYCLE_K,merge(EBIKE_K,MOTORCYCLE_K,all=T),all=T) 
#write.csv(LLC,file="2 wheeler.csv")

x=BICYCLE_K$LLCKZZL
y=BICYCLE_K$ZLANG
x1=EBIKE_K$LLCKZZL
y1=EBIKE_K$ZLANG
x2=MOTORCYCLE_K$LLCKZZL
y2=MOTORCYCLE_K$ZLANG
plot(x,y,xlim=c(0,180),ylim=c(100,250),pch=4,col='red',main='2-wheeler distribution',xlab=list('weight(kg)',cex=1),ylab=list('length(cm)',cex=1))
points(x1,y1,pch=4,col='blue')
points(x2,y2,pch=4,col='green')
legend('topright',pch=4,c("BICYCLE","E-BIKE","MOTORCYCLE"),col=c('red','blue','green'),cex=0.8)


#Video submission of presentation
https://youtu.be/aO4Jndr4vVw

#Project Starts Here
Project=read.csv(file.choose(),header = TRUE)
Project

library(ggplot2)
library(dplyr)
library("tidyverse")

summary(Project$Attrition)

table(Project$Attrition)
prop.table(table(Project$Attrition))*100
ggplot(Project, aes(x=Attrition, fill=Attrition))+geom_bar()+labs(title="Employee Attrition",x="Attrition",y="Number of Employees")

table(Project$OverTime, Project$Attrition)
prop.table(table(Project$OverTime, Project$Attrition),margin=1)*100
ggplot(Project, aes(x=OverTime, fill=Attrition))+geom_bar(position="fill")+scale_y_continuous(labels=scales::percent)+labs(title="Attrition Rate by Overtime",x="Overtime",y="Percentage Attrition")

Project$AgeGroup = cut(Project$Age,breaks=c(0,25,35,45,55,Inf),labels=c("25 and Under","26-35","36-45","46-55","Over 55"))
table(Project$AgeGroup, Project$Attrition)
prop.table(table(Project$AgeGroup, Project$Attrition),margin=1)*100
ggplot(Project,aes(x=AgeGroup,fill=Attrition))+geom_bar(position="fill")+scale_y_continuous(labels=scales::percent)+labs(title="Employee Attrition by Age Group",x="Age Group",y="Percentage of Employees")

table(Project$JobSatisfaction, Project$Attrition)
prop.table(table(Project$JobSatisfaction, Project$Attrition),margin=1)*100
ggplot(Project, aes(x=factor(JobSatisfaction), fill=Attrition))+geom_bar(position="fill")+scale_y_continuous(labels=scales::percent)+labs(title="Attrition by Job Satisfaction",x="Job Satisfaction Level",y="Percentage")

round(prop.table(table(Project$EducationField,Project$Attrition),margin=1)*100,2)
ggplot(data=Project, mapping=aes(x=EducationField, y=MonthlyIncome,color=Attrition))+geom_boxplot()

Project$MonthlyIncomeGroup = cut(Project$MonthlyIncome,breaks=c(0,5000, 10000, 15000, Inf),labels=c("Less than $5000","$5000-$10000","$10000-$15000","Over $15000"))
table(Project$MonthlyIncomeGroup, Project$Attrition)
prop.table(table(Project$MonthlyIncomeGroup, Project$Attrition),margin=1)*100
ggplot(Project, aes(x=MonthlyIncomeGroup, fill=Attrition))+geom_bar(position="fill")+scale_y_continuous(labels=scales::percent)+labs(title="Attrition Rate by Income Group",x="Monthtly Income",y="Percentage Attrition")

table(Project$EducationField, Project$Attrition)
prop.table(table(Project$EducationField, Project$Attrition),margin=1)*100
ggplot(Project, aes(x=EducationField, fill=Attrition))+geom_bar(position="fill")+scale_y_continuous(labels=scales::percent)+labs(title="Attrition Rate by Education Group",x="Education Group",y="Percentage Attrition")

table(Project$MaritalStatus, Project$Attrition)
prop.table(table(Project$MaritalStatus, Project$Attrition),margin=1)*100
ggplot(Project, aes(x=MaritalStatus, fill=Attrition))+geom_bar(position="fill")+scale_y_continuous(labels=scales::percent)+labs(title="Attrition Rate by Marital Status",x="Marital Status",y="Percentage Attrition")

#Build Models
library(class)
library(caret)
library(e1071)

# Convert variables
Project$Attrition = factor(Project$Attrition,levels=c("Yes","No"))
Project$MaritalStatus = as.factor(Project$MaritalStatus)
Project$OverTime = as.factor(Project$OverTime)
Project$EducationField = as.factor(Project$EducationField)
Project$JobSatisfaction = as.factor(Project$JobSatisfaction)

# Select variables and remove missing observations
predictors = c("MonthlyIncome","MaritalStatus","OverTime","Age","JobSatisfaction","EducationField")
knnData = na.omit(Project[,c(predictors,"Attrition")])

# 70/30 Train/Test Split
set.seed(3)
train_indices = sample(seq_len(nrow(knnData)),round(.7*nrow(knnData)))
train_data = knnData[train_indices,]
test_data = knnData[-train_indices,]

# Convert categorical predictors to numeric
dummy = dummyVars(~MonthlyIncome+MaritalStatus+OverTime+Age+JobSatisfaction+EducationField,data=train_data,fullRank=TRUE)
trainProject = predict(dummy,newdata=train_data)
testProject = predict(dummy,newdata=test_data)

# Standardize predictors
trainMean = colMeans(trainProject)
trainSD = apply(trainProject,2,sd)
trainSD[trainSD==0] = 1
trainProject = scale(trainProject,center=trainMean,scale=trainSD)
testProject = scale(testProject,center=trainMean,scale=trainSD)

# KNN Classifier
classifications = knn(train=trainProject,test=testProject,cl=train_data$Attrition,prob=TRUE,k=39)

# Get probability of Attrition = Yes
probabilities = attr(classifications,"prob")
probabilities = ifelse(classifications=="Yes",probabilities,1-probabilities)

# Change threshold to 15%
classifications = factor(ifelse(probabilities>=0.15,"Yes","No"),levels=c("Yes","No"))


# Confusion Matrix
table(classifications,test_data$Attrition)
CM = confusionMatrix(table(classifications,test_data$Attrition),positive="Yes")
CM

# Naive Bayes #
trainNB = knnData[train_indices,]
testNB = knnData[-train_indices,]

model = naiveBayes(trainNB[,c("MonthlyIncome","MaritalStatus","OverTime","Age","JobSatisfaction","EducationField")],trainNB$Attrition)

# Confusion Matrix changed threshold to 17% 
probabilitiesNB = predict(model,testNB[,c("MonthlyIncome","MaritalStatus","OverTime","Age","JobSatisfaction","EducationField")],type="raw")[,"Yes"]
classificationsNB = factor(ifelse(probabilitiesNB>=0.17,"Yes","No"),levels=c("Yes","No"))
CM = confusionMatrix(classificationsNB,testNB$Attrition,positive="Yes",mode="everything")
CM

# Cost assumptions and savings by model
CostPerIntervention = 200
AnnualSalary = test_data$MonthlyIncome*12

# Replacement costs
Cost_50 = AnnualSalary*0.50
Cost_400 = AnnualSalary*4.00

# Actual outcomes and predictions
Actual = as.character(test_data$Attrition)
KNN_Pred = as.character(classifications)
NB_Pred = as.character(classificationsNB)

# Cost without intervention
Cost_No_Model_50 = sum(Cost_50[Actual=="Yes"])
Cost_No_Model_400 = sum(Cost_400[Actual=="Yes"])

# KNN Costs
Cost_KNN_Intervention = sum(KNN_Pred=="Yes")*CostPerIntervention
Cost_KNN_50 = Cost_KNN_Intervention+sum(Cost_50[Actual=="Yes" & KNN_Pred=="No"])
Cost_KNN_400 = Cost_KNN_Intervention+sum(Cost_400[Actual=="Yes" & KNN_Pred=="No"])

# Naive Bayes Costs
Cost_NB_Intervention = sum(NB_Pred=="Yes")*CostPerIntervention
Cost_NB_50 = Cost_NB_Intervention+sum(Cost_50[Actual=="Yes" & NB_Pred=="No"])
Cost_NB_400 = Cost_NB_Intervention+sum(Cost_400[Actual=="Yes" & NB_Pred=="No"])

# Estimated Savings
Savings_KNN_50 = Cost_No_Model_50-Cost_KNN_50
Savings_KNN_400 = Cost_No_Model_400-Cost_KNN_400
Savings_NB_50 = Cost_No_Model_50-Cost_NB_50
Savings_NB_400 = Cost_No_Model_400-Cost_NB_400

# Comparison Table
CostComparison = data.frame(Model=c("No Model","KNN","Naive Bayes"),Cost_50=c(Cost_No_Model_50,Cost_KNN_50,Cost_NB_50),Cost_400=c(Cost_No_Model_400,Cost_KNN_400,Cost_NB_400),Savings_50=c(0,Savings_KNN_50,Savings_NB_50),Savings_400=c(0,Savings_KNN_400,Savings_NB_400))

CostComparison

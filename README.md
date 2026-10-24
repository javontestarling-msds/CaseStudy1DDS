# Case Study 1: Employee Attrition Analysis - Frito Lay

## Executive Summary

### Project Overview

DDSAnalytics was tasked with analyzing employee attrition at Frito Lay to identify factors associated with employee turnover, develop predictive classification models, and estimate the potential financial impact of employee retention strategies.

The project focused on three primary objectives:

1. Identify the top three factors associated with employee attrition.
2. Analyze trends and relationships between employee characteristics and turnover.
3. Develop and compare predictive models to identify employees at risk of leaving the company.

### Exploratory Data Analysis

Exploratory data analysis (EDA) was conducted to examine relationships between employee characteristics and attrition. Monthly Income, Marital Status, and Overtime were identified as three factors showing notable differences in employee attrition.

Employees working overtime had an attrition rate of 31.75%, compared with 9.71% among employees who did not work overtime. This suggests a substantial association between overtime and employee turnover.

Additional variables, including Age, Job Satisfaction, and Education Field, were incorporated into the predictive models to improve classification performance.

### Predictive Model Development

Two classification models were developed: K-Nearest Neighbors (KNN) and Naive Bayes (NB). Both models used six employee characteristics to predict whether an employee would leave the company.

KNN was optimized using K = 39 and a classification threshold of 0.15. Naive Bayes used a classification threshold of 0.17.

**Model Performance**

| Metric | KNN | Naive Bayes |
|---|---:|---:|
| Accuracy | 65.52% | 74.33% |
| Sensitivity | 60.87% | 65.22% |
| Specificity | 66.51% | 76.28% |

Both models achieved the project requirement of at least 60% sensitivity and specificity on the evaluated test set.

Naive Bayes outperformed KNN across all three metrics, correctly identifying 30 of the 46 employees who left the company, compared with 28 identified by KNN.

### Financial Impact Analysis

The financial analysis evaluated two replacement-cost scenarios: 50% and 400% of an employee's annual salary. A $200 retention incentive was assumed for each employee predicted to leave.

**Estimated Potential Savings**

| Replacement Cost | KNN Savings | Naive Bayes Savings |
|---|---:|---:|
| 50% of annual salary | $588,916 | $629,112 |
| 400% of annual salary | $4,851,328 | $5,146,296 |

Naive Bayes generated approximately $40,196 more potential savings than KNN under the 50% replacement-cost scenario and $294,968 more under the 400% scenario.

These estimates assume that all correctly identified employees at risk of leaving could be successfully retained through the incentive program. Therefore, the financial results represent hypothetical best-case savings for the 261-employee test set rather than guaranteed company-wide savings.

### Conclusions and Recommendations

The analysis identified meaningful relationships between employee characteristics and attrition, demonstrating the potential value of predictive analytics in employee retention.

Naive Bayes emerged as the preferred classification model due to its higher sensitivity, specificity, accuracy, and estimated financial savings.

Based on these findings, Frito Lay should consider using predictive analytics to identify employees at elevated risk of leaving and evaluate targeted retention strategies. Additional model validation and testing of intervention effectiveness are recommended before implementing the model in operational decision-making.

Overall, the project demonstrates how employee data can be used to support retention planning, reduce potential replacement costs, and inform data-driven workforce decisions.

-- Task:
/* Analyze the relationship between AI adoption, task automation, workforce characteristics, and employment risk.*/
-- This influences what data we are going to use,Questions asked and insights to be communicated at the end of this analysis
-- Questions that helps in choosing data:(Use 5Whys technique)- Although in this project,the dataset was from kaggle and it was already prepared.
/*
1.Why are we integrating AI?(For task automation)
2.Why do we need task automation?(To make work easier and increase reproductiveness)
3.What kind of task are there in this dataset?(Repeatetive,creativity and Human interaction tasks)
4.What do we need to integrate AI in each industry?(AI training employers,AI Tools)
5.What influences the AI Integration Level in each industry?(AI Training hours,AI tools used,AI usage hours,type of task,Job role,Company size)
6.What is the adoption evel of each industry after integration?
7.Does AI Adoption level correlate with layoff risk?
8.What other factors influence layoff risk?(Education level,Years of experience,Job level,Age)
.
*/
-- Questions to be answered:
/*
1.What is the AI adoption level for each industry?
2.Does routine,creativity and human interaction level influence AI adoption?
3.Does company size,Job Level,AI Training hours impact AI adoption?
4.How many tools does each industry use?
5.Does Age,Years of experience,Education Level,Task Automated percentage influence layoff risk?(Which of these influence Layoff risk most?)
6.Which industries are most affected by AI-driven automation?
7.How does AI adoption differ across job roles and experience levels?
8.What types of jobs have the highest automation exposure?
9.Does creativity reduce vulnerability to automation?
10.How does human interaction influence employment stability?
11.Which industries invest the most in AI training?
12.What workforce characteristics(job role,typ of task,education level,age,years of experience,job level,AI training hours) are associated with higher layoff risk?
13.Which employee groups are most resilient to automation?
*/

-- To do list
-- 1.Create copies of the original dataset
-- 2.Find and handle duplicate data
-- 3.Verify the data types
-- 4.Handle Missing values
-- 5.Look for inconsistent data and errors/Standardization
-- 6.Remove unecessary rows and columns
-- 7.Create derived columns
-- Check for fairness
-- 8.EDA
-- 9.Create views for further analysis and visualization

-- Create copies
CREATE TABLE ai_impact_jobs_copy AS
SELECT *
FROM ai_impact_jobs_layoff_risk_dataset;

SELECT *
FROM ai_impact_jobs_copy;

-- Find and handle duplicates
WITH top_row_num AS(
	SELECT  Age,Education_Level,Years_of_Experience,
	ROW_NUMBER()OVER(PARTITION BY Age,Education_Level,Years_of_Experience,Industry,Job_Role,Company_Size,Routine_Task_Percentage,Creativity_Requirement,
	Human_Interaction_Level,AI_Adoption_Level,Number_of_AI_Tools_Used,AI_Usage_Hours_Per_Week,Tasks_Automated_Percentage,AI_Training_Hours,Layoff_Risk) AS row_num
	FROM ai_impact_jobs_copy
    )
SELECT *
FROM top_row_num
WHERE row_num > 1;

-- There is no duplicate values

-- Handle missing values

SELECT 
	SUM(Age IS NULL) AS age_null,
    SUM(Education_Level IS NULL) AS education_level_null,
    SUM(Years_of_Experience IS NULL) AS years_of_experience_null,
    SUM(Industry IS NULL) AS industry_null,
    SUM(Job_Role IS NULL) AS job_role_null,
    SUM(Company_Size IS NULL) AS company_size_null,
    SUM(Job_Level IS NULL) AS job_level_null,
    SUM(Routine_Task_Percentage IS NULL) AS routine_null,
    SUM(Creativity_Requirement IS NULL) AS creativity_null,
    SUM(Human_Interaction_Level IS NULL) AS human_interaction_null,
    SUM(AI_Adoption_Level IS NULL) AS ai_adoption_null,
    SUM(Number_of_AI_Tools_Used IS NULL) AS nulmber_of_ai_tools_null,
    SUM(AI_Usage_Hours_Per_Week IS NULL) AS ai_usage_hours_null,
    SUM(Tasks_Automated_Percentage IS NULL) AS tasks_automated_null,
    SUM(AI_Training_Hours IS NULL) AS ai_training_hours_null,
    SUM(Layoff_Risk IS NULL) AS layoff_risk_null
FROM ai_impact_jobs_copy;

-- Fortunately we have no missing values.

-- Looking for inconsistencies and errors
SELECT *
FROM ai_impact_jobs_copy;

SELECT *
FROM ai_impact_jobs_copy
WHERE Age <0 OR Age>100;

SELECT *
FROM ai_impact_jobs_copy
WHERE Years_of_Experience<0 OR Years_of_Experience>100;

SELECT *
FROM ai_impact_jobs_copy
WHERE Routine_Task_Percentage<0 OR Routine_Task_Percentage>100;

SELECT *
FROM ai_impact_jobs_copy
WHERE Tasks_Automated_Percentage<0 OR Tasks_Automated_Percentage>100;

SELECT *
FROM ai_impact_jobs_copy
WHERE Layoff_Risk<0 OR Layoff_Risk>100;


SELECT DISTINCT Job_Role
FROM ai_impact_jobs_copy
ORDER BY Job_Role ;

SELECT DISTINCT Industry
FROM ai_impact_jobs_copy
ORDER BY Industry ;

SELECT DISTINCT Company_Size
FROM ai_impact_jobs_copy
ORDER BY Company_Size ;

SELECT DISTINCT Job_Level
FROM ai_impact_jobs_copy
ORDER BY Job_Level ;

SELECT DISTINCT AI_Adoption_Level
FROM ai_impact_jobs_copy
ORDER BY AI_Adoption_Level ;

SELECT DISTINCT Layoff_Risk
FROM ai_impact_jobs_copy
ORDER BY Layoff_Risk;

-- No inconsistnet categories and numerical ranges.

-- Checking for fairness
SELECT *
FROM ai_impact_jobs_copy;

SELECT 
	Industry,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM ai_impact_jobs_copy),2) AS percent
FROM ai_impact_jobs_copy
GROUP BY Industry
ORDER BY employee_count;

SELECT
    Job_role,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM ai_impact_jobs_copy),2) AS percent
FROM ai_impact_jobs_copy
GROUP BY Job_role
ORDER BY employee_count DESC;

SELECT
    Job_Level,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM ai_impact_jobs_copy),2) AS percent,
    ROUND(AVG(AI_Training_Hours), 2) AS avg_training_hours
FROM ai_impact_jobs_copy
GROUP BY Job_Level
ORDER BY employee_count DESC;

SELECT
    Industry,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM ai_impact_jobs_copy),2) AS percent,
    ROUND(AVG(AI_Training_Hours), 2) AS avg_training_hours
FROM ai_impact_jobs_copy
GROUP BY Industry
ORDER BY employee_count DESC;

/*Fairness Check:
Potential representation imbalances were assessed across education, job level, job role, and industry.
Differences in group sizes were noted and 
considered when interpreting the analysis.*/


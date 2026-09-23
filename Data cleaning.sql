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



/*Fairness Check:
Potential representation imbalances were assessed across education, job level, job role, and industry.
Differences in group sizes were noted and 
considered when interpreting the analysis.*/

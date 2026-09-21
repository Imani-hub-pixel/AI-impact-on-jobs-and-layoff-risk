-- To do list
-- 1.Create copies of the original dataset
-- 2.Find and handle duplicate data
-- 3.Verify the data types
-- 4.Handle Missing values
-- 5.Look for inconsistent data and errors/Standardization
-- 6.Remove unecessary rows and columns
-- 7.Create derived columns
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
# Introduction
Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

Check out my SQL queries here: [project_sql folder](/project_sql/).
# Background
The motivation behind this project stemmed from my desire to understand the data analyst job market better. I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?
# Tools I Used

In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

## 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS comapny_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here are 3 top insights for data jobs dating back to 2023:

***Salary Range Spans Wide***
Salaries drop from $650K at Mantys to $184K at Get It Recruit, showing high variance in data roles.

***Big Names Pay Well***
Meta leads with $336K for Director, followed by AT&T ($256K) and Pinterest ($232K).

***Senior Roles Dominate***
8 of 10 jobs carry "Principal" or "Director" titles, all remote and full-time.

## 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS comapny_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
These are the insights I have uncovered:

***SQL Essential Everywhere***
AT&T's top-paying role ($256K) demands SQL plus Python, R, cloud platforms (Azure/AWS), and big data tools like Databricks/PySpark.

***Cloud Powers High Salaries***
Roles above $189K frequently list AWS, Azure, Snowflake alongside SQL/Python for scalable data handling.

***Viz Tools are Consistent***
Tableau appears in every top-5 paying job; Power BI common in director-level positions for stakeholder reporting.

![top 10 skills](assets\top_10_skills.png)
*Bar chart showing the Top 10 most frequent skills for Top paying roles. Graph created by Copilot using my SQL query results.*

## 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings.
```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
***SQL*** leads job demand by a wide margin in this dataset, followed by ***Excel*** and ***Python*** as strong secondary skills, with visualization tools like ***Tableau*** and ***Power BI*** rounding out the top five.

| Skill    | Demand Count |
|----------|--------------|
| SQL      | 92,628       |
| Excel    | 67,031       |
| Python   | 57,326       |
| Tableau  | 46,554       |
| Power BI | 39,468       |


*Top 5 skills being requested.*

## 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10;
```

These results highlight very high-paying roles clustered around advanced data, ML, and platform engineering skills. PySpark tops the list, suggesting strong salaries for big data and distributed processing expertise, with related tools like Databricks, Airflow, Kubernetes, and GCP also commanding premium pay. Skills such as Pandas, NumPy, scikit-learn, Jupyter, and DataRobot point to well-compensated machine learning and data science roles, while tools like Bitbucket, GitLab, Jenkins, and Atlassian indicate that strong DevOps and modern software delivery skills are also highly rewarded.

| Skill        | Average Salary |
|--------------|----------------|
| pyspark      | 208,172        |
| bitbucket    | 189,155        |
| couchbase    | 160,515        |
| watson       | 160,515        |
| datarobot    | 155,486        |
| gitlab       | 154,500        |
| swift        | 153,750        |
| jupyter      | 152,777        |
| pandas       | 151,821        |
| elasticsearch| 145,000        |

*Tabl showing the average salaries for the Top 10 paying skills for Data Analysts*

## 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC

LIMIT 25;
```
This SQL query analyzes remote Data Analyst roles with valid salaries, ranking skills by average salary (descending) then demand (>10 postings), limited to top 25. It combines job frequency from postings with salary averages, spotlighting high-value skills for WFH analysts. Useful for targeting lucrative, in-demand expertise in a competitive market.

| Skill        | Demand Count | Average Salary |
|--------------|--------------|----------------|
| go           | 27           | 115,320        |
| confluence   | 11           | 114,210        |
| hadoop       | 22           | 113,193        |
| snowflake    | 37           | 112,948        |
| azure        | 34           | 111,225        |
| bigquery     | 13           | 109,654        |
| aws          | 32           | 108,317        |
| java         | 17           | 106,906        |
| ssis         | 12           | 106,683        |
| jira         | 20           | 104,918        |
| oracle       | 37           | 104,534        |
| looker       | 49           | 103,795        |
| nosql        | 13           | 101,414        |
| python       | 236          | 101,397        |
| r            | 148          | 100,499        |
| redshift     | 16           | 99,936         |
| qlik         | 13           | 99,631         |
| tableau      | 230          | 99,288         |
| ssrs         | 14           | 99,171         |
| spark        | 13           | 99,077         |
| c++          | 11           | 98,958         |
| sas          | 63           | 98,902         |
| sas          | 63           | 98,902         |
| sql server   | 35           | 97,786         |
| javascript   | 20           | 97,587         |
*Table of the most optimal skills in 2023 for Data Analysts sorted by salary*

# What I Learned
Working through this project helped me strengthen several important SQL skills:
- Building more advanced queries
I learned how to structure complex SQL statements, join multiple tables, and use tools like WITH clauses to create temporary, readable subqueries.
- Summarizing and aggregating data
I became more confident using GROUP BY along with functions such as COUNT() and AVG() to turn raw data into meaningful summaries.
- Thinking analytically with SQL
I practiced translating real-world questions into precise SQL queries — a key skill for getting useful insights from data.

# Insights
The analysis revealed several standout themes about the remote Data Analyst job market:
- Remote analyst salaries vary widely — with some reaching as high as $650,000.
The top end of the market is surprisingly lucrative, especially for roles requiring advanced technical depth.
- SQL is the core skill behind the highest‑paying roles.
Nearly all top‑salary postings list SQL as a required skill, reinforcing its importance for analysts aiming for premium compensation.
- SQL is also the most in‑demand skill overall.
Its combination of high demand and high salary potential makes it essential for anyone entering or advancing in the field.
- Niche or specialized tools (e.g., SVN, Solidity) command higher average salaries.
These skills appear less frequently but offer strong earning potential, suggesting a premium for rare expertise.
- SQL stands out as the best “market value” skill.
It offers the strongest balance of demand, accessibility, and salary upside — making it a strategic priority for skill development.

# Conclusion
This project strengthened my SQL capabilities while offering a clearer picture of the remote data analyst landscape. The insights help highlight which skills are worth prioritizing — both for breaking into the field and for leveling up. By focusing on high‑demand, high‑salary skills, aspiring analysts can position themselves more competitively and stay aligned with evolving industry expectations. Continuous learning and adaptability remain key to thriving in data analytics.

/*
**Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
providing insights into the most valuable skills for job seekers.
*/

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

/*
These numbers show a “core stack” that almost every data analyst role expects, with SQL clearly on top.
SQL (7,291) is the non‑negotiable language for querying, cleaning, and joining data from relational
databases, and it appears in the majority of job postings as the main way analysts interact with production
data. Excel (4,611) remains heavily demanded because it’s still the fastest tool for quick analysis, ad‑hoc
reports, and business‑friendly modeling, often used alongside other tools rather than replaced by them.
Python (4,330) signals employer demand for analysts who can go beyond basic reporting into automation,
complex data wrangling, and more advanced analytics or ML, complementing SQL rather than substituting it.
Tableau (3,745) and Power BI (2,609) represent the main BI/visualisation layer; together they show that
turning raw data into clear dashboards and stories for stakeholders is a core part of modern analyst work,
with both tools seen as roughly interchangeable “must‑know one of them” skills
*/
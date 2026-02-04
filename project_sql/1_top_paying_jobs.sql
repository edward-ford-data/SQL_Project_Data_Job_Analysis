/*
**Question: What are the top-paying data analyst jobs?**

- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts,
offering insights into employment options and location flexibility.
*/

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

/*
The highest-paying data analyst roles in this list are senior titles like Director of Analytics 
($336k at Meta), Associate Director ($256k at AT&T), and Principal Data Analyst ($186k–$205k at 
SmartAsset/Motional), mostly full-time remote/hybrid at major tech, telecom, and healthcare firms, 
with an outlier at $650k for a generic Data Analyst role at Mantys.
*/
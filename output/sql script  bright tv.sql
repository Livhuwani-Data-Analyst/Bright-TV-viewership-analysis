SELECT 
    r.gender,
    r.province,
    r.race,
    CASE 
        WHEN r.age < 18 THEN 'Under 18'
        WHEN r.age BETWEEN 18 AND 34 THEN 'Young Adults'
        WHEN r.age BETWEEN 35 AND 54 THEN 'Adults'
        ELSE 'Seniors'
    END AS age_group, 
    
    TO_DATE(DATEADD(hour, 2, TO_TIMESTAMP(u.recorddate2, 'YYYY/MM/DD HH24:MI'))) AS record_date,
    DAYNAME(DATEADD(hour, 2, TO_TIMESTAMP(u.recorddate2, 'YYYY/MM/DD HH24:MI'))) AS day_of_week,
    MONTHNAME(DATEADD(hour, 2, TO_TIMESTAMP(u.recorddate2, 'YYYY/MM/DD HH24:MI'))) AS month_of_year,
    u.channel2,
    
    CASE 
        WHEN CAST(u.duration_2 AS TIME) < '01:00:00' THEN 'Short'
        WHEN CAST(u.duration_2 AS TIME) BETWEEN '01:00:00' AND '05:00:00' THEN 'Medium'
        ELSE 'Long'
    END AS duration_category,
    
    COUNT(DISTINCT u."UserID") AS number_of_users,
    COUNT(*) AS number_of_sessions,
    
    TO_CHAR(
        DATEADD(
            second, 
            AVG(DATEDIFF(second, '00:00:00'::TIME, CAST(u.duration_2 AS TIME))),
            '00:00:00'::TIME
        ),
        'HH24:MI:SS'
    ) AS avg_duration

FROM records u
JOIN user_details r
    ON u."UserID" = r.USERID

GROUP BY 
   age_group,
    r.gender,
    r.province,
    r.race,
    TO_DATE(DATEADD(hour, 2, TO_TIMESTAMP(u.recorddate2, 'YYYY/MM/DD HH24:MI'))),
    DAYNAME(DATEADD(hour, 2, TO_TIMESTAMP(u.recorddate2, 'YYYY/MM/DD HH24:MI'))),
    MONTHNAME(DATEADD(hour, 2, TO_TIMESTAMP(u.recorddate2, 'YYYY/MM/DD HH24:MI'))),
    u.channel2,
    duration_category
ORDER BY 
    record_date, channel2, duration_category, age_group;


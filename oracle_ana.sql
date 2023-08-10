SELECT
    p.*,
    CASE
        WHEN p.ntile_val = 1    THEN
            'Lesser'
        WHEN p.ntile_val = 2    THEN
            'good'
        WHEN p.ntile_val = 3    THEN
            'best'
    END categ
FROM
    (
        SELECT
            e.*,
            FIRST_VALUE(salary)
            OVER(PARTITION BY e.department_id
                ORDER BY
                    e.salary DESC
                RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            )        AS highest_val,
            LAST_VALUE(salary)
            OVER(PARTITION BY e.department_id
                ORDER BY
                    e.salary DESC
                RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            )        AS lowest_val,
            NTH_VALUE(salary, 1)
            OVER(PARTITION BY e.department_id
                ORDER BY
                    e.salary DESC
                RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            )        AS nth_val,
            NTILE(3)
            OVER(
                ORDER BY salary DESC
            )        AS ntile_val,
            round(CUME_DIST()
                  OVER(
                ORDER BY salary DESC
                  ), 2)    AS cum_dist,
            round(PERCENT_RANK()
                  OVER(
                ORDER BY salary ASC
                  ), 2)*100    AS percentage_rank
        FROM
            employees e
    ) p
WHERE
    1 = 1 and p.salary = 2800 
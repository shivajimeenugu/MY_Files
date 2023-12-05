WITH OTBL AS
    (
    	SELECT '1' AS employee_id,CAST('24-NOV-2023 08:00.00 AM' AS TIMESTAMP) AS inpunch,CAST('24-NOV-2023 04:00.00 PM' AS TIMESTAMP) AS outpunch FROM DUAL
    	UNION
    	SELECT '2' AS employee_id,CAST('24-NOV-2023 03:00.00 PM' AS TIMESTAMP) AS inpunch,CAST('25-NOV-2023 04:00.00 AM' AS TIMESTAMP) AS outpunch FROM DUAL
    	UNION
    	SELECT '3' AS employee_id,CAST('24-NOV-2023 05:00.00 PM' AS TIMESTAMP) AS inpunch,CAST('25-NOV-2023 09:00.00 AM' AS TIMESTAMP) AS outpunch FROM DUAL
    )
-- SELECT * FROM OTBL;

SELECT
    employee_id,
    
        CASE
            -- Shift 1 (8:00 AM to 4:00 PM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '08:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '16:00' THEN (outpunch - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '08:00' AND TO_CHAR(outpunch, 'HH24:MI') > '08:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 08:00', 'DD-MM-YYYY HH24:MI') - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '08:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '16:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI') - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '08:00' AND TO_CHAR(outpunch, 'HH24:MI') > '16:00' THEN 8
            -- Shift 2 (4:00 PM to 12:00 AM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '16:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '24:00' THEN (outpunch - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '16:00' AND TO_CHAR(outpunch, 'HH24:MI') > '16:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI') - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '16:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '24:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 24:00', 'DD-MM-YYYY HH24:MI') - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI')) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '16:00' AND TO_CHAR(outpunch, 'HH24:MI') > '24:00' THEN 8
            -- Shift 3 (12:00 AM to 8:00 AM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '00:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '08:00' THEN (outpunch - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '00:00' AND TO_CHAR(outpunch, 'HH24:MI') > '00:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 00:00', 'DD-MM-YYYY HH24:MI') - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '00:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '08:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 08:00', 'DD-MM-YYYY HH24:MI') - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 00:00', 'DD-MM-YYYY HH24:MI')) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '00:00' AND TO_CHAR(outpunch, 'HH24:MI') > '08:00' THEN 8
            ELSE 0
        END
     AS shift_1_hours,
   
        CASE
            -- Shift 1 (8:00 AM to 4:00 PM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '08:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '16:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '08:00' AND TO_CHAR(outpunch, 'HH24:MI') > '08:00' THEN (outpunch - TO_DATE(TO_CHAR(inpunch, 'DD-MM-YYYY') || ' 08:00', 'DD-MM-YYYY HH24:MI')) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '08:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '16:00' THEN 8
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '08:00' AND TO_CHAR(outpunch, 'HH24:MI') > '16:00' THEN (outpunch - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI')) * 24
            -- Shift 2 (4:00 PM to 12:00 AM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '16:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '24:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '16:00' AND TO_CHAR(outpunch, 'HH24:MI') > '16:00' THEN (outpunch - TO_DATE(TO_CHAR(inpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI')) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '16:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '24:00' THEN 8
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '16:00' AND TO_CHAR(outpunch, 'HH24:MI') > '24:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 24:00', 'DD-MM-YYYY HH24:MI') - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI')) * 24
            -- Shift 3 (12:00 AM to 8:00 AM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '00:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '08:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '00:00' AND TO_CHAR(outpunch, 'HH24:MI') > '00:00' THEN (outpunch - TO_DATE(TO_CHAR(inpunch, 'DD-MM-YYYY') || ' 00:00', 'DD-MM-YYYY HH24:MI')) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '00:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '08:00' THEN 8
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '00:00' AND TO_CHAR(outpunch, 'HH24:MI') > '08:00' THEN (outpunch - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 08:00', 'DD-MM-YYYY HH24:MI')) * 24
            ELSE 0
        END
     AS shift_2_hours,
    
        CASE
            -- Shift 1 (8:00 AM to 4:00 PM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '08:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '16:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '08:00' AND TO_CHAR(outpunch, 'HH24:MI') > '08:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '08:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '16:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '08:00' AND TO_CHAR(outpunch, 'HH24:MI') > '16:00' THEN (outpunch - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 16:00', 'DD-MM-YYYY HH24:MI')) * 24
            -- Shift 2 (4:00 PM to 12:00 AM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '16:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '24:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '16:00' AND TO_CHAR(outpunch, 'HH24:MI') > '16:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '16:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '24:00' THEN 0
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '16:00' AND TO_CHAR(outpunch, 'HH24:MI') > '24:00' THEN 0
            -- Shift 3 (12:00 AM to 8:00 AM)
            WHEN TO_CHAR(inpunch, 'HH24:MI') >= '00:00' AND TO_CHAR(outpunch, 'HH24:MI') <= '08:00' THEN (outpunch - inpunch) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '00:00' AND TO_CHAR(outpunch, 'HH24:MI') > '00:00' THEN 8
            WHEN TO_CHAR(inpunch, 'HH24:MI') < '00:00' AND TO_CHAR(outpunch, 'HH24:MI') >= '08:00' THEN (TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 08:00', 'DD-MM-YYYY HH24:MI') - TO_DATE(TO_CHAR(outpunch, 'DD-MM-YYYY') || ' 00:00', 'DD-MM-YYYY HH24:MI')) * 24
            WHEN TO_CHAR(inpunch, 'HH24:MI') <= '00:00' AND TO_CHAR(outpunch, 'HH24:MI') > '08:00' THEN 8
            ELSE 0
        END
     AS shift_3_hours
FROM OTBL
GROUP BY employee_id;

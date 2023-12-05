-- Creating a job to truncate a table at midnight when the date changes
BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
    job_name        => 'TRUNCATE_TABLE_JOB',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN
                          IF TRUNC(SYSDATE) <> TRUNC(LAST_DAY(SYSDATE - 1)) THEN
                            EXECUTE IMMEDIATE ''TRUNCATE TABLE your_table_name'';
                          END IF;
                        END;',
    start_date      => TRUNC(SYSDATE) + 1, -- Start the job tomorrow at midnight
    repeat_interval => 'FREQ=DAILY; BYHOUR=0', -- Repeat daily at midnight
    enabled         => TRUE
  );
END;
/

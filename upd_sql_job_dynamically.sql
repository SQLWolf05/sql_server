
  /**------------------------------------------------------------------------------------------------  
  File:		??.sql																		 

  Summary:		??																			 

  Created:	2017-01-01																	  	
  SQL Server	2005/2008/2012/2014															 
  Written by Kyle, Nauvus																	  
  ---------------------------------------------------------------------------------------------------  
  Purpose:	 

  Notes:																					 

  /*
  CONFIDENTIAL
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND.
  */	 
  ------------------------------------------------------------------------------------------------**/  




   
select @@SERVERNAME


SELECT        HospitalId
FROM            Hospital




SET NOCOUNT ON

DECLARE	@HospId AS VARCHAR(5)
DECLARE	@Dat AS datetime2(0)

SET		@HospId = '101'

SELECT HospitalId =	CASE LEN(@HospId)
						WHEN 3 THEN 'H0' + @HospId + '-DB'
						WHEN 4 THEN 'H' + @HospId + '-DB'
					ELSE
						'H' + @HospId + '-DB'
					END

SET @Dat = '05/15/2017'


SELECT FORMAT( CAST(@Dat AS DATE), 'yyyyMMdd' ) 




Print 'You wish to add a Job to Hospital ' + 'H0' + @HospId + '-DB (AU' + @HospId + ')'


SELECT CONVERT(VARCHAR, CONVERT(DATETIME, '00:01:45 AM'), 108) AS HourMinuteSecond
SELECT REPLACE(RIGHT('0' + LTRIM(RIGHT(CONVERT(VARCHAR, CONVERT(DATETIME, '8:8:8 PM'), 131), 14)), 11), ':000', ' ') AS HourMinuteSecond

SELECT  next_run_date ,
                    next_run_time ,
                    LEFT(RIGHT('000000' + CAST(next_run_time AS VARCHAR(6)), 6),
                         2) + ':' + SUBSTRING(RIGHT('000000'
                                                    + CAST(next_run_time AS VARCHAR(6)),
                                                    6), 3, 2) + ':'
                    + RIGHT(RIGHT('000000' + CAST(next_run_time AS VARCHAR(6)),
                                  6), 2) AS TheTime
            FROM    msdb.dbo.sysjobschedules AS s







--Find a way to get schedule of job dynamically
E@@XEC msdb.dbo.sp_update_schedule @schedule_id=1090, 
	@active_start_time=000101

ex@@ec sp_executesql N'EXECUTE [msdb].[dbo].[sp_sqlagent_update_jobactivity_next_scheduled_date] @session_id = @P1, @job_id = @P2, @is_system = @P3, @last_run_date = @P4, @last_run_time = @P5',N'@P1 int,@P2 uniqueidentifier,@P3 int,@P4 int,@P5 int',27167,'846E6F0D-EB7D-40FB-9CB7-17288D5F7FBA',0,20170820,000101

EX@@EC msdb.dbo.sp_update_schedule @schedule_id=1090, 
	@active_start_time=000101





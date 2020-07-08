:setvar Server1 "Chrissql02"
:setvar Server2 "Chrissql01"
:setvar Server3 "Chrissql03"
:setvar Server4 "Chrissql04"
:setvar port "5023"

:setvar Server1FQDN "Chrissql02.mot.bpeservices.local"
:setvar Server2FQDN "Chrissql01.mot.bpeservices.local"
:setvar Server3FQDN "Chrissql03.mot.bpeservices.local"
:setvar Server4FQDN "Chrissql04.mot.bpeservices.local"
:setvar AGName "CON_AG"

:Connect $(Server1FQDN)
USE [master]
GO
IF EXISTS(SELECT * 
          FROM sys.availability_groups AS ag
          WHERE ag.name = '$(AGName)')
BEGIN 
    DROP AVAILABILITY GROUP $(AGName)
END 

CREATE AVAILABILITY GROUP $(AGName)
WITH (AUTOMATED_BACKUP_PREFERENCE = SECONDARY)
FOR 
REPLICA ON N'$(Server1)' WITH (ENDPOINT_URL = N'TCP://$(Server1FQDN):$(port)', FAILOVER_MODE = AUTOMATIC, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, SESSION_TIMEOUT = 10, BACKUP_PRIORITY = 80, PRIMARY_ROLE(ALLOW_CONNECTIONS = ALL), SECONDARY_ROLE(ALLOW_CONNECTIONS = READ_ONLY))
,   N'$(Server2)' WITH (ENDPOINT_URL = N'TCP://$(Server2FQDN):$(port)', FAILOVER_MODE = AUTOMATIC, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, SESSION_TIMEOUT = 10, BACKUP_PRIORITY = 80, PRIMARY_ROLE(ALLOW_CONNECTIONS = all), SECONDARY_ROLE(ALLOW_CONNECTIONS = READ_ONLY))
,   N'$(Server3)' WITH (ENDPOINT_URL = N'TCP://$(Server3FQDN):$(port)', FAILOVER_MODE = manual, AVAILABILITY_MODE = SYNCHRONOUS_COMMIT, SESSION_TIMEOUT = 10, BACKUP_PRIORITY = 20, PRIMARY_ROLE(ALLOW_CONNECTIONS = all), SECONDARY_ROLE(ALLOW_CONNECTIONS = READ_ONLY))
,	N'$(Server4)' WITH (ENDPOINT_URL = N'TCP://$(Server4FQDN):$(port)', FAILOVER_MODE = manual, AVAILABILITY_MODE = ASYNCHRONOUS_COMMIT, SESSION_TIMEOUT = 10, BACKUP_PRIORITY = 20, PRIMARY_ROLE(ALLOW_CONNECTIONS = all), SECONDARY_ROLE(ALLOW_CONNECTIONS = READ_ONLY))
LISTENER N'CONAGVNN' (
WITH IP
((N'10.14.32.76', '255.255.225.0')
)
, PORT=1433)
GO

--:Connect $(Server1FQDN)
--USE [master]
--GO
--ALTER AVAILABILITY GROUP $(AGName)
--ADD LISTENER N'CONAGVNN' (
--WITH IP
--((N'10.14.32.76', '255.255.225.0')
--)
--, PORT=1433);
--GO

:Connect $(Server2FQDN)
PRINT 'joining on $(Server2FQDN)'
ALTER AVAILABILITY GROUP $(AGName)
JOIN
GO

:Connect $(Server3FQDN)
PRINT 'joining on $(Server3FQDN)'
ALTER AVAILABILITY GROUP $(AGName)
JOIN
GO

:Connect $(Server4FQDN)
PRINT 'joining on $(Server4FQDN)'
ALTER AVAILABILITY GROUP $(AGName)
JOIN
GO



----------------------
--Musique
SET NOCOUNT ON
:setvar SQLCMDLOGINTIMEOUT 60
:setvar server "USLAITDKHA01-L"
:connect $(server) -l $(SQLCMDLOGINTIMEOUT)
:SETVAR SQLCMDHEADERS -1
SET NOCOUNT ON
USE the_world;

SELECT TOP (5) *
  FROM [the_world].[dbo].[FGR]


--To run
--exec xp_cmdshell 'sqlcmd -h -1 -i  C:\Intel\test_setvar.sql'




SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
DECLARE @HospitalId INT
 
SELECT @HospitalId = HospitalId
FROM Hospital

DECLARE @MinimumAge [INT]
DECLARE @IsDUActive BIT

SELECT @MinimumAge = ConfigValue
FROM SchedulerConfig WITH (NOLOCK)
WHERE ConfigKey = 'DocumentTransferMinimumAge(in days)'

SELECT @IsDUActive = ConfigValue
FROM SchedulerConfig WITH (NOLOCK)
WHERE ConfigKey = 'DocumentCloudTransferEnabled'

SELECT *
FROM [SCHEMR].[DocumentSyn] WITH (NOLOCK)
WHERE [HospitalId] = @HospitalId
       AND IsUploaded = 0
	   AND [Content] IS NOT NULL
       AND DATEDIFF(DAY, COALESCE(LastModifiedDate, CreatedDate), GETDATE()) > @MinimumAge
ORDER BY 1 DESC
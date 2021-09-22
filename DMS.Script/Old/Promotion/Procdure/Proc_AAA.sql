DROP PROCEDURE [Promotion].[Proc_AAA]
GO




CREATE PROCEDURE [Promotion].[Proc_AAA]
	
AS
BEGIN
	Create table #tamp
	(
	id nvarchar(36)
	)
	

	insert into #tamp values('0195BAD8-83E2-405B-806F-FC518CC84C49')
insert into #tamp values('4B800F63-EE19-4B2A-BD57-A71507E804FA')
insert into #tamp values('8F9C4FD4-BF08-4AB6-9686-6A52B57D8A35')
insert into #tamp values('51FAA7A0-FE6E-4C5B-9859-E622E9B4A723')
insert into #tamp values('3AF65D79-354C-41FF-BD20-A212B8B1DDA7')
insert into #tamp values('E878564E-7AEF-4D8C-ABCC-E2B8AC51F433')
insert into #tamp values('E20B806E-0E5F-4290-89A3-F96829E9E728')
insert into #tamp values('A6307F14-6BEC-422F-A53E-72EA1C391708')
insert into #tamp values('B8B245D0-D3DC-4D17-A90F-7053ED7E1398')
insert into #tamp values('414EBDF5-5574-4B8C-BD86-0D73CD7B614A')
insert into #tamp values('A3C5E991-ED37-49BD-9A7B-457DBC0399B6')
insert into #tamp values('1B93FD08-888F-478F-82FA-053B919DF1B4')
insert into #tamp values('03703F25-9CE7-4491-9DD6-23F910D361CD')
insert into #tamp values('A7A6368B-5046-4F1E-BD33-064E9BA94AB3')
insert into #tamp values('CDEC79AC-526C-46EB-93AF-F1BFAAE6D974')
insert into #tamp values('0AD6652A-BED2-441B-B00F-219B1E879A9C')
insert into #tamp values('6A159223-2A40-4F00-A1DC-F5895B20C6D1')
insert into #tamp values('AA1A586B-B0EF-4EEB-B13F-80C9000DC984')
insert into #tamp values('83FBE81B-01BF-4175-99A4-B32361E9BB91')
insert into #tamp values('4B895541-F062-4775-8FBA-EC86398F3575')
insert into #tamp values('B0446BAD-2867-4891-A0DE-3A25233ED921')
insert into #tamp values('4EDFABE9-48BB-474B-8613-F38FFCA49BD4')
insert into #tamp values('92796701-933D-4275-ADB9-27C77C8F7389')
insert into #tamp values('D87F7D28-9C90-422C-A141-808CF2FAB435')
insert into #tamp values('BE0477E8-64D4-4A8D-8EB4-FBDACE49E77A')
insert into #tamp values('CCDFE5B0-C8A6-4F8B-B960-B7CD6C7821C7')
insert into #tamp values('B0EA358F-AF85-4281-9039-0F073F6596A0')
insert into #tamp values('45437697-E2B8-42E6-A542-0E01B3BD4972')
insert into #tamp values('FF6BD060-39DA-4070-9745-DAC00A306BFF')

	DECLARE @PolicyId nvarchar(36)
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT  id FROM #tamp
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @PolicyId
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			--exec interface.P_I_EW_MaintContract @PolicyId,'Appointment',null,null 
			exec interface.P_I_EW_Contract_Status @PolicyId,'Appointment','Completed',null,null 
            FETCH NEXT FROM @PRODUCT_CUR INTO @PolicyId
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
	
	
END



GO



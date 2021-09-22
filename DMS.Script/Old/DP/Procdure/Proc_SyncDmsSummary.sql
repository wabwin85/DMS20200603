
DROP PROCEDURE [DP].[Proc_SyncDmsSummary]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsSummary]
	@DealerId UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @error_number INT
	DECLARE @error_serverity INT
	DECLARE @error_state INT
	DECLARE @error_message NVARCHAR(256)
	DECLARE @error_line INT
	DECLARE @error_procedure NVARCHAR(256)
	DECLARE @vError NVARCHAR(1000)
	
	BEGIN TRY
		DECLARE @ModleId UNIQUEIDENTIFIER;
		SET @ModleId = '00000001-0001-0010-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  DealerId = @DealerId
		       AND ModleID = @ModleId;
		
		--������Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0001-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT TOP 1 NEWID(),
		           @DealerId,
		           @ModleId,
		           '������Ϣ',
		           '������Ϣ',
		           '������Ϣ',
		           '������ʱ�䣺' + CONVERT(NVARCHAR(10), CreateDate, 121),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   DP.DealerMaster
		    WHERE  DealerId = @DealerId
		           AND ModleID = '00000001-0001-0001-0000-000000000000'
		    ORDER BY [Version] DESC
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '������Ϣ', 'δά���汾', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--������Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0002-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT TOP 1 NEWID(),
		           @DealerId,
		           @ModleId,
		           '������Ϣ',
		           '������Ϣ',
		           '������Ϣ',
		           '������ʱ�䣺' + CONVERT(NVARCHAR(10), CreateDate, 121),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   DP.DealerMaster
		    WHERE  DealerId = @DealerId
		           AND ModleID = '00000001-0001-0002-0000-000000000000'
		    ORDER BY [Version] DESC
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '������Ϣ', 'δά���汾', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--����ע����Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0003-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT TOP 1 NEWID(),
		           @DealerId,
		           @ModleId,
		           '������Ϣ',
		           '������Ϣ',
		           '����ע����Ϣ',
		           '������ʱ�䣺' + CONVERT(NVARCHAR(10), CreateDate, 121),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   DP.DealerMaster
		    WHERE  DealerId = @DealerId
		           AND ModleID = '00000001-0001-0003-0000-000000000000'
		    ORDER BY [Version] DESC
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '����ע����Ϣ', 'δά���汾', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��ϵ����Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0004-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '��ϵ����Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '��ϵ����Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--������������Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0006-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '������������Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '������������Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--����������
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0007-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '����������', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '����������', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--�ϲ����˾�����
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0008-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '�ϲ����˾�����', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '�ϲ����˾�����', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��ظ�������
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0001-0009-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '��ظ�������', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '������Ϣ', '��ظ�������', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��ͬ����Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0003-0001-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��ͬ����Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��ͬ����Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��Ȩ��Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0003-0002-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��Ȩ��Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��Ȩ��Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--ָ����Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0003-0003-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', 'ָ����Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', 'ָ����Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��ͬ��ʷ������Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0003-0004-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��ͬ��ʷ������Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��ͬ��ʷ������Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��ͬ������Ϣ
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000001-0003-0005-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��ͬ������Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '������Ϣ', '��ͬ��Ϣ', '��ͬ������Ϣ', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--�����̲����������
		IF EXISTS (
		       SELECT 1
		       FROM   DPStatementScorecardHeader
		       WHERE  STH_DMA_ID = @DealerId
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT TOP 1 NEWID(),
		           @DealerId,
		           @ModleId,
		           '�ؼ�ָ��',
		           '�����̲����������',
		           '�����̲����������',
		           '������ʱ�䣺' + CONVERT(NVARCHAR(10), STH_CreateDate, 121),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   DPStatementScorecardHeader
		    WHERE  STH_DMA_ID = @DealerId
		    ORDER BY STH_Version DESC
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ؼ�ָ��', '�����̲����������', '�����̲����������', 
		      'δά���汾', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--������ҵ������
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000002-0002-0001-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ؼ�ָ��', '������ҵ������', '������ҵ������', '������', 
		      1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ؼ�ָ��', '������ҵ������', '������ҵ������', '������', 
		      1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--�Ϲ���鱨��
		IF EXISTS (
		       SELECT 1
		       FROM   DP.CompHead
		       WHERE  DealerId = @DealerId
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT TOP 1 NEWID(),
		           @DealerId,
		           @ModleId,
		           '��������Ϣ',
		           '�Ϲ���鱨��',
		           '�Ϲ���鱨��',
		           '������ʱ�䣺' + CONVERT(NVARCHAR(10), CreateDate, 121),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   DP.CompHead
		    WHERE  DealerId = @DealerId
		    ORDER BY [Version] DESC
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '��������Ϣ', '�Ϲ���鱨��', '�Ϲ���鱨��', 
		      'δά���汾', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��Ƽ�¼
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000003-0002-0001-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '��������Ϣ', '������ƽ��', '��Ƽ�¼', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '��������Ϣ', '������ƽ��', '��Ƽ�¼', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��ѵ��¼
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000004-0001-0001-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '��ѵ��¼', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '��ѵ��¼', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--���ͼ�¼
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000004-0001-0002-0000-000000000000'
		   )
		   OR EXISTS (
		          SELECT 1
		          FROM   DP.DealerMaster
		          WHERE  DealerId = @DealerId
		                 AND ModleID = '00000004-0001-0101-0000-000000000000'
		      )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '���ͼ�¼', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '���ͼ�¼', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--��Ʒ�������
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000004-0001-0003-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '��Ʒ�������', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '��Ʒ�������', '������', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--������㼰ΥԼ��¼
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000004-0001-0004-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '������㼰ΥԼ��¼', 
		      '������', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', '�ճ���¼', '������㼰ΥԼ��¼', 
		      '������', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--Score Card
		IF EXISTS (
		       SELECT 1
		       FROM   DP.DealerMaster
		       WHERE  DealerId = @DealerId
		              AND ModleID = '00000004-0002-0001-0000-000000000000'
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', 'Score Card', 'Score Card', 
		      '������', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '�ճ�������Ϣ', 'Score Card', 'Score Card', 
		      '������', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsSummary��' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '�г���[����ţ�' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']��' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO



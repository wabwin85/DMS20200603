
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
		
		--基本信息
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
		           '基本信息',
		           '常用信息',
		           '基本信息',
		           '最后更新时间：' + CONVERT(NVARCHAR(10), CreateDate, 121),
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '基本信息', '未维护版本', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--地区信息
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
		           '基本信息',
		           '常用信息',
		           '地区信息',
		           '最后更新时间：' + CONVERT(NVARCHAR(10), CreateDate, 121),
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '地区信息', '未维护版本', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--工商注册信息
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
		           '基本信息',
		           '常用信息',
		           '工商注册信息',
		           '最后更新时间：' + CONVERT(NVARCHAR(10), CreateDate, 121),
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '工商注册信息', '未维护版本', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--联系人信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '联系人信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '联系人信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--二级经销商信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '二级经销商信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '二级经销商信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--关联经销商
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '关联经销商', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '关联经销商', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--合并考核经销商
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '合并考核经销商', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '合并考核经销商', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--相关附件下载
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '相关附件下载', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '常用信息', '相关附件下载', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--合同主信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '合同主信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '合同主信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--授权信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '授权信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '授权信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--指标信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '指标信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '指标信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--合同历史流程信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '合同历史流程信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '合同历史流程信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--合同附件信息
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
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '合同附件信息', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '基本信息', '合同信息', '合同附件信息', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--经销商财务风险评估
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
		           '关键指标',
		           '经销商财务风险评估',
		           '经销商财务风险评估',
		           '最后更新时间：' + CONVERT(NVARCHAR(10), STH_CreateDate, 121),
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
		      (NEWID(), @DealerId, @ModleId, '关键指标', '经销商财务风险评估', '经销商财务风险评估', 
		      '未维护版本', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--经销商业绩评估
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
		      (NEWID(), @DealerId, @ModleId, '关键指标', '经销商业绩评估', '经销商业绩评估', '有内容', 
		      1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '关键指标', '经销商业绩评估', '经销商业绩评估', '无内容', 
		      1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--合规调查报告
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
		           '第三方信息',
		           '合规调查报告',
		           '合规调查报告',
		           '最后更新时间：' + CONVERT(NVARCHAR(10), CreateDate, 121),
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
		      (NEWID(), @DealerId, @ModleId, '第三方信息', '合规调查报告', '合规调查报告', 
		      '未维护版本', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--审计记录
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
		      (NEWID(), @DealerId, @ModleId, '第三方信息', '渠道审计结果', '审计记录', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '第三方信息', '渠道审计结果', '审计记录', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--培训记录
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
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '培训记录', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '培训记录', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--奖惩记录
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
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '奖惩记录', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '奖惩记录', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--审计分析评估
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
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '审计分析评估', '有内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '审计分析评估', '无内容', 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		--付款结算及违约记录
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
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '付款结算及违约记录', 
		      '有内容', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', '日常记录', '付款结算及违约记录', 
		      '无内容', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
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
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', 'Score Card', 'Score Card', 
		      '有内容', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		ELSE
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, '日常管理信息', 'Score Card', 'Score Card', 
		      '无内容', 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsSummary第' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']，' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO



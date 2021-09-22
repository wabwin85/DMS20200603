DROP PROCEDURE [dbo].[Proc_GetDealerDetailByPMID]

GO

/**********************************************
 ���ܣ���ȡÿ����������������Ϣ��Ϊ����ٶȼ��н��в�ѯ
 ���ߣ�������
 ������ʱ�䣺2012-07-03
 ���¼�¼˵����
 1.���� 2012-07-03
**********************************************/
Create PROCEDURE [dbo].[Proc_GetDealerDetailByPMID]
   @Cust_CD          NVARCHAR (100),
   @ParentModleID    NVARCHAR (100),
   @VersionID        NVARCHAR (100)
AS
   BEGIN
	  --0.DealerGridDataAll
      SELECT dr.*
        FROM (SELECT b.ModleName, a.*
                FROM    dbo.DealerInfo a
                     INNER JOIN
                        dbo.DPModule b
                     ON a.ModleID = b.ModleID
               WHERE     b.IsGrid = 'true'
                     AND b.ModleLevel = '2'
                     AND b.ParentModleID = @ParentModleID) dr
       WHERE dr.Cust_CD = @Cust_CD
     
     --1.BinddtValues
      --��ȡ��ϸ���ݣ����ݴ����VersionID���ж�ʹ�����ַ�ʽ���в�ѯ
      --ȷ��MasterData.T_UDSTR �Ƿ����dbo.DealerMaster && Udstr_CD�Ƿ���� DMA_ID
      IF (@VersionID = 'NULL')
         BEGIN
            SELECT ud.DMA_ChineseName AS CustName, dm.*
              FROM dbo.DealerInfo dm
                   INNER JOIN dbo.DealerMaster  ud
                      ON dm.Cust_CD = ud.DMA_ID
                   INNER JOIN (SELECT t1.ModleID, max (t1.Version) AS Version
                                 FROM dbo.DealerInfo t1, dbo.DPModule t2
                                WHERE     t1.ModleID = t2.ModleID
                                      AND t1.Cust_CD = @Cust_CD
                                      AND t2.ParentModleID = @ParentModleID
                               GROUP BY t1.ModleID) AS MaxVersion
                      ON (    dm.ModleID = MaxVersion.ModleID
                          AND dm.Version = MaxVersion.Version)
             WHERE dm.Cust_CD = @Cust_CD
         END
      ELSE
         BEGIN
            SELECT ud.DMA_ChineseName AS CustName, dm.*
              FROM dbo.DealerInfo dm
                   INNER JOIN dbo.DealerMaster  ud
                      ON dm.Cust_CD = ud.DMA_ID
                   INNER JOIN (SELECT t1.ModleID, max (t1.Version) AS Version
                                 FROM dbo.DealerInfo t1, dbo.DPModule t2
                                WHERE     t1.ModleID = t2.ModleID
                                      AND t1.Cust_CD = @Cust_CD
                                      AND t2.ParentModleID = @ParentModleID
                                      AND t1.Version <= @VersionID
                               GROUP BY t1.ModleID) AS MaxVersion
                      ON (    dm.ModleID = MaxVersion.ModleID
                          AND dm.Version = MaxVersion.Version)
             WHERE dm.Cust_CD = @Cust_CD
         END
         
      --2.GetAllLink
      SELECT a.*
        FROM (SELECT dpm.ModleName,
                     dpa.*,
                     (  dpa.ArchiveName
                      + substring (
                           dpa.ArchiveUrl,
                             len (dpa.ArchiveUrl)
                           - charindex ('.', reverse (dpa.ArchiveUrl))
                           + 1,
                           8000))
                        AS FileNameReturn,
                     --pum.Name_C AS UserName,
                     '' AS UserName,
                     ROW_NUMBER () OVER (ORDER BY dpa.CreateDate DESC)
                        AS [row_number]
                FROM dbo.DPArchive dpa
                     --LEFT JOIN Platform.User_Master pum
                     --   ON dpa.CreateBy = pum.User_ID
                     INNER JOIN dbo.DPModule dpm
                        ON dpm.ModleID = dpa.ModleID
               WHERE     dpa.IsAction = 'true'
                     AND dpa.IsDeleted = 'false'
                     AND dpm.ParentModleID = @ParentModleID) AS a
       WHERE (a.Cust_CD = @Cust_CD) 
       --or a.Cust_CD in (select distinct t2.Udstr_CD from dbo.DPArchive t1,DP.DPExcludeUdstr t2
							--						where t1.Cust_CD = t2.Udstr_CD
							--						and t2.ParentUdstr_CD = @Cust_CD))

    END    
GO



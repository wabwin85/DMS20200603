DROP VIEW [dbo].[View_Membership]
GO

CREATE VIEW [dbo].[View_Membership]
AS
SELECT     dbo.Lafite_Membership.UserId, dbo.Lafite_Membership.Password, dbo.Lafite_Membership.PasswordFormat, dbo.Lafite_Membership.PasswordSalt, 
                      dbo.Lafite_Membership.MobilePIN, dbo.Lafite_Membership.Email, dbo.Lafite_Membership.LoweredEmail, dbo.Lafite_Membership.PasswordQuestion, 
                      dbo.Lafite_Membership.PasswordAnswer, dbo.Lafite_Membership.APP_ID, dbo.Lafite_Membership.IsApproved, dbo.Lafite_Membership.IsLockedOut, 
                      dbo.Lafite_Membership.CreateDate, dbo.Lafite_Membership.LastLoginDate, dbo.Lafite_Membership.LastPassword, 
                      dbo.Lafite_Membership.LastPasswordChangedDate, dbo.Lafite_Membership.LastLockoutDate, dbo.Lafite_Membership.FailedPasswordAttemptCount, 
                      dbo.Lafite_Membership.FailedPasswordAttemptWindowStart, dbo.Lafite_Membership.FailedPasswordAnswerAttemptCount, 
                      dbo.Lafite_Membership.FailedPasswordAnswerAttemptWindowStart, dbo.Lafite_Membership.Comment, dbo.Lafite_IDENTITY.Id, 
                      dbo.Lafite_IDENTITY.IDENTITY_CODE, dbo.Lafite_IDENTITY.LOWERED_IDENTITY_CODE, dbo.Lafite_IDENTITY.IDENTITY_NAME, 
                      dbo.Lafite_IDENTITY.EMAIL1, dbo.Lafite_IDENTITY.EMAIL2, dbo.Lafite_IDENTITY.PHONE, dbo.Lafite_IDENTITY.ADDRESS, 
                      dbo.Lafite_IDENTITY.BOOLEAN_FLAG, dbo.Lafite_IDENTITY.IDENTITY_TYPE, dbo.Lafite_IDENTITY.VALID_DATE_BEGIN, 
                      dbo.Lafite_IDENTITY.VALID_DATE_END, dbo.Lafite_IDENTITY.LastActivityDate, dbo.Lafite_IDENTITY.Corp_ID, 
                      dbo.Lafite_IDENTITY.DELETE_FLAG
FROM         dbo.Lafite_IDENTITY INNER JOIN
                      dbo.Lafite_Membership ON dbo.Lafite_IDENTITY.Id = dbo.Lafite_Membership.UserId

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[16] 4[46] 2[8] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Lafite_IDENTITY"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 209
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Lafite_Membership"
            Begin Extent = 
               Top = 6
               Left = 292
               Bottom = 196
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 64
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Membership'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 3555
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Membership'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_Membership'
GO



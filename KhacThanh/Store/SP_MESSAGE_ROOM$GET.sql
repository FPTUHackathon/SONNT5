USE [DEGOI]
GO

/****** Object:  StoredProcedure [dbo].[SP_MESSAGE_ROOM$GET]    Script Date: 12/1/2017 9:14:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_MESSAGE_ROOM$GET]
	@UserID Nvarchar(128),
	@RoomID int,
	@SrtTime datetime,
	@MaxCount int
AS
BEGIN
	Set NoCount ON
	Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	SET @SQLQuery  = ' SELECT TOP '+ CAST( @MaxCount AS Nvarchar(10)) + ' ' 
	SET @SQLQuery  = @SQLQuery + ' RoomChat.RoomName,'
	SET @SQLQuery  = @SQLQuery + ' RoomChat.RoomId,'
	SET @SQLQuery  = @SQLQuery + ' ISNULL(RoomUsers.Nickname, CONCAT(ISNULL(UserInfor.FirstName,''''),'' '',ISNULL(UserInfor.Lastname,''''))) As FullName,'
	SET @SQLQuery  = @SQLQuery + ' Message.MessContent,'
	SET @SQLQuery  = @SQLQuery + ' Message.Status,'
	SET @SQLQuery  = @SQLQuery + ' Message.CrtTime'
	SET @SQLQuery  = @SQLQuery + ' FROM' 
	SET @SQLQuery  = @SQLQuery + ' Message'
	SET @SQLQuery  = @SQLQuery + ' INNER JOIN RoomChat ON Message.RoomId = RoomChat.RoomId'
	SET @SQLQuery  = @SQLQuery + ' INNER JOIN AspNetUsers ON Message.UserId = AspNetUsers.Id'
	SET @SQLQuery  = @SQLQuery + ' LEFT JOIN UserInfor ON UserInfor.UserId = AspNetUsers.Id'
	SET @SQLQuery  = @SQLQuery + ' INNER JOIN RoomUsers ON RoomChat.RoomId = RoomUsers.RoomId And RoomUsers.UserId = AspNetUsers.Id'
	SET @SQLQuery  = @SQLQuery + ' WHERE Message.CrtTime <  '''+ CONVERT (NVARCHAR, @SrtTime, 21)+'''   '  
	SET @SQLQuery  = @SQLQuery + ' And RoomChat.RoomId = ' + CAST(@RoomID AS Nvarchar(10))  + ' ' 
	SET @SQLQuery  = @SQLQuery + ' And RoomUsers.Status = 0'
	SET @SQLQuery  = @SQLQuery + ' And '''+ @UserID +''' IN (SELECT UserId FROM RoomUsers WHERE RoomUsers.RoomId = ' +  CAST(@RoomID AS Nvarchar(10)) + ' )'
	SET @SQLQuery  = @SQLQuery + ' ORDER BY Message.CrtTime DESC ';
	EXEC sp_Executesql @SQLQuery
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
	ErrorHandler:
    Return(@@ERROR)
END

GO



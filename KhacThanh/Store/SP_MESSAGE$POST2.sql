USE [DEGOI]
GO

/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$POST]    Script Date: 12/2/2017 12:36:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_MESSAGE$POST2]
	@RoomId int,
	@UserId Nvarchar(128),
	@MessContent Text,
	@Status Tinyint,
	@CrtTime datetime
AS
BEGIN
	DECLARE @NEW_MESS_ID AS Nvarchar(20)
	Set NoCount ON
	INSERT INTO Message
           (RoomId
           ,UserId
           ,MessContent
           ,Status
           ,CrtTime)
     VALUES
           (@RoomId
           ,@UserId
           ,@MessContent
           ,@Status
           ,@CrtTime)

	SET @NEW_MESS_ID = SCOPE_IDENTITY();
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
	BEGIN
		SELECT @NEW_MESS_ID AS MESSID;
		Return(@NEW_MESS_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END



GO



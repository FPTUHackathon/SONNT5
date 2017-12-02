USE [DEGOI]
GO
/****** Object:  UserDefinedFunction [dbo].[splitstring]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[splitstring] ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CommentLike]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommentLike](
	[CmtId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[LikeStatus] [tinyint] NOT NULL,
	[UpdTime] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryName] [nchar](30) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Language]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[LanguageId] [int] IDENTITY(1,1) NOT NULL,
	[LanguageName] [nchar](20) NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LanguageUser]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LanguageUser](
	[UserId] [nvarchar](128) NOT NULL,
	[LanguageID] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LogUser]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogUser](
	[LogId] [int] IDENTITY(1000,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[Activity] [nvarchar](50) NOT NULL,
	[CrtTime] [nchar](10) NOT NULL,
 CONSTRAINT [PK_LogUser] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LogVideo]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogVideo](
	[Videoid] [int] IDENTITY(1000,1) NOT NULL,
	[UserId1] [nvarchar](128) NULL,
	[UserId2] [nvarchar](128) NULL,
	[SrtTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Status] [tinyint] NULL,
 CONSTRAINT [PK_LogVideo] PRIMARY KEY CLUSTERED 
(
	[Videoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Message]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[MessageId] [int] IDENTITY(10000,1) NOT NULL,
	[RoomId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[MessContent] [text] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CrtTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Message] PRIMARY KEY CLUSTERED 
(
	[MessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Post]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[PostId] [int] IDENTITY(1000,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[PostTitle] [nvarchar](50) NOT NULL,
	[PostContent] [text] NOT NULL,
	[CrtTime] [datetime] NOT NULL,
	[UpdTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PostComment]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostComment](
	[CmtId] [int] IDENTITY(1000,1) NOT NULL,
	[PostId] [int] NOT NULL,
	[UserId] [nvarchar](128) NULL,
	[CmtContent] [text] NOT NULL,
	[LikeCount] [int] NOT NULL,
	[CrtTime] [datetime] NOT NULL,
	[UpdTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PostComment] PRIMARY KEY CLUSTERED 
(
	[CmtId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PostReply]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostReply](
	[ReplyId] [int] IDENTITY(1000,1) NOT NULL,
	[CmtId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ReplyContent] [text] NOT NULL,
	[CrtTime] [datetime] NOT NULL,
 CONSTRAINT [PK_PostReply] PRIMARY KEY CLUSTERED 
(
	[ReplyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PostTag]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostTag](
	[PostId] [int] NOT NULL,
	[TagId] [int] NOT NULL,
	[CrtTime] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Relationship]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relationship](
	[UserId1] [nvarchar](128) NOT NULL,
	[UserId2] [nvarchar](128) NOT NULL,
	[Status] [nchar](10) NOT NULL,
	[UpdTime] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomChat]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomChat](
	[RoomId] [int] IDENTITY(1000,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[RoomName] [nvarchar](50) NOT NULL,
	[CrtTime] [datetime] NOT NULL,
 CONSTRAINT [PK_RoomChat] PRIMARY KEY CLUSTERED 
(
	[RoomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomUsers]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomUsers](
	[RoomId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[NickName] [nvarchar](50) NOT NULL,
	[Status] [tinyint] NOT NULL,
	[CrtDate] [datetime] NOT NULL,
	[UpdDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tag]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tag](
	[TagID] [int] IDENTITY(1000,1) NOT NULL,
	[TagName] [nvarchar](20) NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserInfor]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInfor](
	[UserId] [nvarchar](128) NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[Gender] [bit] NOT NULL,
	[DOB] [date] NULL,
	[About] [nvarchar](256) NULL,
	[CountryId] [int] NULL,
	[status] [tinyint] NOT NULL
) ON [PRIMARY]

GO
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'anhnttse04296@fpt.edu.vn', 0, N'AIaCZXObQMg1+7VItfIrAqelt8qqgo2DWoEHSFsQPIW82HXdW8nFqE5Nup9Fh7UImw==', N'ff6c45e0-6422-4deb-a0cc-e3a835f76b9e', NULL, 0, 0, NULL, 0, 0, N'anhnttse04296@fpt.edu.vn')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'phungthanh172@gmail.com', 0, N'ABLZjUIOoVYaSzqg4jnS7kPmZBvFgjForjxUJHe3XZY87LTytDduyZTHHtgNNyXMnA==', N'c9c8f622-5c19-467a-bd40-96e6972e095e', NULL, 0, 0, NULL, 0, 0, N'phungthanh172@gmail.com')
SET IDENTITY_INSERT [dbo].[Message] ON 

INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10000, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Hello', 0, CAST(N'2017-12-01T12:00:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10001, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'My name is Tuan Anh', 0, CAST(N'2017-12-01T12:01:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10002, 1000, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'Hi', 0, CAST(N'2017-12-01T12:02:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10003, 1000, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'My name is Thanh. Nice to meet you', 0, CAST(N'2017-12-01T12:03:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10004, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Nice to meet you', 0, CAST(N'2017-12-01T12:04:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10005, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Dem tu 1 den 10 : 1', 0, CAST(N'2017-12-02T00:02:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10006, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Dem tu 1 den 10 : 2', 0, CAST(N'2017-12-02T00:05:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10007, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Dem tu 1 den 10 : 3', 0, CAST(N'2017-12-02T00:44:36.333' AS DateTime))
SET IDENTITY_INSERT [dbo].[Message] OFF
SET IDENTITY_INSERT [dbo].[Post] ON 

INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 1', N'Hello This is MyPost', CAST(N'2017-12-01T12:04:00.000' AS DateTime), CAST(N'2017-12-01T12:04:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1001, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 2', N'Hello This is second post', CAST(N'2017-12-01T15:00:00.000' AS DateTime), CAST(N'2017-12-01T15:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1003, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'Title 3', N'Ahihi', CAST(N'2017-12-01T16:00:00.000' AS DateTime), CAST(N'2017-12-01T16:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1004, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'Title 4', N'Ahihi 2', CAST(N'2017-12-01T16:30:00.000' AS DateTime), CAST(N'2017-12-01T16:30:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1005, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'Title 5', N'Ahihi 3', CAST(N'2017-12-01T16:31:00.000' AS DateTime), CAST(N'2017-12-01T16:31:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1006, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 6', N'Em thich mau hong', CAST(N'2017-12-01T23:50:12.400' AS DateTime), CAST(N'2017-12-01T23:50:12.400' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1007, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 7', N'Em thich mau trang', CAST(N'2017-12-02T00:00:00.000' AS DateTime), CAST(N'2017-12-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1008, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 8', N'Em thich mau trang', CAST(N'2017-12-02T00:00:00.000' AS DateTime), CAST(N'2017-12-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1009, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 9', N'Em thich mau trang', CAST(N'2017-12-02T00:23:16.800' AS DateTime), CAST(N'2017-12-02T00:23:16.800' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1010, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 10', N'Em thich mau trang', CAST(N'2017-12-02T00:24:14.183' AS DateTime), CAST(N'2017-12-02T00:24:14.183' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1011, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 11', N'Em thich mau trang', CAST(N'2017-12-02T00:00:00.000' AS DateTime), CAST(N'2017-12-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1012, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 12', N'Em thich mau trang', CAST(N'2017-12-02T00:00:00.000' AS DateTime), CAST(N'2017-12-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1013, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 13', N'Em thich mau trang', CAST(N'2017-12-02T00:26:01.070' AS DateTime), CAST(N'2017-12-02T00:26:01.070' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1014, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 14', N'Em thich mau trang 1', CAST(N'2017-12-02T00:00:00.000' AS DateTime), CAST(N'2017-12-02T00:00:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1015, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 100', N'Em thich mau trang 1', CAST(N'2017-12-02T08:40:49.710' AS DateTime), CAST(N'2017-12-02T08:40:49.710' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostTitle], [PostContent], [CrtTime], [UpdTime]) VALUES (1016, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Title 101', N'Em thich mau trang 2', CAST(N'2017-12-02T00:00:00.000' AS DateTime), CAST(N'2017-12-02T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Post] OFF
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1000, 1000, CAST(N'2017-12-01T12:04:00.000' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1000, 1002, CAST(N'2017-12-01T12:04:00.000' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1001, 1000, CAST(N'2017-12-01T15:00:00.000' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1001, 1003, CAST(N'2017-12-01T15:00:00.000' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1004, 1001, CAST(N'2017-12-01T23:44:41.177' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1004, 1003, CAST(N'2017-12-01T23:44:41.177' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1004, 1004, CAST(N'2017-12-01T23:44:41.177' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1006, 1001, CAST(N'2017-12-01T23:50:12.403' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1006, 1002, CAST(N'2017-12-01T23:50:12.403' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1006, 1003, CAST(N'2017-12-01T23:50:12.403' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1007, 1001, CAST(N'2017-12-01T23:54:28.870' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1007, 1002, CAST(N'2017-12-01T23:54:28.870' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1007, 1004, CAST(N'2017-12-01T23:54:28.870' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1008, 1001, CAST(N'2017-12-02T00:23:07.760' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1008, 1002, CAST(N'2017-12-02T00:23:07.760' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1008, 1004, CAST(N'2017-12-02T00:23:07.760' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1009, 1001, CAST(N'2017-12-02T00:23:16.803' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1009, 1002, CAST(N'2017-12-02T00:23:16.803' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1009, 1004, CAST(N'2017-12-02T00:23:16.803' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1010, 1001, CAST(N'2017-12-02T00:24:14.183' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1010, 1002, CAST(N'2017-12-02T00:24:14.183' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1010, 1004, CAST(N'2017-12-02T00:24:14.183' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1011, 1001, CAST(N'2017-12-02T00:24:18.193' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1011, 1002, CAST(N'2017-12-02T00:24:18.193' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1011, 1004, CAST(N'2017-12-02T00:24:18.193' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1012, 1001, CAST(N'2017-12-02T00:25:58.487' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1012, 1002, CAST(N'2017-12-02T00:25:58.487' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1012, 1004, CAST(N'2017-12-02T00:25:58.487' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1013, 1001, CAST(N'2017-12-02T00:26:01.070' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1013, 1002, CAST(N'2017-12-02T00:26:01.070' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1013, 1004, CAST(N'2017-12-02T00:26:01.070' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1014, 1001, CAST(N'2017-12-02T00:46:12.437' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1014, 1002, CAST(N'2017-12-02T00:46:12.437' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1014, 1004, CAST(N'2017-12-02T00:46:12.437' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1015, 1001, CAST(N'2017-12-02T08:40:49.710' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1015, 1002, CAST(N'2017-12-02T08:40:49.710' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1015, 1004, CAST(N'2017-12-02T08:40:49.710' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1016, 1001, CAST(N'2017-12-02T08:42:31.000' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1016, 1002, CAST(N'2017-12-02T08:42:31.000' AS DateTime))
INSERT [dbo].[PostTag] ([PostId], [TagId], [CrtTime]) VALUES (1016, 1004, CAST(N'2017-12-02T08:42:31.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[RoomChat] ON 

INSERT [dbo].[RoomChat] ([RoomId], [UserId], [RoomName], [CrtTime]) VALUES (1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Test', CAST(N'2017-12-01T12:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[RoomChat] OFF
INSERT [dbo].[RoomUsers] ([RoomId], [UserId], [NickName], [Status], [CrtDate], [UpdDate]) VALUES (1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Thanh', 0, CAST(N'2017-12-01T12:00:00.000' AS DateTime), CAST(N'2017-12-01T12:00:00.000' AS DateTime))
INSERT [dbo].[RoomUsers] ([RoomId], [UserId], [NickName], [Status], [CrtDate], [UpdDate]) VALUES (1000, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'TAnh', 0, CAST(N'2017-12-01T12:00:00.000' AS DateTime), CAST(N'2017-12-01T12:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Tag] ON 

INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1000, N'English')
INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1001, N'Japanese')
INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1002, N'Grammar')
INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1003, N'Vocabulary')
INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1004, N'Pronunciation')
INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1005, N'Share')
INSERT [dbo].[Tag] ([TagID], [TagName]) VALUES (1006, N'Homework')
SET IDENTITY_INSERT [dbo].[Tag] OFF
INSERT [dbo].[UserInfor] ([UserId], [FirstName], [LastName], [Gender], [DOB], [About], [CountryId], [status]) VALUES (N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'Phùng Khắc', N'Thành', 1, CAST(N'1996-02-17' AS Date), N'Yêu màu tím hay khóc thầm và thích sự thủy chung ', NULL, 1)
INSERT [dbo].[UserInfor] ([UserId], [FirstName], [LastName], [Gender], [DOB], [About], [CountryId], [status]) VALUES (N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Nguyễn Tiến Tuấn', N'Anh', 1, CAST(N'1996-09-26' AS Date), N'Thích màu hồng và hay mặc đồ chấm bi', NULL, 1)
/****** Object:  Index [CrtTimeVideo]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [CrtTimeVideo] ON [dbo].[LogVideo]
(
	[SrtTime] DESC,
	[EndTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IndexUser1Video]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [IndexUser1Video] ON [dbo].[LogVideo]
(
	[UserId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IndexUser2Video]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [IndexUser2Video] ON [dbo].[LogVideo]
(
	[UserId2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CrtTimeMessage]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [CrtTimeMessage] ON [dbo].[Message]
(
	[CrtTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IndexUser2Message]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [IndexUser2Message] ON [dbo].[Message]
(
	[MessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CrtTimePostReply]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [CrtTimePostReply] ON [dbo].[PostReply]
(
	[CrtTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PostReply]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [IX_PostReply] ON [dbo].[PostReply]
(
	[ReplyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CrtTimeRelationship]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [CrtTimeRelationship] ON [dbo].[Relationship]
(
	[UpdTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [User1Relationship]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [User1Relationship] ON [dbo].[Relationship]
(
	[UserId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [User2Relationship]    Script Date: 12/2/2017 8:43:41 AM ******/
CREATE NONCLUSTERED INDEX [User2Relationship] ON [dbo].[Relationship]
(
	[UserId2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[CommentLike]  WITH CHECK ADD  CONSTRAINT [FK_CommentLike_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[CommentLike] CHECK CONSTRAINT [FK_CommentLike_AspNetUsers]
GO
ALTER TABLE [dbo].[CommentLike]  WITH CHECK ADD  CONSTRAINT [FK_CommentLike_PostComment] FOREIGN KEY([CmtId])
REFERENCES [dbo].[PostComment] ([CmtId])
GO
ALTER TABLE [dbo].[CommentLike] CHECK CONSTRAINT [FK_CommentLike_PostComment]
GO
ALTER TABLE [dbo].[LanguageUser]  WITH CHECK ADD  CONSTRAINT [FK_LanguageUser_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[LanguageUser] CHECK CONSTRAINT [FK_LanguageUser_AspNetUsers]
GO
ALTER TABLE [dbo].[LanguageUser]  WITH CHECK ADD  CONSTRAINT [FK_LanguageUser_Language] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[Language] ([LanguageId])
GO
ALTER TABLE [dbo].[LanguageUser] CHECK CONSTRAINT [FK_LanguageUser_Language]
GO
ALTER TABLE [dbo].[LogUser]  WITH CHECK ADD  CONSTRAINT [FK_LogUser_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[LogUser] CHECK CONSTRAINT [FK_LogUser_AspNetUsers]
GO
ALTER TABLE [dbo].[LogVideo]  WITH CHECK ADD  CONSTRAINT [FK_LogVideo_AspNetUsers] FOREIGN KEY([UserId1])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[LogVideo] CHECK CONSTRAINT [FK_LogVideo_AspNetUsers]
GO
ALTER TABLE [dbo].[LogVideo]  WITH CHECK ADD  CONSTRAINT [FK_LogVideo_AspNetUsers1] FOREIGN KEY([UserId2])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[LogVideo] CHECK CONSTRAINT [FK_LogVideo_AspNetUsers1]
GO
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_AspNetUsers2] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_AspNetUsers2]
GO
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Message_RoomChat] FOREIGN KEY([RoomId])
REFERENCES [dbo].[RoomChat] ([RoomId])
GO
ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_RoomChat]
GO
ALTER TABLE [dbo].[Post]  WITH CHECK ADD  CONSTRAINT [FK_Post_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Post] CHECK CONSTRAINT [FK_Post_AspNetUsers]
GO
ALTER TABLE [dbo].[PostComment]  WITH CHECK ADD  CONSTRAINT [FK_PostComment_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[PostComment] CHECK CONSTRAINT [FK_PostComment_AspNetUsers]
GO
ALTER TABLE [dbo].[PostComment]  WITH CHECK ADD  CONSTRAINT [FK_PostComment_Post] FOREIGN KEY([PostId])
REFERENCES [dbo].[Post] ([PostId])
GO
ALTER TABLE [dbo].[PostComment] CHECK CONSTRAINT [FK_PostComment_Post]
GO
ALTER TABLE [dbo].[PostReply]  WITH CHECK ADD  CONSTRAINT [FK_PostReply_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[PostReply] CHECK CONSTRAINT [FK_PostReply_AspNetUsers]
GO
ALTER TABLE [dbo].[PostReply]  WITH CHECK ADD  CONSTRAINT [FK_PostReply_PostComment] FOREIGN KEY([CmtId])
REFERENCES [dbo].[PostComment] ([CmtId])
GO
ALTER TABLE [dbo].[PostReply] CHECK CONSTRAINT [FK_PostReply_PostComment]
GO
ALTER TABLE [dbo].[PostTag]  WITH CHECK ADD  CONSTRAINT [FK_PostTag_Post] FOREIGN KEY([PostId])
REFERENCES [dbo].[Post] ([PostId])
GO
ALTER TABLE [dbo].[PostTag] CHECK CONSTRAINT [FK_PostTag_Post]
GO
ALTER TABLE [dbo].[PostTag]  WITH CHECK ADD  CONSTRAINT [FK_PostTag_Tag] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tag] ([TagID])
GO
ALTER TABLE [dbo].[PostTag] CHECK CONSTRAINT [FK_PostTag_Tag]
GO
ALTER TABLE [dbo].[Relationship]  WITH CHECK ADD  CONSTRAINT [FK_Relationship_AspNetUsers] FOREIGN KEY([UserId1])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Relationship] CHECK CONSTRAINT [FK_Relationship_AspNetUsers]
GO
ALTER TABLE [dbo].[Relationship]  WITH CHECK ADD  CONSTRAINT [FK_Relationship_AspNetUsers1] FOREIGN KEY([UserId2])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[Relationship] CHECK CONSTRAINT [FK_Relationship_AspNetUsers1]
GO
ALTER TABLE [dbo].[RoomUsers]  WITH CHECK ADD  CONSTRAINT [FK_RoomUsers_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[RoomUsers] CHECK CONSTRAINT [FK_RoomUsers_AspNetUsers]
GO
ALTER TABLE [dbo].[RoomUsers]  WITH CHECK ADD  CONSTRAINT [FK_RoomUsers_RoomChat] FOREIGN KEY([RoomId])
REFERENCES [dbo].[RoomChat] ([RoomId])
GO
ALTER TABLE [dbo].[RoomUsers] CHECK CONSTRAINT [FK_RoomUsers_RoomChat]
GO
ALTER TABLE [dbo].[UserInfor]  WITH CHECK ADD  CONSTRAINT [FK_UserInfor_AspNetUsers] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[UserInfor] CHECK CONSTRAINT [FK_UserInfor_AspNetUsers]
GO
ALTER TABLE [dbo].[UserInfor]  WITH CHECK ADD  CONSTRAINT [FK_UserInfor_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[UserInfor] CHECK CONSTRAINT [FK_UserInfor_Country]
GO
/****** Object:  StoredProcedure [dbo].[SP_MESSAGE$POST]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SP_MESSAGE$POST]
	@RoomId int,
	@UserId Nvarchar(128),
	@MessContent Text,
	@Status Tinyint
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
           ,GETDATE())

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
/****** Object:  StoredProcedure [dbo].[SP_MESSAGE$POST2]    Script Date: 12/2/2017 8:43:41 AM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_MESSAGE_ROOM$GET]    Script Date: 12/2/2017 8:43:41 AM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$GET]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_POST_TAG$GET]
	@TagId int
AS
BEGIN
	Set NoCount ON
	Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	SET @SQLQuery  = 'SELECT '
	SET @SQLQuery  = @SQLQuery + '	Post.PostId																'
	SET @SQLQuery  = @SQLQuery + '	,Post.PostTitle                                                         '
	SET @SQLQuery  = @SQLQuery + '	,Post.PostContent                                                       '
	SET @SQLQuery  = @SQLQuery + '	,TagTbl.TagList                                                         '
	SET @SQLQuery  = @SQLQuery + '	,CONCAT(ISNULL(UserInfor.FirstName,''''),'' '',ISNULL(UserInfor.Lastname,'''')) AS FullName '    
	SET @SQLQuery  = @SQLQuery + '	,Post.CrtTime															'
	SET @SQLQuery  = @SQLQuery + '  FROM Post                                                               '
	SET @SQLQuery  = @SQLQuery + '  LEFT JOIN UserInfor ON Post.UserId = UserInfor.UserId					'
	SET @SQLQuery  = @SQLQuery + '  LEFT JOIN                                                               '
	SET @SQLQuery  = @SQLQuery + '  (SELECT post.PostId,                                                    '
	SET @SQLQuery  = @SQLQuery + '		TagList =		STUFF((                                             '
	SET @SQLQuery  = @SQLQuery + '          SELECT '','' + CAST(Tag.TagName AS VARCHAR(30))                 '
	SET @SQLQuery  = @SQLQuery + '          FROM PostTag postTag                                            '
	SET @SQLQuery  = @SQLQuery + '		  JOIN Tag ON postTag.TagId = Tag.TagId                             '
	SET @SQLQuery  = @SQLQuery + '		  WHERE postTag.PostId = post.PostId                                '
	SET @SQLQuery  = @SQLQuery + '          FOR XML PATH(''''), TYPE).value(''.'', ''NVARCHAR(MAX)''), 1, 1, '''')  '
	SET @SQLQuery  = @SQLQuery + '   FROM PostTag post                                                      '
	SET @SQLQuery  = @SQLQuery + '   GROUP BY post.PostId ) TagTbl ON Post.PostId = TagTbl.PostId           '
	SET @SQLQuery  = @SQLQuery + '  WHERE Post.PostId IN (SELECT Post.PostId                                '
	SET @SQLQuery  = @SQLQuery + '		   FROM                                                             '
	SET @SQLQuery  = @SQLQuery + '		  Post                                                              '
	SET @SQLQuery  = @SQLQuery + '		   JOIN PostTag ON Post.PostId = PostTag.PostId                     '
	SET @SQLQuery  = @SQLQuery + '		  LEFT JOIN Tag ON Tag.TagId = PostTag.TagId                        '
	SET @SQLQuery  = @SQLQuery + '		  WHERE PostTag.TagId = ' + CAST(@TagId AS Nvarchar(10)) +')        '
	EXEC sp_Executesql @SQLQuery
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
	ErrorHandler:
    Return(@@ERROR)
END


GO
/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$POST]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_POST_TAG$POST]
	@UserId Nvarchar(128),
	@PostTitle Nvarchar(50),
	@PostContent Text,
	@TagId Text
AS
BEGIN
	DECLARE @NEW_POST_ID AS Nvarchar(20)
	DECLARE @ABCD AS Nvarchar(100)
	Set NoCount ON
	INSERT INTO Post(
			UserId
			,PostTitle
		   ,PostContent
           ,CrtTime
           ,UpdTime)
     VALUES
           (@UserId
		   ,@PostTitle
           ,@PostContent
           ,GETDATE()
           ,GETDATE())
	SET @NEW_POST_ID = SCOPE_IDENTITY();
	
	INSERT INTO PostTag
			   (PostId
			   ,TagId
			   ,CrtTime)
	SELECT @NEW_POST_ID AS PostID ,
	NAME AS TagID,
	GETDATE() AS CrtDate
	FROM splitstring(@TagId);
	 
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
	BEGIN
		SELECT @NEW_POST_ID AS POST;
		Return(@NEW_POST_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END



GO
/****** Object:  StoredProcedure [dbo].[SP_POST_TAG$POST2]    Script Date: 12/2/2017 8:43:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SP_POST_TAG$POST2]
	@UserId Nvarchar(128),
	@PostTitle Nvarchar(50),
	@PostContent Text,
	@TagId Text,
	@CrtDate datetime
AS
BEGIN
	DECLARE @NEW_POST_ID AS Nvarchar(20)
	DECLARE @ABCD AS Nvarchar(100)
	Set NoCount ON
	INSERT INTO Post(
			UserId
			,PostTitle
		   ,PostContent
           ,CrtTime
           ,UpdTime)
     VALUES
           (@UserId
		   ,@PostTitle
           ,@PostContent
           ,@CrtDate
           ,@CrtDate)
	SET @NEW_POST_ID = SCOPE_IDENTITY();
	
	INSERT INTO PostTag
			   (PostId
			   ,TagId
			   ,CrtTime)
	SELECT @NEW_POST_ID AS PostID ,
	NAME AS TagID,
	GETDATE() AS CrtDate
	FROM splitstring(@TagId);
	 
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
	BEGIN
		SELECT @NEW_POST_ID;
	    Return(@NEW_POST_ID)
	END
	ErrorHandler:
    BEGIN
		SELECT '-1';
		Return(0)
	END
END



GO

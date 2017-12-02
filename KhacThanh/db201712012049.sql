USE [master]
GO
/****** Object:  Database [DEGOI]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE DATABASE [DEGOI]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DEGOI', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DEGOI.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DEGOI_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DEGOI_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DEGOI].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DEGOI] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DEGOI] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DEGOI] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DEGOI] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DEGOI] SET ARITHABORT OFF 
GO
ALTER DATABASE [DEGOI] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DEGOI] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DEGOI] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DEGOI] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DEGOI] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DEGOI] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DEGOI] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DEGOI] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DEGOI] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DEGOI] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DEGOI] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DEGOI] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DEGOI] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DEGOI] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DEGOI] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DEGOI] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DEGOI] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DEGOI] SET RECOVERY FULL 
GO
ALTER DATABASE [DEGOI] SET  MULTI_USER 
GO
ALTER DATABASE [DEGOI] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DEGOI] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DEGOI] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DEGOI] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DEGOI] SET DELAYED_DURABILITY = DISABLED 
GO
USE [DEGOI]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [DEGOI]
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[CommentLike]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[LogUser]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogUser](
	[LogId] [int] IDENTITY(1,1000) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[Activity] [nvarchar](50) NOT NULL,
	[CrtTime] [nchar](10) NOT NULL,
 CONSTRAINT [PK_LogUser] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LogVideo]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogVideo](
	[Videoid] [int] NOT NULL,
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
/****** Object:  Table [dbo].[Message]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Message](
	[MessageId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[Post]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[PostId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[PostContent] [text] NOT NULL,
	[CrtTime] [datetime] NOT NULL,
	[UpdTime] [datetime] NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[PostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PostComment]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostComment](
	[CmtId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[PostReply]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PostReply](
	[ReplyId] [int] NOT NULL,
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
/****** Object:  Table [dbo].[PostTag]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[Relationship]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[RoomChat]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomChat](
	[RoomId] [int] NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[RoomName] [nvarchar](50) NOT NULL,
	[CrtTime] [datetime] NOT NULL,
 CONSTRAINT [PK_RoomChat] PRIMARY KEY CLUSTERED 
(
	[RoomId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RoomUsers]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  Table [dbo].[Tag]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tag](
	[TagID] [int] NOT NULL,
	[TagName] [nvarchar](20) NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserInfor]    Script Date: 12/1/2017 8:49:56 PM ******/
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
	[status] [tinyint] NOT NULL
) ON [PRIMARY]

GO
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'anhnttse04296@fpt.edu.vn', 0, N'AIaCZXObQMg1+7VItfIrAqelt8qqgo2DWoEHSFsQPIW82HXdW8nFqE5Nup9Fh7UImw==', N'ff6c45e0-6422-4deb-a0cc-e3a835f76b9e', NULL, 0, 0, NULL, 0, 0, N'anhnttse04296@fpt.edu.vn')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'phungthanh172@gmail.com', 0, N'ABLZjUIOoVYaSzqg4jnS7kPmZBvFgjForjxUJHe3XZY87LTytDduyZTHHtgNNyXMnA==', N'c9c8f622-5c19-467a-bd40-96e6972e095e', NULL, 0, 0, NULL, 0, 0, N'phungthanh172@gmail.com')
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10000, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Hello', 0, CAST(N'2017-12-01T12:00:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10001, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'My name is Tuan Anh', 0, CAST(N'2017-12-01T12:01:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10002, 1000, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'Hi', 0, CAST(N'2017-12-01T12:02:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10003, 1000, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'My name is Thanh. Nice to meet you', 0, CAST(N'2017-12-01T12:03:00.000' AS DateTime))
INSERT [dbo].[Message] ([MessageId], [RoomId], [UserId], [MessContent], [Status], [CrtTime]) VALUES (10004, 1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Nice to meet you', 0, CAST(N'2017-12-01T12:04:00.000' AS DateTime))
INSERT [dbo].[Post] ([PostId], [UserId], [PostContent], [CrtTime], [UpdTime]) VALUES (1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Hello This is MyPost', CAST(N'2017-12-01T12:04:00.000' AS DateTime), CAST(N'2017-12-01T12:04:00.000' AS DateTime))
INSERT [dbo].[RoomChat] ([RoomId], [UserId], [RoomName], [CrtTime]) VALUES (1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Test', CAST(N'2017-12-01T12:00:00.000' AS DateTime))
INSERT [dbo].[RoomUsers] ([RoomId], [UserId], [NickName], [Status], [CrtDate], [UpdDate]) VALUES (1000, N'1459aaa0-4763-4f3e-99e2-1521e2e00bae', N'Thanh', 0, CAST(N'2017-12-01T12:00:00.000' AS DateTime), CAST(N'2017-12-01T12:00:00.000' AS DateTime))
INSERT [dbo].[RoomUsers] ([RoomId], [UserId], [NickName], [Status], [CrtDate], [UpdDate]) VALUES (1000, N'37b0dafd-ac3e-499d-ba39-d566c6d9467c', N'TAnh', 0, CAST(N'2017-12-01T12:00:00.000' AS DateTime), CAST(N'2017-12-01T12:00:00.000' AS DateTime))
/****** Object:  Index [CrtTimeVideo]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [CrtTimeVideo] ON [dbo].[LogVideo]
(
	[SrtTime] DESC,
	[EndTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IndexUser1Video]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [IndexUser1Video] ON [dbo].[LogVideo]
(
	[UserId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IndexUser2Video]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [IndexUser2Video] ON [dbo].[LogVideo]
(
	[UserId2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CrtTimeMessage]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [CrtTimeMessage] ON [dbo].[Message]
(
	[CrtTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IndexUser2Message]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [IndexUser2Message] ON [dbo].[Message]
(
	[MessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CrtTimePostReply]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [CrtTimePostReply] ON [dbo].[PostReply]
(
	[CrtTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PostReply]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [IX_PostReply] ON [dbo].[PostReply]
(
	[ReplyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [CrtTimeRelationship]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [CrtTimeRelationship] ON [dbo].[Relationship]
(
	[UpdTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [User1Relationship]    Script Date: 12/1/2017 8:49:56 PM ******/
CREATE NONCLUSTERED INDEX [User1Relationship] ON [dbo].[Relationship]
(
	[UserId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [User2Relationship]    Script Date: 12/1/2017 8:49:56 PM ******/
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
/****** Object:  StoredProcedure [dbo].[SP_MESSAGE_ROOM$GET]    Script Date: 12/1/2017 8:49:56 PM ******/
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
	SET @SQLQuery  = ' SELECT TOP 3 ' 
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
	SET @SQLQuery  = @SQLQuery + ' WHERE Message.CrtTime < ''2017-12-01 12:30:00.000'''  
	SET @SQLQuery  = @SQLQuery + ' And RoomChat.RoomId = ''1000''' 
	SET @SQLQuery  = @SQLQuery + ' And RoomUsers.Status = 0'
	-- SET @SQLQuery  = @SQLQuery + ' And @UserID IN (SELECT UserId FROM RoomUsers WHERE RoomUsers.RoomId = @RoomID )'
	SET @SQLQuery  = @SQLQuery + ' ORDER BY Message.CrtTime DESC ';
	SELECT @SQLQuery;
	Set @ParamDefinition =      ' @MaxCount int,
                @SrtTime datetime,
                @RoomID int'
	EXEC sp_Executesql @SQLQuery
			--,
			--@ParamDefinition,
			--@MaxCount, 
			--@SrtTime,
			--@RoomID;
			--@UserID
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
	ErrorHandler:
    Return(@@ERROR)
END

GO
/****** Object:  StoredProcedure [dbo].[SP_MESSAGE_ROOM$GET2]    Script Date: 12/1/2017 8:49:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_MESSAGE_ROOM$GET2]
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
	SET @SQLQuery  = @SQLQuery + ' WHERE Message.CrtTime < ''2017-12-01 12:30:00.000'''  
	SET @SQLQuery  = @SQLQuery + ' And RoomChat.RoomId = ''1000''' 
	SET @SQLQuery  = @SQLQuery + ' And RoomUsers.Status = 0'
	-- SET @SQLQuery  = @SQLQuery + ' And @UserID IN (SELECT UserId FROM RoomUsers WHERE RoomUsers.RoomId = @RoomID )'
	SET @SQLQuery  = @SQLQuery + ' ORDER BY Message.CrtTime DESC ';
	SELECT @SQLQuery;
	Set @ParamDefinition =      ' @MaxCount int'--,'
--                @SrtTime datetime,
  --              @RoomID int'
	EXEC sp_Executesql @SQLQuery
			,
			@ParamDefinition,
			@MaxCount; --, 
			--@SrtTime,
			--@RoomID;
			--@UserID
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
	ErrorHandler:
    Return(@@ERROR)
END

GO
USE [master]
GO
ALTER DATABASE [DEGOI] SET  READ_WRITE 
GO

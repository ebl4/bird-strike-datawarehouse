USE [master]
GO
/****** Object:  Database [bird strike]    Script Date: 04-11-2015 15:37:03 ******/
CREATE DATABASE [bird strike]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bird strike', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\bird strike.mdf' , SIZE = 105472KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bird strike_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\bird strike_log.ldf' , SIZE = 2816KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [bird strike] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bird strike].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bird strike] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bird strike] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bird strike] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bird strike] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bird strike] SET ARITHABORT OFF 
GO
ALTER DATABASE [bird strike] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bird strike] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bird strike] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bird strike] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bird strike] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bird strike] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bird strike] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bird strike] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bird strike] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bird strike] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bird strike] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bird strike] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bird strike] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bird strike] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bird strike] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bird strike] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bird strike] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bird strike] SET RECOVERY FULL 
GO
ALTER DATABASE [bird strike] SET  MULTI_USER 
GO
ALTER DATABASE [bird strike] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bird strike] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bird strike] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bird strike] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [bird strike] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'bird strike', N'ON'
GO
USE [bird strike]
GO
/****** Object:  Table [dbo].['Dim Aircraft']    Script Date: 04-11-2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['Dim Aircraft'](
	[key_dim_aircraft] [float] NOT NULL,
	[Aircraft: Type] [nvarchar](255) NULL,
	[Aircraft: Make/Model] [nvarchar](255) NULL,
	[Aircraft: Flight Number] [float] NULL,
	[Aircraft: Number of engines?] [float] NULL,
	[Aircraft: Airline/Operator] [nvarchar](255) NULL,
	[Speed (IAS) in knots] [float] NULL,
	CONSTRAINT aircraft_pk PRIMARY KEY (key_dim_aircraft)
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].['Dim Date']    Script Date: 04-11-2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['Dim Date'](
	[key_dim_date] [float] NOT NULL,
	[FlightDate] [datetime] NULL,
	[Reported] [datetime] NULL,
	[Time (HHMM)] [float] NULL,
	[Time of day] [nvarchar](255) NULL,
	CONSTRAINT date_pk PRIMARY KEY (key_dim_date)
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].['Dim Effect']    Script Date: 04-11-2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['Dim Effect'](
	[key_dim_effect] [float] NOT NULL,
	[Effect: Impact to flight] [nvarchar](255) NULL,
	[Effect: Other] [nvarchar](255) NULL,
	[Effect: Indicated Damage] [nvarchar](255) NULL,
	[Remarks] [nvarchar](255) NULL,
	CONSTRAINT effect_pk PRIMARY KEY (key_dim_effect)
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].['Dim Location']    Script Date: 04-11-2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['Dim Location'](
	[key_dim_location] [float] NOT NULL,
	[Nearby if en route] [nvarchar](255) NULL,
	[Freeform en route] [nvarchar](255) NULL,
	[Number of engines?] [float] NULL,
	[Origin State] [nvarchar](255) NULL,
	CONSTRAINT location_pk PRIMARY KEY (key_dim_location)
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].['Dim Wildlife']    Script Date: 04-11-2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['Dim Wildlife'](
	[key_dim_wildlife] [float] NOT NULL,
	[Number struck] [nvarchar](255) NULL,
	[Size] [nvarchar](255) NULL,
	[Species] [nvarchar](255) NULL,	
	CONSTRAINT wildlife_pk PRIMARY KEY (key_dim_wildlife)
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].['FactBirdStrikes']    Script Date: 04-11-2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['FactBirdStrikes'](
	[key_dim_aircraft] [float] NOT NULL,
	[key_dim_date] [float] NOT NULL,
	[key_dim_effect] [float] NOT NULL,
	[key_dim_location] [float] NOT NULL,
	[key_dim_wildlife] [float] NOT NULL,
	[Altitude bin] [nvarchar](255) NULL,
	[Cost: Other (inflation adj)] [float] NULL,
	[Cost: Repair (inflation adj)] [float] NULL,
	[Cost: Total $] [float] NULL,
	[Feet above ground] [float] NULL
	CONSTRAINT factBS_pk PRIMARY KEY (key_dim_aircraft, key_dim_wildlife, key_dim_date, 
	key_dim_effect, key_dim_location),

	CONSTRAINT fk_aircraft FOREIGN KEY (key_dim_aircraft) REFERENCES [dbo].['Dim Aircraft'](key_dim_aircraft),
	CONSTRAINT fk_date FOREIGN KEY (key_dim_date) REFERENCES [dbo].['Dim Date'](key_dim_date),
	CONSTRAINT fk_effect FOREIGN KEY (key_dim_effect) REFERENCES [dbo].['Dim Effect'](key_dim_effect),
	CONSTRAINT fk_location FOREIGN KEY (key_dim_location) REFERENCES [dbo].['Dim Location'](key_dim_location),
	CONSTRAINT fk_wildlife FOREIGN KEY (key_dim_wildlife) REFERENCES [dbo].['Dim Wildlife'](key_dim_wildlife)

) ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [bird strike] SET  READ_WRITE 
GO
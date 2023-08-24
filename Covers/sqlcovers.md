# SQLCovers
Imported until week 40


CREATE TABLE Teachers(idTeacher INTEGER PRIMARY KEY, FirstNameLastName TEXT NOT NULL UNIQUE);

CREATE TABLE tmpcover(
  "Date" TEXT,
  "Period" TEXT,
  "Class" TEXT,
  "Room" TEXT,
  "TeacherAskingCover" TEXT,
  "Subject" TEXT,
  "TeacherGivingCover" TEXT
);
CREATE TABLE Covers(
DateCover TEXT NOT NULL,
Period TEXT NOT NULL,
TeacherAskingCover TEXT NOT NULL,
TeacherGivingCover TEXT NOT NULL,
PRIMARY KEY (DateCover, Period, TeacherAskingCover)
);

# Check consistency of tmpcover before making the insert
select Date, TeacherAskingCover, Period, count(Period) as AA from tmpcover group by Date, TeacherAskingCover, Period having AA > 1 order by Date;

insert into Covers (DateCover, Period, TeacherAskingCover, TeacherGivingCover) select substr(Date, 7, 4) || "-" || substr(date, 4, 2) || "-" || substr(date, 1, 2) as DateCover, Period, TeacherAskingCover, TeacherGivingCover from tmpcover;

# Use the following two queries to make a comparative table
Select TeacherGivingCover, Count(TeacherGivingCover) As Hours from Covers Group By TeacherGivingCover Order By Count(TeacherGivingCover) Desc;

Select TeacherAskingCover, Count(TeacherAskingCover) As Hours from Covers Group By TeacherAskingCover Order By Count(TeacherAskingCover) Desc;

select DateCover, strftime( "%w", DateCover) from Covers;

select DateCover, strftime("%Y", DateCover) As YearCover, strftime("%m", DateCover) As MonthCover, strftime("%d", DateCover) As DayCover,
	IIF(strftime("%w", DateCover) = 1, "Monday", IIF(strftime("%w", DateCover) = 2, "Tuesday", IIF(strftime("%w", DateCover) = 3, "Wednesday", IIF(strftime("%w", DateCover) = 4, "Thursday", IIF(strftime("%w", DateCover) = 5, "Friday", IIF(strftime("%w", DateCover) == 6, "Saturday", "Sunday")))))) As DayOfWeekCover, Period, TeacherAskingCover, TeacherGivingCover,
From Covers
Order By DateCover, Period, TeacherAskingCover;

CREATE VIEW ViewCovers As
select DateCover, strftime("%Y", DateCover) As YearCover, strftime("%m", DateCover) As MonthCover, strftime("%d", DateCover) As DayCover,

	IIF(strftime("%w", DateCover) = "1", "Monday", IIF(strftime("%w", DateCover) = "2", "Tuesday", IIF(strftime("%w", DateCover) = "3", "Wednesday", IIF(strftime("%w", DateCover) = "4", "Thursday", IIF(strftime("%w", DateCover) = "5", "Friday", IIF(strftime("%w", DateCover) = "6", "Saturday", "Sunday")))))) As DayOfWeekCover, strftime("%W", DateCover) As WeekCover, Period, TeacherAskingCover, TeacherGivingCover

From Covers

Order By DateCover, Period, TeacherAskingCover;

Create View TopListFriday As 
Select TeacherAskingCover, Count(TeacherAskingCover) As Counter From (
Select DateCover, TeacherAskingCover from ViewCovers Where DayOfWeekCover = "Friday" Group By DateCover, TeacherAskingCover Order By TeacherAskingCover, DateCover)
Group By TeacherAskingCover Order By Count(TeacherAskingCover) desc;

Create View TopListMonday As 
Select TeacherAskingCover, Count(TeacherAskingCover) As Counter From (
Select DateCover, TeacherAskingCover from ViewCovers Where DayOfWeekCover = "Monday" Group By DateCover, TeacherAskingCover Order By TeacherAskingCover, DateCover)
Group By TeacherAskingCover Order By Count(TeacherAskingCover) desc;

CREATE VIEW CoversPerWeek As 
select YearCover, WeekCover, TeacherAskingCover, Count(TeacherAskingCover) As HourAskedPerWeek, round((Count(TeacherAskingCover)/35.0)*100,2) As PercentageNotWorked
From ViewCovers
Group By YearCover, WeekCover, TeacherAskingCover
Order By YearCover, WeekCover, Count(TeacherAskingCover) desc
/* CoversPerWeek(YearCover,WeekCover,TeacherAskingCover,HourAskedPerWeek,PercentageNotWorked) */;

CREATE VIEW CoversPerYear As 
select YearCover, TeacherAskingCover, Count(TeacherAskingCover) As HourAskedPerYear, round((Count(TeacherAskingCover)/35.0)*100,2) As PercentageNotWorked
From ViewCovers
Group By YearCover, TeacherAskingCover
Order By YearCover, Count(TeacherAskingCover) desc

CREATE VIEW CoversPerMonth As
select YearCover, MonthCover, TeacherAskingCover, Count(TeacherAskingCover) As HourAskedPerMonth, round((Count(TeacherAskingCover)/35.0)*100,2) As PercentageNotWorked
From ViewCovers
Group By YearCover, MonthCover, TeacherAskingCover
Order By YearCover, MonthCover, Count(TeacherAskingCover) desc
/* CoversPerMonth(YearCover,MonthCover,TeacherAskingCover,HourAskedPerMonth,PercentageNotWorked) */;

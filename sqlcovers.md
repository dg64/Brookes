# SQLCovers
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

insert into Covers (DateCover, Period, TeacherAskingCover, TeacherGivingCover) select substr(Date, 7, 4) || "-" || substr(date, 4, 2) || "-" || substr(date, 1, 2) as DateCover, Period, TeacherAskingCover, TeacherGivingCover from tmpcover;

Select TeacherGivingCover, Count(TeacherGivingCover) As Hours from Covers Group By TeacherGivingCover Order By Count(TeacherGivingCover) Desc;

Select TeacherAskingCover, Count(TeacherAskingCover) As Hours from Covers Group By TeacherAskingCover Order By Count(TeacherAskingCover) Desc;


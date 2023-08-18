create database HR_analytics;
use  HR_analytics;
create table HR_1(
Age int,
Attrition varchar (100),
BusinessTravel varchar(100),
DailyRate int,
Department varchar(100),
DistanceFromHome int,
Education int,
EducationField varchar(100),
EmployeeCount int,
EmployeeNumber int,
EnvironmentSatisfaction int,
Gender varchar(100),
HourlyRate int,
JobInvolvement int,
JobLevel int,
JobRole varchar(100),
JobSatisfaction int,
MaritalStatus varchar(100));

drop table HR_1;
select * from HR_1;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\HR_1.csv' into table HR_1 fields terminated by ','enclosed by'"'lines terminated by '\n'ignore 1 rows;

create table HR_2(
Employee_ID int,
YearofJoining int,
MonthofJoining int,
DayofJoining int,
MonthlyIncome int,
MonthlyRate int,
NumCompaniesWorked int,
Over18 varchar(10),
OverTime varchar (10),
PercentSalaryHike int,
PerformanceRating int,
RelationshipSatisfaction int,
StandardHours int,
StockOptionLevel int,
TotalWorkingYears int,
TrainingTimesLastYear int,
WorkLifeBalance int,
YearsAtCompany int,
YearsInCurrentRole int,
YearsSinceLastPromotion int,
YearsWithCurrManager int);

select * from HR_2;
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\HR_2.csv' into table HR_2 fields terminated by ','enclosed by'"'lines terminated by '\n'ignore 1 rows;

#date of joining
alter table HR_2 add column Date_of_joining date;
update HR_2 set Date_of_joining = concat(Yearofjoining,"-",Monthofjoining,"-",Dayofjoining);
set SQL_SAFE_UPDATES=0;

#Year 
alter table HR_2 add column year_ int;
update HR_2 set year_ = year(date_of_joining);

#Monthno_
alter table HR_2 add column Monthno_ int;
update HR_2 set Monthno_ = month(date_of_joining);

#Month_name
alter table HR_2 add column Month_name varchar(20);
update HR_2 set Month_name = monthname(date_of_joining);

#Quarter
alter table HR_2 add column Quarter_ int;
update HR_2
set Quarter_ = quarter(date_of_joining);

#Yearmonth
alter table HR_2 add column yearmonth varchar(20); 
update HR_2 set yearmonth =concat(year_,'-',month_name);

#Weekdayno
alter table HR_2 add column Weekdayno int;
update HR_2 set Weekdayno = weekday(date_of_joining);
 
 
#weekdayname
alter table HR_2 add column Weekdayname varchar(20);
update HR_2 set Weekdayname = dayname(date_of_joining);

select * from HR_2;

alter table HR_2 drop column weekdayname;

#Financial_month
alter table HR_2 add column Financial_month int;
update HR_2 set Financial_month = case when Monthno_>=4
	then Monthno_-3
    else Monthno_+9
end;


#Financial_Quarter
alter table HR_2 add column Financial_Quarter varchar(15); 
update HR_2 set Financial_Quarter = 
CASE WHEN QUARTER_=1 
	THEN CONCAT(YEAR_-1, '-Q',QUARTER_+3)
	ELSE concat(YEAR_,'-Q',QUARTER_-1) 
END;

alter table HR_2 drop column Financial_Quarter;

# Attrition_count
alter table HR_1 add column Attrition_count int;	
update HR_1 set Attrition_count =
case when attrition ='yes'
then 1 else 0
end;


#Attrition rate

select * from HR_1;
#Average Attrition rate for all Departments
select Department, AVG(ATTRITION_RATE)*100 as Avg_attrition_rate from HR_1 group by Department;

#2Average Hourly rate of Male Research Scientist
select gender,jobrole, avg(hourlyrate) from HR_1  group by gender,jobrole having gender = "male" and jobrole = "Research Scientist";

#3Attrition rate Vs Monthly income stats
select h1.department,avg(h1.attrition_rate)*100 as avg_attrition_rate,sum(h2.monthlyincome),avg(h2.monthlyincome)
from hR_1 h1 join HR_2 h2 on h1.employeenumber=h2.employee_id group by h1.department;

#Average working years for each Department
select h1.department, avg(h2.TotalWorkingYears) from HR_1 h1 join HR_2 h2 on h1.employeenumber = h2.employee_ID group by h1.department;

#5Departmentwsie no of employees
select department, sum(employeecount) as Total_employees from HR_1 group by Department;

#6Count of Employees based on Educational Fields
select educationfield, sum(employeecount) as Total_employees from HR_1 group by educationfield;

#7Job Role Vs Work life balance
select h1.Jobrole, sum(h2.Worklifebalance) from HR_1 h1 join HR_2 h2 on h1.employeenumber = h2.employee_ID group by h1.jobrole;

#8Attrition rate Vs Year since last promotion relation
select avg(H1.attrition_rate)*100 as Attrition_rate,h2.yearssincelastpromotion from HR_1 h1 join HR_2 h2 on h1.employeeNumber=h2.employee_ID group by h1.department;

#9Gender based Percentage of Employee
select gender, sum(employeecount)*100/(SELECT SUM(employeecount) FROM HR_1) as Percent_of_employee from HR_1 group by gender;

#10Monthly New Hire vs Attrition Trendline
select h2.Month_name,avg(H1.attrition_rate) as attrition_trendline,sum(h1.employeecount) as Monthly_new_Hire from HR_1 h1 join HR_2 h2 on H1.employeeNumber = h2.employee_ID group by h2.Month_name;

#11Deptarment / Job Role wise job satisfaction
select department, jobrole, sum(jobsatisfaction) from HR_1 group by department,Jobrole;
select * from HR_2;
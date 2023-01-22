
Select Top 5
Total, Men, Women, Major, ((Women/Total)*100) as PercentWomen
From dbo.college_majors$
Order By 5 desc
--Viewing Top 5 College Majors Categories with Highest Percentage of Women

Select Top 5
Total, Men, Women, Major, ((Men/Total)*100) as PercentMen
From dbo.college_majors$
Order By 5 desc
--Viewing Top 5 College Major Categories with Highest Percentage of Men

Select Top 5	
Total, Unemployment_Rate*100 as Unemployment_Rate_Percent, Major
From dbo.college_majors$
WHERE 
Unemployment_Rate >0.00001
Order By 2 desc
--Viewing Top 5 College Major Categories with Highest Unemployment

Select Top 5	
Total, Unemployment_Rate*100 as Unemployment_Rate_Percent, Major
From dbo.college_majors$
Order By 2 asc
--Viewing Top 5 College Major Categories with Lowest Unemployment
Select Top 5
Sum(Total) as Total,(Avg(Unemployment_Rate)*100) as UnemploymentRate,Sum(Men)as Men,Sum(Women) as Women, Major_category, (Avg(Women/Total)*100) as PercentWomen, (Avg(Men/Total)*100) as PercentMen
From dbo.college_majors$
Group By Major_category
Order By 2 desc
--Viewing Top 5 College Majors Categories by Unemployment Rate and Percentage of Men and Women

Select Top 5
Sum(Total)TotalInMajor, Avg(Unemployment_Rate*100)AvgUnemploymentRate,Major_Category
From dbo.college_majors$
Group By Major_category
Order by 2 desc
--Viewing Top 5 College Major Categories with Highest Average Unemployment Rate
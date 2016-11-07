-- SOURCE TABLE

|ROLE           |DEPT  	|SAL |
|---------------|-------|----| 
|Analyst        |30     |5500|
|Developer      |20     |2570|
|Analyst        |20     |5000|
|Project Manager|30     |5500|
|Tester         |30     |1850|
|Developer      |10     |2500|
|Tech-Lead      |20     |3000|
|Tester         |10     |1750|
|Developer      |30     |2550|
|Tech-Lead      |10     |3500|
|Tester         |20     |1500|

-- OUTPUT REQUIRED

|ROLE           |DEPT_10|DEPT_20|DEPT_30|TOTSAL|
|---------------|-------|-------|-------|------|
|Analyst        |       |5000   |5500   |10500 |
|Developer      |2500   |2570   |2550   |7620  |
|Project Manager|       |       |5500   |5500  |
|Tester         |1750   |1500   |1850   |5100  |
|Tech-Lead      |3500   |3000   |       |6500  |
|               |7750   |12070  |15400  |35220 |



--------------------------------------------------------
--  DDL for Table ROLES
--------------------------------------------------------

  CREATE TABLE ROLES
   (	ROLE VARCHAR2(20 BYTE), 
	DEPT VARCHAR2(20 BYTE), 
	SAL VARCHAR2(20 BYTE)
   );

--------------------------------------------------------
--  DML for Table ROLES
--------------------------------------------------------

Insert into ROLES (ROLE,DEPT,SAL) values ('Developer','20','2570');
Insert into ROLES (ROLE,DEPT,SAL) values ('Analyst','30','5500');
Insert into ROLES (ROLE,DEPT,SAL) values ('Project Mangaer','30','5500');
Insert into ROLES (ROLE,DEPT,SAL) values ('Tester','10','1750');
Insert into ROLES (ROLE,DEPT,SAL) values ('Tech-Lead','10','3500');
Insert into ROLES (ROLE,DEPT,SAL) values ('Developer','10','2500');
Insert into ROLES (ROLE,DEPT,SAL) values ('Analyst','20','5000');
Insert into ROLES (ROLE,DEPT,SAL) values ('Tech-Lead','10','3500');
Insert into ROLES (ROLE,DEPT,SAL) values ('Tester','30','1850');
Insert into ROLES (ROLE,DEPT,SAL) values ('Developer','30','2550');
INSERT INTO ROLES (ROLE,DEPT,SAL) VALUES ('Tester','20','1500');

--------------------------------------------------------
If you have used excel then you would be knowing how to get the desired result in the spreadsheet. But here we are looking solutions in SQL(Oracle). 

SPOILER ALERT: Give a try if you can solve it yourself before looking into the solution.
--------------------------------------------------------


To achive horizontal TOTAL SAL as below outuput we can go with With As in SQL

|ROLE           |DEPT_10|DEPT_20|DEPT_30|TOTSAL|
|---------------|-------|-------|-------|------|
|Analyst        |       |5000   |5500   |10500 |
|Developer      |2500   |2570   |2550   |7620  |
|Project Manager|       |       |5500   |5500  |
|Tester         |1750   |1500   |1850   |5100  |
|Tech-Lead      |3500   |3000   |       |6500  |



WITH RLSAL AS
  ( SELECT ROLE RL,SUM(SAL) TOTSAL FROM ROLES GROUP BY ROLE
  ) ,
  RLPIV AS
  (SELECT *
  FROM
    ( SELECT ROLE,DEPT,SAL FROM ROLES
    ) PIVOT ( MAX(SAL) FOR DEPT IN ('10' AS DEPT_10,'20' AS DEPT_20,'30' AS DEPT_30) )
  )
SELECT ROLE,
  DEPT_10,
  DEPT_20,
  DEPT_30,
  TOTSAL
FROM RLPIV,
  RLSAL
WHERE ROLE=RL
ORDER BY ROLE;

--------------------------------------------------------
--------------------------------------------------------

To achive both Horizontal and Veritical subtotals we can use Cube extension to Group by.

select DEPT, ROLE, sum(sal) sal
FROM ROLES
group by cube(DEPT, ROLE);

Outpur of above SQL. 

|DEPT 	|ROLE		      	|SAL  	|
|-------|---------------	|-------|
|	|       		|35720	|
|	|TESTER		    	|5100 	|
|	|ANALYST	    	|10500	|
|	|DEVELOPER	  	|7620 	|
|	|TECH-LEAD	  	|7000	|
|	|PROJECT MANGAER	|5500	|
|10	|     			|7750	|
|10	|TESTER	    		|1750	|
|10	|DEVELOPER	  	|2500	|
|10	|TECH-LEAD		|3500	|
|20	|			|12570	|
|20	|TESTER			|1500	|
|20	|ANALYST		|5000	|
|20	|DEVELOPER		|2570	|
|20	|TECH-LEAD		|3500	|
|30	|			|15400	|
|30	|TESTER		    	|1850	|
|30	|ANALYST		|5500	|
|30	|DEVELOPER	   	|2550	|
|30	|PROJECT MANGAER	|5500	|


-- Achiveing Vertical and Horizontal with cube and Pivot

select * from (  
  SELECT NVL(DEPT, 1) DEPT, ROLE, SUM(SAL) SAL  
  from ROLES  
  group by cube(DEPT, ROLE)  
)  
pivot(  
  sum(sal) for DEPT in (10, 20, 30, 1 as TOTAL)  
)  
order by ROLE; 


---
title: "Data Manipulation using SQL for Beginners"
---

## Author: _Michael Zargari_

<center><img src="./Images/SQL_Header.webp" alt="Img"></center>


---------------------------

<b> <font size="+2"> Tutorial Aims: </font> </b> 

#### 1. Become familiar with data manupulation in SQL.
#### 2. Create new columns and tables by combining two datasets.
#### 3. Learn to find averages, sums, minimums, maximums, and counts.
#### 4. Appreciate the versatility and user friendly nature of SQL.
#### 5. Filter, order, and organize your data to look and find specific trends.
#### 6. Build beautiful graphs to uncover patterns in data.

<br>

<b> <font size="+2"> Tutorial Steps: </font> </b>

#### <a href="#1"> 1. Introduction</a>

#### <a href="#2"> 2. Beginning your SQL Journey</a> 

#### <a href="#3"> 3. Getting set up on Mode</a>

#### <a href="#4"> 4. Extracting columns: SELECT and FROM</a> 
##### a. Naming output columns: AS
##### b. Unique values: DISTINCT
##### c. Commenting

#### <a href="#5"> 5. Filtering columns: WHERE</a> 
##### a. AND
##### b. OR
##### c. Logical operators (>, =, <)
##### d. LIKE

#### <a href="#6"> 6. Mathematical Concepts and Aggregate Functions</a> 
##### a. COUNT
##### b. MAX/MIN
##### c. SUM
##### d. AVG

#### <a href="#7"> 7. Grouping: GROUP BY</a> 
##### a. GROUP BY for Aggregate Functions

#### <a href="#8"> 8. Organizing tables: ORDER BY</a> 
##### a. ASC
##### b. DESC
##### c. Combining ASC and DESC

#### <a href="#9"> 9. Quick analysis: LIMIT</a> 

#### <a href="#10"> 10. Combining data: JOINS</a> 
##### a. INNER JOIN
##### b. LEFT JOIN
##### c. RIGHT JOIN
##### d. FULL OUTER JOIN

#### <a href="#11"> 11. Tieing it all together: Examples and Creating Graphs</a> 

#### <a href="#12"> 12. Congrats on making it to the end!</a> 

<br>
 
# Let's get started!

<a name="1"></a>

## 1. Introduction

Congrats on taking your first step to learning SQL! You may have some prior experience with data manipulation in various coding languages, using pipes (%>%) in R, or you may even be a new coder altogether, however, this tutorial will help the most eager of you learn the basics of data manipulation. The goal of this tutorial is to introduce you to SQL as a coding language and expand on your data manipulation knowledge.

SQL is very user friendly and easy to understand since the code reads like a sentence. There is no need to load packages and when you code in Mode, you do not need to download any additional software and you are able to make visualizations in a snap! 

Throughout this tutorial we will go through basic SQL syntax step by step which will help you understand data manipulation. Throughout this tutorial, we will delve deeper into higher level data manipulation using mathematical functions and learning more about joining data sets. This tutorial should take about two hours, but will vary on your prior coding expertise within SQL and other languages. This tutorial aims to consolidate all introductory SQL knowledge into one easy place that you are able to follow and learn.

To set the scenario: Let's imagine that you just came back from a West Coast Tour of the United States. You visited California, Oregon, and Washington. Each state you visited, you went hiking (because which data analyst doesn't love hiking, right) and exploring. You decided to survey the different trees in the areas that you visited. You gave each of them an id number and after asking local officials, you were able to get the trees' girth, height, volume, and age. However, since it took longer for the national rangers to give you the age of the trees, you decided to make a separate data table containing the age and terrain of where the trees were located. You are now back in your beautiful home and are trying to consolidate your data. Let's begin!

---------------------------
##### There is no need to download any additional files for this tutorial. If you would like to look at the raw data, you can get all of the resources for this tutorial from <a href="https://github.com/EdDataScienceEES/tutorial-mzargari" target="_blank">this GitHub repository</a>. Clone and download the repo as a zip file, then unzip it, however it is not required in order to move forward.

<br>

<a name="2"></a>

## 2. Beginning your SQL Journey

<br>

<center><img src="./Images/Journey.jpg" alt="Img"></center>

Credit: www.medium.com

<br>

SQL is a standard language for accessing and manipulating databases. SQL stands for Structured Query Language and became a standard of the American National Standards Institute (ANSI) in 1986, and of the International Organization for Standardization (ISO) in 1987.

__What is a database?__

- A database is a location where all data files are located and stored. You "query" from this database in order to get your data.

__What is a query?__

- A query is a "pull" or "request" on a database for data/information from a table or combination of tables located within the database.

To state it simply, SQL can retrieve data from a database, insert, update, and delete records, create new databases, and create new tables in a database.

To add onto the user friendly nature of SQL, keywords within SQL are NOT case sensitive: ```select``` is the same as ```SELECT```, however, it is common practice to write all SQL keywords in upper-case.

<br>

<a name="3"></a>

## 3. Getting set up on Mode

#### 1. Go to the <a href="www.Mode.com" target="_blank">Mode website</a>.
#### 2. Make a free account by clicking "Sign up."
#### 3. Verify your email, set your username, and password.
#### 4. Click "Create a new workspace" under the "I want to try Mode for free" tab.
#### 5. At the bottom of the next page, click "I want to learn on a limited version of Mode with public, community data."

<br>

<center><img src="./Images/Mode_Account_Creation.png" alt="Img"></center>

<br>

That's it! You are now ready to code in SQL!
In this tutorial, all data is self contained within Mode so there is no need to upload any data. Higher level database creation, uploading, and linking will be discussed in subsequent tutorials.

If at any point you may have lost your work or would like to revert to a previous version of your query, you may click "View History" to see your code at every stage whenever you have clicked "Run."

__Remember__: You may only run one query per page at a time. For each additional query, select the "+" box on the center left of the screen to save your work as is and start a new query. This is used when you are running multiple queries and you want to test out a new query without erasing what you already have. Think of this as opening a new tab while you are browsing the web. You can only be on one website at a time, but you can always switch tabs to come back to that website/query.

<br>

<center><img src="./Images/Query_Window.png" alt="Img"></center>

<br>

Likewise, coding etiquette for this tutorial dictates as follows:

1. Each new function be on a new line (i.e. SELECT, WHERE, FROM, etc).

2. There be distance between a function and an open parenthesis: _FUNCTION_ ( _columnName_ ).

3. Functions be written in all capital letters.

4. Each column name be on a new line in your `SELECT` statement. Commas may be placed on the line prior or the line of. This is up to personal preference and I will be using both for this tutorial.

_Note_: You may click "Format SQL" in the top menu bar in Mode and the site will automatically organize your code (Mode is a very helpful program!)

##### ___Let's get started!___

<br>

<a name="4"></a>

## 4. Extracting columns: SELECT and FROM

- __Syntax__: SELECT _columnName1_, _columnName2_, _etc_ FROM _tableName_

In SQL, the SELECT and FROM functions are the most fundamental pieces of a query. Without these two selections, the query cannot exist.

In this tutorial, we will be using the trees.csv dataset, however this is already loaded into Mode. Simply go to the right hand corner and type in ```thisisatestaccount.trees```. Click on this file and Mode will generate the code for it in your coding window. 

<br>

<center><img src="./Images/Getting_Mode_Data.png" alt="Img"></center>

<br>

Once you click on the table, you should get the following code. If not you may also type it manually:
``` 
SELECT *
FROM
  thisisatestaccount.trees
```

This is the most simple code you may have in SQL.

- In SQL code, ```*``` means "all."

In this basic query, the code is saying "Select all columns from the trees data."

From our query output, we can see that this is a very basic data set consisting of 31 rows/data points with columns titled "id," "girth_in," "height_ft," "volume_ft_3," and "state."

If we would like to only output certain columns, we can simply list those column names to get their rows. When typing column names, they are not case sensitive so ```state``` and ```STaTe``` will be read the same way by SQL, however, the output column will follow the original column name that is in the data (in this case `state`), unless overrid by an ```AS``` function (explained next).

```
SELECT
  id
  ,state
  ,height_ft
FROM
  thisisatestaccount.trees
```

Here, we can see the output is made up of 31 rows and only the columns we listed are show in the order we listed.

### a. Naming output columns: AS

- __Syntax__: SELECT _columnName_ AS _newColumnName_ FROM _tableName_

Now let's add a more descriptive column name using ```AS```:

```
SELECT
  state
  ,height_ft as height
  ,girth_in as girth
  ,volume_ft_3 as volume
FROM
  thisisatestaccount.trees
```
Here we can see how easy it is to change output column names.

<a name="DISTINCT"></a>

### b. Unique values: DISTINCT
We know how many rows we have. Now what if we would like to know what different levels of data we are working with? For example, below we can find all the states that we have taken tree measurements from:

- __Syntax__: SELECT DISTINCT( _columnName_ ) FROM _tableName_

```
SELECT
  DISTINCT(state)
FROM
  thisisatestaccount.trees
```

Our output tells us that the data spans Oregan (OR), Washington (WA), and California (CA).
It's as simple as that!

### c. Commenting

As always, remember to comment your code by using ```--```. If you add `--` before any word, it comments out everything that comes to the right of it.

```
-- This code finds the number of rows in our data
-- This is also a comment
SELECT
  *
FROM
  thisisatestaccount.trees
```

If we would like to comment out an entire section of code, we would use ```/*``` and to signify the end of the comment chunk we would close it using ```*/```:

```
*/This code finds the number of rows in our data
This is also a comment */
SELECT
  *
FROM
  thisisatestaccount.trees
```

Simple, right? Let's move on.

<a name="5"></a>

<br>

## 5. Filtering columns: WHERE

- __Syntax__: SELECT _columnName_ FROM _tableName_ WHERE _condition(s)_

_(At this point, I would recommend clicking the "+" sign in the center left hand part of the screen to start a new query)_

Now, let's say you would like to filter down your data even more. The ```WHERE``` function let's us find specific rows in our data.

Let's try to find all the tree data that we have for California:

```
-- This code finds the rows of tree data collected in California
SELECT
  *
FROM
  thisisatestaccount.trees
WHERE state = 'CA'
```

Here, we can see the output shows us all the rows where California is listed as the state.

_It is very important to note that when trying to find exact matches, you need to use single quotes ```' '``` rather than double quotes ```" "```._

What goes in between these quotes ___is___ case sensitive.

The ```WHERE``` function has many uses which will be discussed further in this tutorial.

<br>

<center><img src="./Images/And_Or_Not.png" alt="Img"></center>

<br>

### a. AND

- __Syntax__: SELECT _columnName_ FROM _tableName_ WHERE _column1_ = _value1_ AND _column2_ = _value2_

We are also able to combine conditions on our ```WHERE``` clause for an even more in depth analysis. Let's find all the trees that are in California and and have a height of 76 feet:

```
-- This code finds the rows of tree data where the tree is a 76 foot tall California tree
SELECT
  *
FROM
  thisisatestaccount.trees
WHERE state = 'CA' AND height_ft = 76
```
Wow look at that! We have two samples from very similar looking trees. All data matches except tree ID 13 has a bigger volume.

### b. OR

- __Syntax__: SELECT _columnName_ FROM _tableName_ WHERE _column1_ = _value1_ OR _column2_ = _value2_

The ```OR``` clause lets you find matches when only one or both statements hold true. Let's find all the trees that are in California or Oregon:

```
-- This code finds rows of tree data collected in California or Oregon
SELECT
  *
FROM
  thisisatestaccount.trees
WHERE state = 'CA' OR state = 'OR'
```
Well, that's impressive. It was that simple to find all those values? That is magic of SQL!

### c. Logical operators (>, =, <, !=)

<br>

<center><img src="./Images/Logical_Operators.png" alt="Img"></center>

<br>

Logical operators are also very important, especially when working with numbers.

For example, we can simplify our code above by querying our data to not output rows with Washington as their state. Since we know that there are only 3 states, we can exclude Washington and get the same result:

```
-- This code finds rows of tree data collected in California or Oregon
SELECT
  *
FROM
  thisisatestaccount.trees
WHERE state != 'WA'
```

Likewise, let's find all data where the tree has a height greater than 50 and a girth less than or equal to 16.5. I'll say, these are some big trees!

```
-- This code finds rows of tree data where height greater than 50 and a girth less than or equal to 16.5
SELECT
  *
FROM
  thisisatestaccount.trees
WHERE height_ft > 50 AND girth_in <= 16.5
```

That was quick!

### d. LIKE

The ```LIKE``` operator is a very powerful operation when paired with ```WHERE```. With this function, we are able to truly rule out our data and find what we are looking for. This function is great for when you have data that is listed as multiple names (such as salmon_eggs, salmon_eggs_count, num_of_salmon_eggs, etc.). When we have such cases, we may use our ```LIKE``` function to query them all so we can run our analyses. Below, you can see a table that shows all the functionalities of ```LIKE```.

<center><img src="./Images/Like_Operator_Table.png" alt="Img"></center>

credit: www.w3schools.com

<br>

In our case, we have a very simple data set so powerful operators like this would come in handy with bigger and longer data. However, we may still use ```LIKE``` to query our data. Let's use ```LIKE``` to find all state abbreviations that end with A. This output will give us all values with California and Washington as their state:

```
-- This query will find all fields that have a state ending in "A"
SELECT
*
FROM
  thisisatestaccount.trees
WHERE state LIKE '%A'
```

__Note__: ```LIKE``` only works on character fields and will not work on numeric data. Additionally, whatever you put in ```''``` is case sensitive.

<br>

<a name="6"></a>

## 6. Mathematical concepts and Aggregate Functions

<br>

<center><img src="./Images/Math.jpg" alt="Img"></center>

Credit: www.stock.adobe.com

<br>

- __Syntax__: SELECT _FUNCTION_ ( _columnName_ ) FROM _tableName_ [WHERE _condition_]
- The functions in [ ] denote optional functions that may follow in the syntax.
- Aggregate functions include: COUNT(), MAX(), MIN(), SUM(), and AVG()

SQL takes advantage of many aggregate functions which we will explore below.

### a. COUNT

With larger data sets, it is harder to gauge how many rows of data exist. For his reason, we use ```COUNT``` to count the number of rows in our selected query.

With the following code, we can get the number of rows that we have in our data set:

_Note that you need parenthesis to show what you are applying the function to_

```
-- This query counts the number of rows in our data
SELECT
  COUNT(*)
FROM
  thisisatestaccount.trees
```

### b. MAX/MIN

The maximum (`MAX`) and minimum (`min`) functions in SQL find the max and min of your specified column.

```
-- This code selects the maximum volume value and the minimum girth value in the data
SELECT
 MAX (volume_ft_3) as maximum_volume,
 MIN (girth_in) as minimum_girth
FROM
  thisisatestaccount.trees
```

Now let's see the max and min values for only Washington trees:

```
/* This code selects the maximum tree volume value and the 
minimum tree girth value in the data for trees found in Washington */
SELECT
 MAX (volume_ft_3) as maximum_volume,
 MIN (girth_in) as minimum_girth
FROM
  thisisatestaccount.trees
WHERE state = 'WA'
```

Note the difference? It's as simple as that. 

<br>

<center><img src="./Images/Agg_Funcs.png" alt="Img"></center>

Credit: www.javatpoint.com

<br>

### c. SUM

From my experience, such a basic mathematical function like ```SUM``` is used the most in higher level data analysis. In later tutorials, you may learn about ```SUM (CASE WHEN ...)``` functions which are powerful nested ```SUM``` operations, however, for now we will learn how to take a simple sum of a column.

```
-- Finds the sum of all of our numeric data
SELECT
SUM(girth_in) as sum_girth
,SUM(height_ft) as sum_height
,SUM(volume_ft_3) as sum_volume
FROM
  thisisatestaccount.trees
```

### d. AVG

The ```AVG``` function takes averages. Very straight forward. This operation can be used in many contexts but below we can use ```AVG``` to find the mean of all of our numeric columns:

```
-- Finds averages of all of our numeric data
SELECT
AVG(girth_in) as average_girth
,AVG(height_ft) as average_height
,AVG(volume_ft_3) as average_volume
FROM
  thisisatestaccount.trees
```

Isn't that so cool and simple?! Next, we will learn about ```GROUP BY``` which is used extensively when running aggregate functions on the data as we will see in the next section.

<br>

<a name="7"></a>

## 7. Grouping: GROUP BY

- __Syntax__: SELECT * FROM _table1_ [WHERE _condition_] GROUP BY _columnName_ [ORDER BY _columnName_]
- The functions in [ ] denote optional functions

The GROUP BY statement groups rows that have the same values into summary rows.

For example, if we wanted to find all of the unique values for a given column (just like we did when using <a href="#DISTINCT"> DISTINCT</a>), we can use the following code:

```
-- Finds the levels of data we have in the state column
SELECT
  state
FROM
  thisisatestaccount.trees
GROUP BY state
```

<br>

### a. GROUP BY for Aggregate Functions

The GROUP BY statement is often used with aggregate functions. In these cases, it is necessary to have a ```GROUP BY``` clause since we are attempting to summarize our data. For example, if we wanted to find the number of trees that have the same height in each state, we could run this simple query:

```
/* This code selects the state and heights for the trees and outputs 
the number of trees that had the same height in that state */
SELECT
  state,
  height_ft,
  count(height_ft) as num_same_height
FROM
  thisisatestaccount.trees
GROUP BY state, height_ft
```

Here, we used a ```GROUP BY``` clause since we are counting the number of heights that are the same per state so we need to combine all the rows that have the same height before we are able to count how many we combined.

```GROUP BY``` lets you take advantage of the aggregate functions to a greater extent. Another great example is to use ```GROUP BY``` to see trends in your data. Below we will compare tree girth, height, and volume averages across state lines:

<br>

<center><img src="./Images/Group_By.jpg" alt="Img"></center>

Credit: www.learnsql.com

<br>

```
-- Finds the averages for tree girth, height, and volume across all 3 states
SELECT
state
,AVG(girth_in) as average_girth
,AVG(height_ft) as average_height
,AVG(volume_ft_3) as average_volume
FROM
  thisisatestaccount.trees
GROUP BY state
```

We got that table in a pinch! We are almost done with the basics! Only one more core function left in our syntax!

<br>

<a name="8"></a>

## 8. Organizing tables: ORDER BY

- __Syntax:__ SELECT * FROM _table1_ [WHERE _condition_] [GROUP BY _columnName_] ORDER BY _columnName_ ASC/DESC
- The functions in [ ] denote optional functions

Next up in SQL syntax is the ```ORDER BY``` clause. ORDER BY lets you select one or more columns to have your data be organized by. This function works very well with both numbers and string whenever you want to list your results from greatest to lowest and vice versa or even in alphabetical order!

<br>

<center><img src="./Images/Asc_Desc.png" alt="Img"></center>

<br>

### a. ASC

SQL sorts data "ascending" by default within an ORDER BY clause, however, it is always good practice to type out your work and intention when manipulating data in SQL.

- ASC stands for Ascending which means starting from the smallest value and going up to the highest. This is a sorting feature from smallest to largest number or starting from "a" and going to "z," alphabetically speaking.

Let's open a new query and simply output all of our data, but have it sort by tree girth.

```
-- This code takes all of our data and lists it from smallest to largest girth value
SELECT
  *
FROM
  thisisatestaccount.trees
ORDER BY girth_in 
```

```
-- This code takes all of our data and lists it from smallest to largest girth value 
SELECT
  *
FROM
  thisisatestaccount.trees
ORDER BY girth_in ASC
```

Here we can see that both codes output the same result.

### b. DESC

- DESC stands for Descending which means starting from the largest value and going down to the smallest. This means that our data will be sorted from largest to smallest. If sorting alphabetically, SQL will start from "z" and go down to "a."

If you would like to sort in this way, you most definitely need to use the ```DESC``` specification after your column name since it is going against `ORDER BY`'s default mode (`ASC`). Let's order our data's states in reverse alphabetical order.

```
-- This code takes all of our data and lists it by state value going in reverse alphabetical order 
SELECT
  *
FROM
  thisisatestaccount.trees
ORDER BY state DESC
```

### c. Combining ASC and DESC

Now let's say we want to sort by more than one column. In this case, SQL orders by the first column you type and if there are duplicate values in the first column, it moves over to the second column you listed and sorts by that. This is best laid out in an example. 

```
/* This code takes all of our data and lists it from largest to smallest height value and when it encounters a 
duplicate height value, it sorts by the lowest volume value first. */
SELECT
  *
FROM
  thisisatestaccount.trees
ORDER BY height_ft DESC, volume_ft_3 ASC
```

Here we can look directly at id numbers 9, 22, 30, 29, and 28 since they all share the same height value, however, their volume is what dictates which one was sorted first in the list.

That's it! We are done with the main syntax of SQL. Now to delve in a bit deeper into higher level functions you may encounter when manipulating data.

Wasn't that simple? SQL code is like reading a book!

<br>

<center><img src="./Images/Book_Reading.jpg" alt="Img"></center>

<br>

<a name="9"></a>

## 9. Quick analysis: LIMIT

- __Syntax__: SELECT * FROM _table1_ [WHERE _condition_] [GROUP BY _columnName_] [ORDER BY _columnName_] LIMIT _X_

- The functions in [ ] denote optional functions

Lastly, the LIMIT function is a great tool when dealing with very large data sets. It is an amazing function to use to output your data quickly when you are regularly dealing with thousands of lines of code. With this function, SQL performs the query but outputs only the first X number entries that you indicate. By default, Mode limits the query output to 100 entries, but we can undo this by unchecking the "Limit 100" box. We only have 31 rows of data anyway, so this will not effect us now, but we may need to uncheck this box later when dealing with larger data sets.

For now, we can use the ```LIMIT``` function to output the top 10 tallest trees:

```
-- Outputs top 10 tallest trees across all states
SELECT
  girth_in
  ,height_ft
  ,volume_ft_3
  ,state
FROM
  thisisatestaccount.trees
ORDER BY height_ft DESC
LIMIT 10
```

Woah! Those are some tall trees. Now onto my favorite function: JOIN

<br>

<center><img src="./Images/Tree.jpg" alt="Img"></center>

Credit: www.smithsonianmag.com

<br>

<a name="10"></a>

## 10. Combining data: JOINS

Joining data unlocks a whole new world into the data manipulation world. When we have data that shares information, ```JOIN``` allows us to combine them into one consolidated sheet where we may go forward with our data manipulation. Even if the data does not match, we can combine columns from two data sets to find if we are missing any information. The applications with JOIN are endless!

For this next section, lets inspect another sample data set: "trees2.csv." Once again, we will simply type in ```thisisatestaccount.trees2``` in the search bar on the right hand side and we will be able to quickly query our new data set.

You may also do this manually by typing:

```
-- Returns all rows from thisisatestaccount.trees2
SELECT
  *
FROM
  thisisatestaccount.trees2
```

We can see here that this data set has the same ID column as our previous data set. Let's combine them! 

<center><img src="./Images/Joins.png" alt="Img"></center>

Credit: www.w3schools.com

<br>

### a. INNER JOIN

```INNER JOIN``` combines all of our data that are matching in both tables. This is helpful when we would like to only combine columns and rows that have a 100% match.

- _Syntax_: SELECT column_name FROM table_1 INNER JOIN table_2 ON table_1.column_name = table_2.column_name [WHERE _condition_] [GROUP BY _columnName_] [ORDER BY _columnName_]

- The functions in [ ] denote optional functions

Below, I have outlined four examples. 

The first two examples are the correct way to combine these two data sets. Since the ID numbers match 1 to 1, then we can add the two additional columns from "trees2" to the data set "trees" and have all the information line up. These first two examples also show that there is no difference between typing ```INNER JOIN``` or just ```JOIN```, however, I would recommend typing ```INNER JOIN``` since it can be a bit clearer to read, especially if the query has other join types (i.e. `LEFT` or `RIGHT` or `FULL OUTER`) included in it.

We can see this in the example below:

```
/* This query combines the trees and trees2 datasets by their ID numbers and matches 
their rows based on this parameter */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  JOIN thisisatestaccount.trees2 ON trees.id = trees2.id
```

```
/* This query combines the trees and trees2 datasets by their ID numbers and matches 
their rows based on this parameter */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  INNER JOIN thisisatestaccount.trees2 ON trees.id = trees2.id
```

In these next two examples, I have purposefully tried to combine two columns that I know will not match. In this case, ID and terrain. These examples will show that when using `INNER JOIN` or `JOIN`, if there is no match, then nothing will be outputted.

```
/* This query attempts to combine the trees and trees2 datasets by their ID numbers and terrain to match
their rows based on these parameter, however, it fails as expected */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  INNER JOIN thisisatestaccount.trees2 ON trees.id = trees2.terrain
```

```
/* This query attempts to combine the trees and trees2 datasets by their ID numbers and terrain to match
their rows based on these parameter, however, it fails as expected */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  JOIN thisisatestaccount.trees2 ON trees.id = trees2.terrain
```

Since we are using a simple data set, using any of the following JOINs to match id numbers will result in the same outcome. This is because when you have a 1:1 match ratio for columns and rows, all JOINs will yield the same output. However, I have intentionally used the same incorrect match as above to exemplify how these joins work.


### b. LEFT JOIN

- _Syntax_: SELECT column_name(s) FROM table_1 LEFT JOIN table_2 ON table_1.column_name = table_2.column_name [WHERE _condition_] [GROUP BY _columnName_] [ORDER BY _columnName_]

- The functions in [ ] denote optional functions

The `LEFT JOIN` function combines rows from different tables even if the join condition is not met. Every row in the left table (first table listed - table_1) is returned in the result set, and if the join condition is not met, then NULL values are filled in the columns from the right table (the second table listed - table_2).

This is similar to saying: “Return all the data from table_1 no matter what. If there are any matches with table_2, provide that information as well, but if not, just fill the missing data with NULL values.”

`LEFT JOIN` is less strict than `INNER JOIN` where the results of a `LEFT JOIN` will actually include all results that an `INNER JOIN` would have provided for the same given condition. Sort of like "a `LEFT JOIN` is an `INNER JOIN` but an `INNER JOIN` is not a `LEFT JOIN`."

```
/* This query attempts to combine the trees and trees2 datasets by their ID numbers and terrain to match
their rows based on these parameter, however, it fails as expected */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  LEFT JOIN thisisatestaccount.trees2 ON trees.id = trees2.terrain
```

The output of the code above will result in rows from "trees" along with rows which satisfies the condition from "trees2" be combined and outputted. However, since we do not have a match, we can see that the columns that we selected from our "trees" dataset are outputted, but the columns that we selected from our "trees2" dataset show up as NULL values.

### c. RIGHT JOIN

- _Syntax_: SELECT column_name(s) FROM table_1 RIGHT JOIN table_2 ON table_1.column_name = table_2.column_name [WHERE _condition_] [GROUP BY _columnName_] [ORDER BY _columnName_]

- The functions in [ ] denote optional functions

Similarly, the `RIGHT JOIN` function combines rows from different tables even if the join condition is not met. Every row in the right table (second table listed - table_2) is returned in the result set, and if the join condition is not met, then NULL values are filled in the columns from the left table (the first table listed - table_1).

This is similar to saying: “Return all the data from the table_2 no matter what. If there are any matches with the table_1, provide that information as well, but if not, just fill the missing data with NULL values.”

`RIGHT JOIN` is also less strict than `INNER JOIN` where the results of a `RIGHT JOIN` will include all results that an `INNER JOIN` would have provided for the same given condition. Sort of like "a `RIGHT JOIN` is an `INNER JOIN` but an `INNER JOIN` is not a `RIGHT JOIN`."

```
/* This query attempts to combine the trees and trees2 datasets by their ID numbers and terrain to match
their rows based on these parameter, however, it fails as expected */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  RIGHT JOIN thisisatestaccount.trees2 ON trees.id = trees2.terrain
```

The output of the code above will result in rows from "trees2" along with rows which satisfies the condition from "trees" be combined and outputted. However, since we do not have a match, we can see that the columns that we selected from our "trees2" dataset are outputted, but the columns that we selected from our "trees" dataset show up as NULL values.

### d. FULL OUTER JOIN

- _Syntax_: SELECT column_name(s) FROM table_1 FULL OUTER JOIN table_2 ON table_1.column_name = table_2.column_name [WHERE _condition_] [GROUP BY _columnName_] [ORDER BY _columnName_]

- The functions in [ ] denote optional functions

- FULL OUTER JOIN and FULL JOIN are the same.

`FULL OUTER JOIN` returns all records regardless of if there is a match in the first/left table (table_1) or second/right table (table_2) table records. If there are matches, it combines them. So, if there are rows in "table_1" that do not have matches in "table_2", or if there are rows in "table_2" that do not have matches in "table_1", those rows will be listed as well.

This is similar to saying: “Return all the data from table_1 and table_2 no matter what. If there are any matches between the tables, then combine them, if not, just fill the missing data with NULL values.”

`FULL OUTER JOIN` is also less strict than `INNER JOIN` where the results of a `FULL OUTER JOIN` will include all results that an `INNER JOIN` would have provided for the same given condition. Sort of like "a `FULL OUTER JOIN` is an `INNER JOIN` but an `INNER JOIN` is not a `FULL OUTER JOIN`"

```
/* This query attempts to combine the trees and trees2 datasets by their ID numbers and terrain to match
their rows based on these parameter, however, it fails as expected */
SELECT
trees.id
,trees.state
,trees2.age_years
,trees2.terrain
FROM
  thisisatestaccount.trees
  FULL OUTER JOIN thisisatestaccount.trees2 ON trees.id = trees2.terrain
```

Hmm we get 62 values rather than the usual 31 that is in our data set, but look at how many null values we have. `FULL OUTER JOIN` is powerful, but may return a large number of results if you are not careful. In our example above both datasets were combined, however, since they did not have any matching values, they were glued together to form this dataset that is twice the size and filled with NULL values.

<br>

<a name="11"></a>

## 11. Tieing it all together: Examples and Creating Graphs

You are now done with all the basics! Give yourself a pat on the back. Now we will try a few examples to test out what you have learned. We will move to using a larger data set so we can have a better feel for how the functions work. For a more thorough learning experience, try working in SQL yourself to try and answer the questions before looking at the code below it.

First, let's load the pollution1 file from `thisisatestaccount.pollution1`

```
-- Returns all rows from the pollution1 data set
SELECT
  *
FROM
  thisisatestaccount.pollution1
```

Wow, 5707 rows!

We can see that the data is broken up by region, industry_sector, industry_category, gas, units, magnitude, and amount. Let's find the top 5 regions that have been polluting the most per industry (on average) using what we have learned in this tutorial:

```
/* This code finds the top 5 regions that have the highest total pollution and the highest average pollution 
per industry */
SELECT
  region
  ,SUM(amount) AS total_pollution
  ,AVG(amount) AS avg_pollution_in_region
FROM
  thisisatestaccount.pollution1
GROUP BY
  region
ORDER BY avg_pollution_in_region DESC
LIMIT 5
```

<br>

<center><img src="./Images/Avg_Pollution.png" alt="Img"></center>

<br>


Wow, it looks like Waikato has been a top polluter!

What are the bottom 5 producers of carbon equivalent pollution?

```
/* This code finds the 5 regions that have the lowest total pollution and the lowest average pollution 
per industry */
SELECT
  region
  ,SUM(amount) AS total_pollution
  ,AVG(amount) AS avg_pollution_in_region
FROM
  thisisatestaccount.pollution1
GROUP BY
  region
ORDER BY avg_pollution_in_region
LIMIT 5
```

<br>

<center><img src="./Images/Top5_Least_Polluters.png" alt="Img"></center>

<br>


Good job (relatively) to Nelson! That is a large difference between the highest and least polluters. If we were analyzing this data outside of this tutorial, we would probably want to do more research within Nelson to investigate more into why their pollution levels are much lower than Waikato's.

What more can we learn? Let's try to combine our data set to see if we can find more information. First, let's explore our data sets. The last data set that we have is pollution2.

You may type `thisisatestaccount.pollution2` in the public warehouse search box or you may run the code manually.

Let's explore the data:

```
-- Returns all rows from the pollution2 data set
SELECT
  *
FROM
  thisisatestaccount.pollution2
```

Okay so we have id, region, pollution_cause, gas, units, magnitude, year, and amount. It seems like our id columns match! We also have a year column. This should be able to show us how the pollution levels have progressed over time. We will combine our two data sets and then explore Waikato's pollution output over the years.

First, let's combine the data:

```
-- Combines the pollution data sets based on their id columns
SELECT
pollution2.id
,pollution2.region
,year           -- When the column name is unique to one data set, you do not need to specify where it is located
,pollution2.amount
FROM thisisatestaccount.pollution2
INNER JOIN thisisatestaccount.pollution1
ON pollution2.id = pollution1.id
```

All we did here was get the id, region, year, and amount and combined the two data sets.

Now for the fun part. We will find the pollution progression in Waikato over time:

```
/* Join the two pollution data sets and selects the region, year, sum, and mean for Waikato's 
pollution outputs and sorts it in chronological order */
SELECT
pollution2.region
,year
,SUM(pollution2.amount) as sum
,AVG(pollution2.amount)
FROM thisisatestaccount.pollution2
INNER JOIN thisisatestaccount.pollution1
ON pollution2.id = pollution1.id
WHERE pollution2.region ='Waikato'
GROUP BY pollution2.region, year
ORDER BY year
```

Well that's cool! We got all the data we need. It is a bit hard to see the trends with just numbers though. Let's graph it:

First, click on the "+ chart" logo in the center top of the page and click on the "Line + Bar" image.

<br>

<center><img src="./Images/Line_Bar.png" alt="Img"></center>

<br> 

Next, all we have to do now is drag and drop our values. Let's drag our "sum" and "avg" values over to the Y-Axis box and our "year" tile to the X-Axis. This should output a very basic graph that we may visualize, but let's make it a bit easier to look at. 

On the right hand side, click "Format" so we may change a few specifications with our graph. Let us scale our data so it is easier to see trends. Once you are in the "Format" tab, scroll down to Y1-Axis and change "Scale Type" to "Logarithmic." Do this for Y2-Axis as well.

<br>

<center><img src="./Images/Making_Log.png" alt="Img"></center>

<br> 

We should also remove the commas in our years along the X-Axis. You can do this by clicking "Format" under "X-Axis" and selecting "none" as shown below:

<br>

<center><img src="./Images/Removing_Comma.png" alt="Img"></center>

<br>

Lastly, let's change the color of our graph so we may see the bars and lines easier. Click "Color," select "Vivid," and finally click "Assign Palette":

<br>

<center><img src="./Images/Changing_Color.png" alt="Img"></center>

<br>

How quick was that? Now we have a very nice graph to show our findings. I hope this exemplifies the simplicity and user friendly nature of SQL without the need to use any packages. Feel free to work with this data to change the graph title, x and y axis titles, creating a Legend name, moving the Legend, and even experimenting with different plots that would help show this data in different way.

Below, is a graph that has a few of the above mentioned edits.

<br>

<center><img src="./Images/Pretty_Graph.png" alt="Img"></center>

<br>

In subsequent tutorials, you can learn how to easily make a wide range graphs in Mode. Many times, you do not even need to query your data for the average, sum, count, etc since you may do it all in the graph tab itself.

For a nice challenge, try to find the yearly trends of pollution outputted in Nelson and graph your findings!

<a name="12"></a>

## 12. Congrats on making it to the end! 

<br>

<center><img src="./Images/Congrats.jpg" alt="Img"></center>

<br>

You are now ready to go into the world to manipulate and analyze data sets! I hope this tutorial has helped you take one step towards your coding goals.

#### To Recap, you have:

##### 1. Learned how to code basic queries in SQL to manipulate data.
##### 2. Combined and queried from the two joined datasets.
##### 3. Found averages, sums, minimums, maximums, and counts.
##### 4. Coded your data to find specific trends and conclusions.
##### 5. Created nice graphs to visualize your data.

Remember, practice makes perfect! If there are any points that you need to review, feel free to go through this tutorial again. Try and challenge yourself and work through error codes if you encounter any. 

If you have any questions, comments, or concerns regarding this tutorial, feel free to send me an email at s2253374@ed.ac.uk. I appreciate any questions or feedback that comes my way :)

This tutorial is licensed under a <a href="https://github.com/EdDataScienceEES/tutorial-mzargari/blob/master/LICENSE" target="_blank">MIT License</a>.

<br>

<center><img src="./Images/SQL_Footer.png" width="600" height="400" alt="Img"></center>

<br>


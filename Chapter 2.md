# Chapter 2 Creating a dataset

* [Understanding datasets](#understanding-datasets)
* [Data structures](#data-structures)
    * [Vectors](#vectors)
    * [Matrices](#matrices)
    * [Arrays](#arrays)
    * [Data frames](#data-frames)
    * [Lists](#lists)
* [Data input](#data-input)
    * [Entering data from the keyboard](#entering-data-from-the-keyboard)
    * [Importing data from a delimited text file](#importing-data-from-a-delimited-text-file)
    * [Importing data from Excel](#importing-data-from-excel)
    * [Importing data from XML](#importing-data-from-xml)
    * [Webscraping](#webscraping)
    * [Accessing database management systems](#accessing-database-management-systems)
    * [Importing data via Stat/Transfer](#importing-data-via-stattransfer)
* [Annotating datasets](#annotating-datasets)  
    * [Variable labels](#variable-labels)
    * [Value labels](#value-labels)
* [Useful functions](#useful-functions)

## Understanding datasets
A dataset is usually a rectangular array of data with rows representing observations and columns representing variables

## Data structures
R has a wide variety of objects for holding data, including scalars, vectors, matrices, arrays, data frames, and lists.
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/2.1.PNG)
 
**Some definitions**  
In R, an object is anything that can be assigned to a variable. This includes constants, data structures, functions, and even graphs. Objects have a mode (which describes how the object is stored) and a class (which tells generic functions like print how to handle it).  
A data frame is a structure in R that holds data and is similar to the datasets found in standard statistical packages. The columns are variables and the rows are observations.  
Factors are nominal or ordinal variables. They’re stored and treated specially in R.

### Vectors
Vectors are one-dimensional arrays that can hold numeric data, character data, or logical data. The combine function c() is used to form the vector.  
**Example**  
```R
a <- c(1,2,3,4,5)
b <- c("one", "two", "three")
c <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
```
**Note:** The data in a vector must only be one type or mode (numeric, character, or logical).  
**Note:** Scalars are one-element vectors. Like f <- 3, g <- "US" and h <- TRUE. They’re used to hold constants.

You can refer to elements of a vector using a numeric vector of positions within brackets.   
For example, `a[c(2, 4)]` refers to the 2nd and 4th element of vector a.   
```R
> a <- c(1, 2, 5, 3, 6, -2, 4)
> a[3]
[1] 5
> a[c(1, 3, 5)]
[1] 1 5 6
> a[2:6]
[1] 2 5 3 6 -2
```
**Note:** The colon operator used in the last statement is used to generate a sequence of numbers  

### Matrices
A matrix is a two-dimensional array where each element has the same mode (numeric, character, or logical).
**Format**  
`myymatrix <- matrix(vector, nrow=number_of_rows, ncol=number_of_columns,byrow=logical_value, dimnames=list(char_vector_rownames, char_vector_colnames))`  
where `vector` contains the elements for the matrix, `nrow` and `ncol` specify the row and column dimensions, and `dimnames` contains optional row and column labels stored in character vectors. The option `byrow` indicates whether the matrix should be filled in by row `(byrow=TRUE)` or by column `(byrow=FALSE)`. The default is by column.  

![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/list2.1.PNG)

`X[i,]` refers to the ith row of matrix `X`, `X[,j]` refers to jth column, and `X[i, j]` refers to the ijth element, respectively. The subscripts i and j can be numeric vectors in order to select multiple rows or columns

![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/list2.2.PNG)

### Arrays
Arrays are similar to matrices but can have more than two dimensions.  
**Format**  
``myarray <- array(vector, dimensions, dimnames)``  
where `vector` contains the data for the array, `dimensions` is a numeric vector givingthe maximal index for each dimension, and `dimnames` is an optional list of dimension labels.  

![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/list2.3.PNG)

### Data frames
A data frame is more general than a matrix in that different columns can contain different modes of data (numeric, character, etc.).  
**Format**  
`mydata <- data.frame(col1, col2, col3,…)`
where `col1, col2, col3, …` are column vectors of any type (such as character, numeric, or logical). Names for each column can be provided with the `names` function.  
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/list2.4.PNG)  

There are several ways to identify the elements of a data frame.  
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/list2.5.PNG) 

![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/2.5.PNG) 

The `$` notation is used to indicate a particular variable from a given data frame.  

**Example** If you want to cross tabulate diabetes type by status, you could use the following code:  
```R
table(patientdata$diabetes, patientdata$status)
```
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/2.6.PNG) 

`ATTACH, DETACH, AND WITH`  
The `attach()` function adds the data frame to the R search path. When a variable name is encountered, data frames in the search path are checked in order to locate the variable.  
The `detach()` function removes the data frame from the search path.    
```R
summary(mtcars$mpg)
plot(mtcars$mpg, mtcars$disp)
plot(mtcars$mpg, mtcars$wt)
```
This could also be written as   
```R
attach(mtcars)
summary(mpg)
plot(mpg, disp)
plot(mpg, wt)
detach(mtcars)
```
**The limitations with this approach are evident when more than one object can have the same name.**  
An alternative approach is to use the `with()` function.  
```R
with(mtcars, {
summary(mpg, disp, wt)
plot(mpg, disp)
plot(mpg, wt)
})
```
**The limitation of the with() function is that assignments will only exist within the function brackets.**   

If you need to create objects that will exist outside of the with() construct, use the special assignment operator <<- instead of the standard one (<-). It will save the object to the global environment outside of the with() call.  
**Example**  
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/2.7.PNG)   

**CASE IDENTIFIERS**   
In R, case identifiers can be specified with a `rowname` option in the data frame function

```R
patientdata <- data.frame(patientID, age, diabetes, status,row.names=patientID)
```   
specifies `patientID` as the variable to use in labeling cases on various printouts and graphs produced by R   

### Factors  
Categorical (nominal) and ordered categorical (ordinal) variables in R are called factors.  
The function `factor()` stores the categorical values as a vector of integers in the range [1... k] (where k is the number of unique values in the nominal variable), and an internal vector of character strings (the original values) mapped to these integers.  
**Example**  
```R
diabetes <- c("Type1", "Type2", "Type1", "Type1")
diabetes <- factor(diabetes)  #stores this vector as (1, 2, 1, 1) and associates it with 1=Type1 and 2=Type2 internally
status <- c("Poor", "Improved", "Excellent", "Poor")
status <- factor(status, ordered=TRUE)  #encode the vector as (3, 2, 1, 3) and associate these values internally as 1=Excellent, 2=Improved, and 3=Poor.
```
In order to assign the factor levels by ourselves, we can use `levels` inside the `factor()` function.  
`status <- factor(status, order=TRUE, levels=c("Poor", "Improved", "Excellent"))`  

**Example**
```R
patientID <- c(1, 2, 3, 4) 
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")
diabetes <- factor(diabetes)
status <- factor(status, order=TRUE)
patientdata <- data.frame(patientID, age, diabetes, status) 
str(patientdata)             #Display object structure
summary(patientdata)         #Display object summary
```
### Lists
A list is an ordered collection of objects (components).  
**Format**  
`mylist <- list(object1, object2, …)  
mylist <- list(name1=object1, name2=object2, …)`  
**Example**
```R
g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow=5)
k <- c("one", "two", "three")
mylist <- list(title=g, ages=h, j, k)
mylist
```

**Note**  
* The period (.) has no special significance in object names. The dollar sign ($) can be usde to identify the parts of an object. For example, A$x refers to variable x in data frame A.  
* R doesn’t provide multiline or block comments . You must start each line of a multiline comment with #.
* Assigning a value to a nonexistent element of a vector, matrix, array, or list will expand that structure to accommodate the new value.  
* R doesn’t have scalar values . Scalars are represented as one-element vectors.  
* Indices in R start at 1, not at 0.
* **Variables can’t be declared. They come into existence on first assignment.**

## Data input
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/2.2.PNG)
### Entering data from the keyboard  
The `edit()` function in R will invoke a text editor that will allow you to enter your data manually.  
1  Create an empty data frame (or matrix) with the variable names and modes you want to have in the final dataset.  
2  Invoke the text editor on this data object, enter your data, and save the results back to the data object.  
```R
mydata <- data.frame(age=numeric(0), gender=character(0), weight=numeric(0))
mydata <- edit(mydata)
```
Assignments like `age=numeric(0)` create a variable of a specific mode, but without actual data. Note that the result of the editing is assigned back to the object itself. The `edit()` function operates on a copy of the object. If you don’t assign it a destination, all of your edits will be lost! **A shortcut for `mydata <- edit(mydata)` is simply `fix(mydata)`**.

### Importing data from a delimited text file  
The `read.table()` function reads a file in table format and saves it as a data frame.  
```R
mydataframe <- read.table(file, header=logical_value,sep="delimiter", row.names="name")
```
where `file` is a delimited ASCII file , `header` is a logical value indicating whether the first row contains variable names (TRUE or FALSE), `sep` specifies the delimiter separating data values, and `row.names` is an optional parameter specifying one or more variables to represent row identifiers.  

**Note**  
The sep parameter allows you to import files that use a symbol other than a comma to delimit the data values. You could read tab-delimited files with `sep="\t"`. The default is `sep=""`, which denotes one or more spaces, tabs, new lines, or carriage returns.

By default, character variables are converted to factors. This behavior may not always be desirable (for example, a variable containing respondents’ comments). You can suppress this behavior in a number of ways. Including the option `stringsAsFactors=FALSE` will turn this behavior off for all character variables. Alternatively, you can use the `colClasses` option to specify a class (for example, logical, numeric, character, factor) for each column.

R provides several mechanisms for accessing data via connections as well. For example, the functions `file()` , `gzfile()` , `bzfile()` , `xzfile()` , `unz()` , and `url()` can be used in place of the filename. See `help(file)` for details.

### Importing data from Excel  
The best way to read an Excel file is to export it to a comma-delimited file from within Excel and import it to R using the method described earlier.

The `xlsx` package can be used to access spreadsheets in XLSX file.
**Format**
```R
read.xlsx(file, n)
```
`file` is the path and `n` is the number of the worksheet to be imported.  
**Example**
```R
library(xlsx)
workbook <- "c:/myworkbook.xlsx"
mydataframe <- read.xlsx(workbook, 1)
```

### Importing data from XML
The `XML` package written by Duncan Temple Lang allows users to read, write, and manipulate XML files. See www.omegahat.org/RSXML for details.  

### Webscraping
One way  is to download the web page using the `readLines()` function and manipulate it with functions such as `grep()` and `gsub()` . For complex web pages, the `RCurl` and `XML` packages can be used to extract the information desired. For more information, including examples, see “Webscraping using readLines and RCurl,” available from the website Programming with R (www.programmingr.com).

### Accessing database management systems
**THE ODBC INTERFACE**
The most popular method of accessing a DBMS in R is through the `RODBC` package, which allows R to connect to any DBMS that has an ODBC driver.   
1. install and configure the appropriate ODBC driver for your platform and database  
2. install the `RODBC` package   
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/table2.2.PNG)   
**Example**
```R
library(RODBC)
myconn <-odbcConnect("mydsn", uid="Rob", pwd="aardvark")
crimedat <- sqlFetch(myconn, Crime)
pundat <- sqlQuery(myconn, "select * from Punishment")
close(myconn)
```
Load the `RODBC` package and open a connection to the ODBC database through a registered data source name `(mydsn)` with a security UID `(rob)` and password `(aardvark)`. The connection string is passed to `sqlFetch`, which copies the table `Crime` into the R data frame `crimedat` . Then run the SQL `select` statement against the table `Punishment` and save the results to the data frame `pundat` . Finally, close the connection.    
The `sqlQuery()` function is very powerful because any valid SQL statement can be inserted. This flexibility allows you to select specific variables, subset the data, create new variables, and recode and rename existing variables.

### Importing data via Stat/Transfer
Stat/Transfer (www.stattransfer.com) is a stand-alone application that can transfer data between 34 data formats, including R.  
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/figure2.4.PNG) 

## Annotating datasets
### Variable labels
One approach is to use the variable label as the variable’s name and then refer to the variable by its position index.

### Value labels
The `factor()` function can be used to create value labels for categorical variables.
**Example**
```R
patientdata$gender <- factor(patientdata$gender,
levels = c(1,2),
labels = c("male", "female"))
```
Here `levels` indicate the actual values of the variable, and `labels` refer to a character vector containing the desired labels.

## Useful functions
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/table2.3.PNG)

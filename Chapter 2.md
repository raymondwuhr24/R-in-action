# Chapter 2 Creating a dataset
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


The $ notation is used to indicate a particular variable from a given data frame.  

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
patientID <- c(1, 2, 3, 4) q
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
## Data input
























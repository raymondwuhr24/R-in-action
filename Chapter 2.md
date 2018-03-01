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



















































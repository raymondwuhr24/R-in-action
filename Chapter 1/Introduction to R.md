# Chapter 1 Introduction to R

## Getting started 
### A sample R session
```R
 age <- c(1,3,5,2,11,9,3,9,12,3)
 weight <- c(4.4,5.3,7.2,5.2,8.5,7.3,6.0,10.4,10.2,6.1)
 mean(weight)
[1] 7.06
 sd(weight)
[1] 2.077498
 cor(age,weight)
[1] 0.9075655
 plot(age,weight)
 q()
```
 > demo: **demo(graphics)**   **demo(Hershey)**   **demo(persp)**    **demo(image)**  

## Getting help  
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/table1.2.PNG)

## The workspace  
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/table1.3.PNG)

## Input and output  
**Input:** source("filename") function submits a script to the current session.  
**Text Output:** sink("filename")function redirects output to the filename.  
**Graphic Output:**   
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/table1.4.PNG)

## Package
There are over 2,500 user-contributed modules called packages that you can download from http://cran.r-project.org/web/packages  

### What are packages
Packages are collections of R functions, data, and compiled code in a well-defined format. The directory where packages are stored on your computer is called the library. The function .libPaths() shows you where your library is located, and the function library() shows you what packages you’ve saved in your library.

### Installing a package
To install a package for the first time, use the install.packages() command.

### Loading a package
To use it in an R session, you need to load the package using the library() command.

### Learning about a package
Entering help(package="package_name") provides a brief description of the package and an index of the functions and datasets included. Using help() with any of these function or dataset names will provide further details. The same information can be downloaded as a PDF manual from CRAN.

## Common mistakes in R programming
There are some common mistakes made frequently by both beginning and experienced R programmers. If your program generates an error, be sure the check for the following:  
* Using the wrong case —help(), Help(), and HELP() are three different functions (only the first will work).
* Forgetting to use quote marks when they’re needed —install.packages-("gclus") works, whereas install.packages(gclus) generates an error.
* Forgetting to include the parentheses in a function call —for example, help() rather than help. Even if there are no options, you still need the ().
* Using the \ in a pathname on Windows —R sees the backslash character as an escape character. setwd("c:\mydata") generates an error. Use setwd("c:/mydata") or setwd("c:\\mydata") instead.
* Using a function from a package that’s not loaded —The function order. clusters() is contained in the gclus package. If you try to use it before loading the package, you’ll get an error.

## Using output as input—reusing results
One of the most useful design features of R is that the output of analyses can easily be saved and used as input to additional analyses.
```R
lmfit <- lm(mpg~wt, data=mtcars) #linear regression predicting miles per gallon 
                                 #(mpg) from car weight(wt), using the automotive dataset mtcars
summary(lmfit)                   #displays a summary of the results
plot(lmfit)                      #produces diagnostic plots
cook<-cooks.distance(lmfit)      #generates influence statistics
plot(cook) 







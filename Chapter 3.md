# Chapter 3 Getting started with graphs

* [Working with graphs](#working-with-graphs)
* [A simple example](#a-simple-example)
* [Graphical parameters](#graphical-parameters)




## Working with graphs
**Example**  
```R
attach(mtcars)
plot(wt, mpg)
abline(lm(mpg~wt))
title("Regression of MPG on Weight")
detach(mtcars)
```
The first statement attaches the data frame mtcars. The second statement opens a graphics window and generates a scatter plot between automobile weight on the horizontal axis and miles per gallon on the vertical axis. The third statement adds a line of best fit. The fourth statement adds a title. The final statement detaches the data frame.
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/3.1.jpeg)

Creating a new graph by issuing a high-level plotting command such as `plot()`, `hist()` (for histograms), or `boxplot()` will typically overwrite a previous graph.  
1. Open a new graph window before creating a new graph  
```R
dev.new()
statements to create graph 1
dev.new()
statements to create a graph 2
```
2. Use the functions `dev.new()`, `dev.next()`, `dev.prev()`, `dev.set()`, and `dev.off()` to have multiple graph windows open at one time and choose which output are sent to which windows.  

## A simple example
![](https://github.com/raymondwuhr24/R-in-action/blob/master/Printscreen/table3.1.PNG)
```R
dose <- c(20, 30, 40, 45, 60)
drugA <- c(16, 20, 27, 40, 60)
drugB <- c(15, 18, 25, 31, 40)
plot(dose, drugA, type="b")
```
`plot()` is a generic function that plots objects in R (its output will vary according to the type of object being plotted). In this case, `plot(x, y, type="b")` places `x` on the horizontal axis and `y` on the vertical axis, plots the `(x, y)` data points, and connects them with line segments. The option `type="b"` indicates that both points and lines should be plotted.

## Graphical parameters
























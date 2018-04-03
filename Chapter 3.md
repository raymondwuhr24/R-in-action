# Chapter 3 Getting started with graphs

* [Working with graphs](#working-with-graphs)


##Working with graphs
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

























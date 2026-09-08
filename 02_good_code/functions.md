# Writing functions and helpers


If you need a reference for writing functions, take a look at [this
chapter](https://r4ds.hadley.nz/functions.html) from *R for Data
Science*.

## 1. Leaving the house

Think about what you need in order to leave the house for work or
school. What things do you need to get out the door—some variation on
“phone, wallet, keys”? Think about what influences your list, e.g. maybe
you switch modes of transportation, which will decide whether you need
car keys, a bike helmet and lights, or money on CharmPass. Fill those in
here:

**Things you *always* need:**

- Car key
- Wallet (has my house key inside)
- Phone
- Headband
- Water bottle

**Things you *sometimes* need**, including what determines whether you
need each thing:

- Airpods (if I am going on a run or expect to be working from a
  location outside of my house)
- Backpack, if I am going to school, or am bringing more than a handful
  of things with me
- Tennis bag if I am playing tennis that day

Write it out as pseudocode here, filling in the blanks and adding more
fake code:

    function leaving_the_house {
        always_need car keys, wallet, phone, headband, water bottle
        if playing tennis then bring tennis bag
        elif going on run then bring airpods
        elif going to school then bring backpack
        otherwise ___
    }

    I ended up changing this list, the below one reflects the truth

From your pseudocode, decide on your arguments and write out a working R
function. It should return a list or string giving the things you’ll
need based on the arguments you give. If you want to get fancy, use some
calls to `print` or `cat` to make a nice printout as well.

``` r
leaving_the_house <- function(day_of_week, driving, activity_list, over_hour) {
  always_need <- c("Phone")
  sometimes_need <- c()
  if ("tennis" %in% activity_list) {
    sometimes_need <- append(sometimes_need, "Tennis Bag")
  }
  if ("run" %in% activity_list) {
    sometimes_need <- append(sometimes_need, "Airpods")
  }
  if (over_hour == TRUE) {
    sometimes_need <- append(sometimes_need, "Water Bottle")
  }
  if (driving == TRUE) {
    sometimes_need <- append(sometimes_need, "Car Key")
  }
  if ("Monday" %in% day_of_week | "Tuesday" %in% day_of_week) {
    sometimes_need <- append(sometimes_need, "Backpack")
  }
  items_to_bring <- c(always_need, sometimes_need)
  print(c("Items to bring: ", items_to_bring))
}
```

Then call your function a few times with different arguments. Start with
ones that match what you did today, then try it with what you’ll need to
do tomorrow.

``` r
today <- leaving_the_house("Monday", TRUE, c(), TRUE)
```

    [1] "Items to bring: " "Phone"            "Water Bottle"     "Car Key"         
    [5] "Backpack"        

``` r
today
```

    [1] "Items to bring: " "Phone"            "Water Bottle"     "Car Key"         
    [5] "Backpack"        

``` r
wed <- leaving_the_house("Wednesday", FALSE, c("run"), FALSE)
```

    [1] "Items to bring: " "Phone"            "Airpods"         

``` r
wed
```

    [1] "Items to bring: " "Phone"            "Airpods"         

## 2. Chart labels

### Labels across one range

You’re making a bar chart, and you want to place labels near the end of
each bar. The labels should be inside the bar, but you want a little bit
of space between the top of the text and the end of the bar, like so:

![Bars with labels](example_plot1.png)

Figure out the arithmetic you’ll need to do to place labels in this way.
You want to choose a certain amount that you’ll nudge the text down from
the end of each bar. I’d recommend drawing this out by hand on paper,
first for just one bar, then for all 5. Again, start with pseudocode if
that might help, or jump right into an R function. Use the data in the
next chunk; it’s not exactly the same as what’s in the example chart,
but it’s generated similarly.

``` r
library(dplyr)
```

    Warning: package 'dplyr' was built under R version 4.5.3


    Attaching package: 'dplyr'

    The following objects are masked from 'package:stats':

        filter, lag

    The following objects are masked from 'package:base':

        intersect, setdiff, setequal, union

``` r
library(ggplot2)
```

    Warning: package 'ggplot2' was built under R version 4.5.3

``` r
data1 <- structure(
    list(group = c("A", "B", "C", "D", "E"), value = c(19, 18, 13, 15, 20)),
    row.names = c(NA, -5L),
    class = c("tbl_df", "tbl", "data.frame")
)

data1
```

    # A tibble: 5 × 2
      group value
      <chr> <dbl>
    1 A        19
    2 B        18
    3 C        13
    4 D        15
    5 E        20

The first version of your function will take a vector `y`, for the y
value of each observation. It should return a vector of the same length,
with the position at which you want to place each text label. So if you
decide that values 2, 3, and 5 should have labels placed at 1.5, 2.5,
and 4.5, then calling

``` r
label_nudge(c(2, 3, 5))
```

should return `c(1.5, 2.5, 4.5)`. You’ll probably find this looks best
if you nudge every value down by a fixed amount; your task is to figure
out what that amount is.

``` r
label_nudge <- function(y) {
    # do your calculations here
    # when you're ready, replace 0 with your return value
    offset <- 0.05 * max(y)

    return(y - offset)
}

label_nudge(data1$value)
```

    [1] 18 17 12 14 19

Now you should be able to call that function, assign the nudged values
to a variable in your data frame, and use those nudged values to place
labels. Keep adjusting the function until the label placement looks how
you want. If you haven’t used `ggplot` much yet, don’t worry; the code
I’ve set up should run for you.

``` r
data1$y_nudge <- label_nudge(data1$value)
ggplot(data1, aes(x = group, y = value)) +
    geom_col() +
    geom_text(
        aes(label = value, y = y_nudge),
        color = "white",
        size = 6,
        vjust = 1
    )
```

![](functions_files/figure-commonmark/label-plot-1-1.png)

``` r
# vjust is the vertical justification; vjust = 1 means labels will be aligned at the top
```

### Scaling your function

Part of the purpose of writing a function is that it can scale to other
situations. If you hardcoded a certain amount to nudge your labels by
for the first range, it might not work as well for a different range.
Try repeating what you just did (calling the function to set label
positions) with a different dataset, and see if you still like the
placement. If not, you’ll need some different calculations to fit
different ranges of numbers.

``` r
data2 <- structure(
    list(group = c("A", "B", "C", "D", "E"), value = c(99, 45, 44, 60, 62)),
    row.names = c(NA, -5L),
    class = c("tbl_df", "tbl", "data.frame")
)

data2
```

    # A tibble: 5 × 2
      group value
      <chr> <dbl>
    1 A        99
    2 B        45
    3 C        44
    4 D        60
    5 E        62

``` r
data2$y_nudge <- label_nudge(data2$value)

ggplot(data2, aes(x = group, y = value)) +
    geom_col() +
    geom_text(
        aes(label = value, y = y_nudge),
        color = "white",
        size = 6,
        vjust = 1
    )
```

![](functions_files/figure-commonmark/label-plot-new-range-result-1.png)

## 3. Number formatting

Develop a few functions for formatting different types of numbers—we’ll
start with percentages, currency, and large numbers (over 1,000).

### Simple functions

First, we’ll just use base R functions, `round`, `formatC`, and `paste0`
(like `paste`, but with a default of no separator). Here are the numbers
you’ll be formatting as integers, with the desired output:

``` r
percent_vals <- c(0.05, 0.1, 0.512, 0.678) # want 5%, 10%, 51%, 68%
dollar_vals <- c(100, 110.70, 823, 1123) # want $100; $111; $823; $1,123
comma_vals <- c(2345, 10123.4, 999, 1205) # want 2,345; 10,123; 999; 1,205
```

``` r
# define functions here
percent1 <- function(x) {}
percent1(percent_vals)
```

    NULL

``` r
dollar1 <- function(x) {}
dollar1(dollar_vals)
```

    NULL

``` r
comma1 <- function(x) {}
comma1(comma_vals)
```

    NULL

### Generating functions

The package `scales` has helper functions you can use; these drive many
of the calculations under the hood in ggplot. Read through the package
docs to get familiar, especially with the `label_*` functions (functions
with names starting with “label\_”).

First, call one of the `scales` functions and assign the result to a
variable. Then see what type of object it is:

``` r
number <- scales::label_number()
class(number)
```

    [1] "function"

The `scales::label_*` functions are actually *function factories*,
functions that return functions. This might seem weird, but they help
you develop custom number formatting functions that are both specific
and reusable. You can read details about function factories in [Advanced
R](https://adv-r.hadley.nz/function-factories.html).

Define another set of functions, now using `scales::label_percent`,
`scales::label_currency`, and `scales::label_comma`. For example, if you
want to label numbers with 2 numbers after the decimal point, you can
use `scales::label_number` to create a labeller function:

``` r
decimal <- scales::label_number(accuracy = 0.01)
decimal(c(1.234, 5.1, 10.999))
```

    [1] "1.23"  "5.10"  "11.00"

## 4. Finishing up

If you came up with any functions you think will be useful moving
forward, copy them over to `utils/helper_functions.R` so you can use
them in any of your labs and projects.

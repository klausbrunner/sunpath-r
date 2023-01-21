Plotting a sun-path diagram using data from solarpos-cli
================

First, run [solarpos-cli](https://github.com/KlausBrunner/solarpos-cli)
and capture its output in a CSV file. We’re getting position data for
the entire year 2023 in Salzburg, Austria. Depending on your setup, you
may have to add the “java” command and an absolute path.

``` sh
solarpos-cli.jar 47.795 13.047 2023 --timezone UTC --deltat --format=csv position --step=600 > /tmp/sunpositions.csv
```

Now read that CSV and pick data for one day of each month. While we’re
at it, remove all observations where the sun isn’t visible anyway
(i.e. zenith angle is greater than 90°) and add a convenient “month”
column. This will come in handy for the diagram.

``` r
library(tidyverse)

sunpath <- read_csv("/tmp/sunpositions.csv", 
                    col_names=c("daytime", "azimuth", "zenith"), 
                    show_col_types = FALSE) |> 
  subset(subset = as.Date(daytime) %in% seq(as.Date("2023-01-15"), as.Date("2023-12-15"), "months")) |> 
  filter(zenith <= 90.0) |>
  mutate(month = format(daytime, "%m"))

sunpath
```

    ## # A tibble: 875 × 4
    ##    daytime             azimuth zenith month
    ##    <dttm>                <dbl>  <dbl> <chr>
    ##  1 2023-01-15 07:00:00    123.   89.3 01   
    ##  2 2023-01-15 07:10:00    125.   88.0 01   
    ##  3 2023-01-15 07:20:00    127.   86.7 01   
    ##  4 2023-01-15 07:30:00    129.   85.5 01   
    ##  5 2023-01-15 07:40:00    130.   84.2 01   
    ##  6 2023-01-15 07:50:00    132.   83.0 01   
    ##  7 2023-01-15 08:00:00    134.   81.7 01   
    ##  8 2023-01-15 08:10:00    136.   80.6 01   
    ##  9 2023-01-15 08:20:00    139.   79.5 01   
    ## 10 2023-01-15 08:30:00    141.   78.4 01   
    ## # … with 865 more rows

Now plot a simple sun path diagram.

``` r
spplot <- ggplot(sunpath, aes(x = azimuth, y = zenith, color = month)) + 
  geom_line() + 
  scale_y_continuous(limits = c(0, 90), breaks = seq(0, 90, by=15)) + 
  scale_x_continuous(limits = c(0, 360), breaks = seq(0, 359, by=10)) +
  labs(title = "Sun path for Salzburg, Austria in 2023") +
  coord_polar()

spplot
```

![](sunpath_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

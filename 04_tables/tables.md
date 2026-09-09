# Tables


This will be a very quick lab where you just practice formatting your
data and making a table of it. Not much that isn’t already in the notes.

- Use the ACS data, filtered for the US, Maryland, and a few counties of
  your choice.
- Choose a few columns you’re interested in, and select those (plus
  location).
- Use more than one type of numeric variable (choose a mix of
  percentages, integers, and/or dollar amounts).
- Define the formatter functions you’ll need, and use them to format
  each variable as appropriate.
- Create a table using `knitr::kable`.
- Give your columns clean, readable names.
- Align the columns so text columns are aligned on the left, numeric
  ones on the right.
- Give the table a title using the `caption` argument of `kable`.

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
library(justviz)
library(knitr)
```

    Warning: package 'knitr' was built under R version 4.5.3

``` r
library(scales)

# subsetting the dataset to the USA, MD, and the counties around Anne Arundel. 
# Selecting focus variables
acs_anne_around <- justviz::acs |>
    dplyr::filter(
        name %in%
            c(
                "United States",
                "Maryland",
                "Anne Arundel County",
                "Calvert County",
                "Prince George's County",
                "Howard County",
                "Baltimore County",
                "Baltimore city"
            )
    ) |>
    dplyr::select(level, name, median_hh_income, no_vehicle_hh, poverty, low_income, diversity_idx)
```

``` r
# setting up scales functions

percent <- scales::label_percent(accuracy = 1)
dollar <- scales::label_currency(accuracy = 1)

# assigning new values from scales functions
acs_anne_around_fmt <- acs_anne_around |> 
  mutate(median_hh_income = dollar(median_hh_income),
         no_vehicle_hh = percent(no_vehicle_hh),
         poverty = percent(poverty),
         low_income = percent(low_income),
         diversity_idx = percent(diversity_idx)
         )

kable(acs_anne_around_fmt, col.names = c(
  "Level",
  "Name",
  "Median Household Income",
  "No Vehicle Households",
  "Poverty Rate",
  "Low Income Rate",
  "Diversity Index"
),
align = "llrrrrr",
caption = "Selected socioeconomic indicators, Anne Arundel and nearby counties, 2024")
```

| Level | Name | Median Household Income | No Vehicle Households | Poverty Rate | Low Income Rate | Diversity Index |
|:---|:---|---:|---:|---:|---:|---:|
| us | United States | \$80,734 | 8% | 12% | 28% | 76% |
| state | Maryland | \$103,678 | 9% | 9% | 21% | 81% |
| county | Anne Arundel County | \$124,911 | 4% | 6% | 14% | 71% |
| county | Baltimore County | \$91,768 | 8% | 10% | 23% | 76% |
| county | Baltimore city | \$62,177 | 27% | 20% | 38% | 69% |
| county | Calvert County | \$133,922 | 3% | 4% | 11% | 56% |
| county | Howard County | \$149,763 | 4% | 5% | 12% | 86% |
| county | Prince George’s County | \$101,798 | 9% | 11% | 23% | 72% |

Selected socioeconomic indicators, Anne Arundel and nearby counties,
2024

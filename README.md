# dplyr
dplyr is the next iteration of plyr, focussed on tools for working with data frames (hence the d in the name). It has three main goals:
- Identify the most important data manipulation tools needed for data analysis and make them easy to use from R.
- Provide blazing fast performance for in-memory data by writing key pieces in C++.
- Use the same interface to work with data no matter where it's stored, whether in a data frame, a data table or database.

We use data "hflights" to practice the single table and multible table verbs of this packages:


Single table verbs:
- select(): focus on a subset of variables
- filter(): focus on a subset of rows
- mutate(): add new columns
- summarise(): reduce each group to a smaller number of summary statistics
- arrange(): re-order the rows

Multiple table verbs:
- inner_join(x, y): matching x + y
- left_join(x, y): all x + matching y
- semi_join(x, y): all x with match in y
- anti_join(x, y): all x without match in y
- intersect(x, y): all rows in both x and y
- union(x, y): rows in either x or y
- setdiff(x, y): rows in x, but not y

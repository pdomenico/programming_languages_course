use "homework.sml";
is_older((2020, 12, 23), (2021, 5, 45));
is_older((2020, 1, 5), (2020, 1, 5));
is_older((2022, 5, 22), (2021, 7, 29));

val dates: (int*int*int) list = [(2020, 5, 22), (2021, 5, 23), (1967, 3, 4), (2025, 5, 10), (2021, 4, 7), (1996, 5, 1), (1967, 4, 24)];
number_in_month(dates, 5);
number_in_months(dates, [3, 4]);

dates_in_month(dates, 5);
dates_in_months(dates, [3, 4]);

get_nth(["ciao", "mi", "chiamo", "domenico"], 4);

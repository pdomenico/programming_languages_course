fun is_older(first_date: int*int*int , second_date: int*int*int) =
   if (#1 first_date > #1 second_date)
   then false
   else if (#1 first_date < #1 second_date)
   then true
   else if (#2 first_date > #2 second_date)
   then false
   else if (#2 first_date < #2 second_date)
   then true
   else if (#3 first_date > #3 second_date)
   then false
   else (#3 first_date < #3 second_date)

fun number_in_month(dates: (int*int*int) list, month: int) =
    if null dates
    then 0
    else if (#2 (hd dates)) = month
    then 1 + number_in_month((tl dates), month)
    else number_in_month((tl dates), month)

fun number_in_months(dates: (int*int*int) list, months: int list) =
    if null months then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)

fun dates_in_month(dates: (int*int*int) list, month: int) =
    if null dates then []
    else if (#2 (hd dates)) = month
    then (hd dates)::dates_in_month(tl dates, month) 
    else dates_in_month(tl dates, month)

fun dates_in_months(dates: (int*int*int) list, months: int list) =
    if null months then []
    else dates_in_month(dates, hd months)::dates_in_months(dates, tl months)

fun get_nth(lst: string list, n: int) =
    if n = 1 then hd lst
    else get_nth(tl lst, n-1)

fun date_to_string(date: int*int*int) =
    let
        val months_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    in
        get_nth(months_names, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

fun get_nth_int(lst: int list, index: int) =
    if index = 1
    then hd lst
    else get_nth_int(tl lst, index -1)

fun number_before_reaching_sum(sum: int, lst: int list) =
    let
        fun helper(current_sum: int, index: int) =
            if (current_sum + get_nth_int(lst, index)) >= sum
            then index -1
            else helper(current_sum + get_nth_int(lst, index), index +1)
        in
            helper(0, 1)
        end

fun what_month(day: int) =
    let 
        val days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        number_before_reaching_sum(day, days_in_months) +1
    end

fun month_range(day1: int, day2: int) =
    let 
        fun helper(day: int) =
            if day > day2
            then []
            else what_month(day)::helper(day+1) 
    in 
        helper(day1)
    end

fun oldest(dates: (int*int*int) list) =
    if null dates
    then NONE
    else if null (tl dates)
    then SOME (hd dates)
    else let
            val first_date = hd dates
            val second_date = hd (tl dates)
        in
            if is_older(first_date, second_date)
            then oldest(first_date::(tl (tl dates)))
            else oldest(second_date::(tl (tl dates)))
        end

fun is_in_list(element: int, lst: int list) = 
    if null lst
    then false
    else if element = hd lst
    then true
    else is_in_list(element, tl lst)

fun only_uniques(lst: int list) =
    if null lst
    then []
    else if is_in_list(hd lst, tl lst)
    then only_uniques(tl lst)
    else (hd lst)::only_uniques(tl lst)

fun number_in_months_challenge(dates: (int*int*int) list, months: int list) =
    number_in_months(dates, only_uniques(months))

fun dates_in_months_challenge(dates: (int*int*int) list, months: int list) =
    dates_in_months(dates, only_uniques(months))

fun reasonable_date(date: int*int*int) = 
    let 
        val year = #1 date
        val month = #2 date
        val day = #3 date
        val days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        fun is_leap_year(year:int) =
            if (year mod 400) = 0
            then true
            else if (year mod 4) = 0
            then not ((year mod 100) = 0)
            else false
    in
        if year < 1 then false
        else if month < 1 orelse month > 12
        then false
        else if month = 2 andalso is_leap_year(year)
        then day <= 29
        else day <= get_nth_int(days_in_months, month)
    end
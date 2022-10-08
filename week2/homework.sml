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
   else if (#3 first_date < #3 second_date)
   then true
   else false

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
    if n = 1
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
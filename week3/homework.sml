(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* Helper functions *)
fun member (item, lst) =
            case lst of 
                  [] => false
                | x::xs => same_string(x, item) orelse member(item, xs)

fun remove (item, lst) =
            case lst of
                  [] => []
                | x::xs => if same_string(x, item)
                           then remove(item, xs)
                           else x::remove(item, xs)

(* Problem 1 *)
fun all_except_option (str, strlist) = 
    if member (str, strlist)
    then SOME (remove (str, strlist))
    else NONE

fun get_substitutions1 (strlstlst, s) = 
    case strlstlst of
          [] => []
        | hd::tl =>  case all_except_option (s, hd) of
                        NONE => get_substitutions1 (tl, s)
                      | SOME result => result @ get_substitutions1 (tl, s)

fun get_substitutions2(strlstlst, s) =
  let fun helper(strlstlst, acc) =
        case strlstlst of
            [] => acc
          | hd::tl => case all_except_option(s, hd) of
                          NONE => helper(tl, acc)
                        | SOME result => helper(tl, acc @ result)
  in helper(strlstlst, [])
  end

fun similar_names (strlstlst, {first, middle, last}) =
  let fun helper (names) =
        case names of
            [] => []
          | hd::tl => {first= hd, middle= middle, last= last}::helper(tl)
  in  {first=first, middle=middle, last=last}::(helper (get_substitutions1 (strlstlst, first)))
  end

(* Problem 2 *)
fun card_color(suit, rank) = 
  case suit of
      Clubs => Black
    | Spades => Black
    | _ => Red

fun card_value(suit, rank) =
  case rank of 
      Num v => v
    | Ace => 11
    | _ => 10

fun remove_card(cs, c, e) = 
  case cs of 
      [] => raise e
    | hd::tl => if hd = c
                then tl
                else hd::(remove_card(tl, c, e))

fun all_same_color(cs) =
  case cs of
      [] => true
    | first::[] => true
    | first::(second::rest) =>  if (card_color first) = (card_color second)
                                then all_same_color (second::rest)
                                else false

fun sum_cards(cs) = 
  let fun helper(cs, acc) =
        case cs of
            [] => acc
          | hd::tl => helper(tl, acc + (card_value hd))
  in helper(cs, 0)
  end

fun score(cs, goal) = 
  let val sum = sum_cards cs
      val preliminary_score = if sum > goal
                              then 3 * (sum - goal)
                              else goal - sum
  in  if all_same_color cs
      then preliminary_score div 2
      else preliminary_score
  end

fun mem(item, lst) = 
  case lst of
      [] => false
    | hd::tl => hd = item orelse mem(item, tl)

fun rem(item, lst) = 
  case lst of
      [] => []
    | hd::tl => if hd = item  
                then tl
                else hd::rem(item, tl)

fun officiate(card_list, moves, goal) = 
  let fun helper(card_list, held_cards, moves, current_score, sum) =
        if sum > goal then current_score else
        case moves of 
            [] => current_score
          | Draw::rest_of_moves => 
              (case card_list of 
                  [] => current_score
                | hd::tl => let val new_held = hd::held_cards
                            in helper(tl, new_held, rest_of_moves, score(new_held, goal), sum_cards(new_held))
                            end)
          | Discard(c)::rest_of_moves => 
              if mem(c, held_cards)
              then  let val new_held = rem(c, held_cards)
                    in helper(card_list, new_held, rest_of_moves, score(new_held, goal), sum_cards(new_held))
                    end
              else  raise IllegalMove
  in helper(card_list, [], moves, score([], goal), sum_cards([]))
  end

fun min(lst) = 
  let fun helper(sublist, sofar) =
        case sublist of 
            [] => sofar
          | hd::tl => if hd < sofar
                      then helper(tl, hd)
                      else helper(tl, sofar)
  in  case lst of  
          [] => 0
        | hd::tl => helper(lst, hd)
  end

fun score_challenge(cards, goal) = 
  let fun count_aces cards =
        case cards of
            [] => 0
          | (suit, rank)::tl => if rank = Ace
                                then 1 + count_aces tl
                                else count_aces tl
      fun score(cards, sum) = 
        let val preliminary_score = if sum > goal
                                    then 3 * (sum - goal)
                                    else goal - sum
        in  if all_same_color cards  
            then preliminary_score div 2
            else preliminary_score
        end
      fun generate_scores aces =
            if aces = 0
            then [score(cards, sum_cards(cards))]
            else (score(cards, sum_cards(cards) - (10 * aces)))::generate_scores(aces-1)
  in min(generate_scores(count_aces cards))
  end
      


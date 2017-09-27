# WordCount

Fetches the text from the provided URL and does the following:

1. Calculates and displays a word count
1. Displays the top twenty words and their counts
1. Displays a histogram of the top 5 words

## Installation

1. Install Elixir with `brew install elixir`
1. Install dependencies with `mix deps.get`

## Running

    mix run word_count.exs "http://www.gutenberg.org/files/974/974-0.txt"

For example, the output will look something like this:

```
There are 10515 unique words having at least 3 letters.
The top 20 words are as follows: <word> <occurrences>:
   the 5680
   and 1986
   his 1645
   was 1240
  with 996
  that 984
   had 852
   for 753
   her 743
   not 656
   you 651
verloc 620
   she 594
   but 503
  this 451
   him 447
  have 356
  from 349
   all 337
   out 326
The top 5 words' distributions are as follows: <word> <frequency>:
 the |||||
 and ||
 his |
 was |
with |
```

The tests can be run with `mix test`

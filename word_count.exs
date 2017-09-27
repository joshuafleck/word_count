if Enum.count(System.argv()) != 1, do: raise "URL of the document to analyse should be the only argument: word_count.exs <url>"
WordCount.perform(Enum.at(System.argv(), 0))

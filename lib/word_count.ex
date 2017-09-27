defmodule WordCount do
  @moduledoc """
  Contains the logic for:

  - Fetching the document
  - Tokenising the document
  - Analysing the frequencies
  """

  @minimum_word_length 3

  def perform(url) do
    url
    |> fetch_document
    |> to_words
    |> to_occurrences
    |> print_count
    |> print_top_words
    |> print_histogram
  end

  def fetch_document(url) do
    HTTPoison.get!(url).body
  end

  @doc """
  ## Examples

      iex> WordCount.short_word?("long")
      false

      iex> WordCount.short_word?("s")
      true
  """
  def short_word?(word) do
    String.length(word) < @minimum_word_length
  end

  @doc """
  ## Examples

      iex> WordCount.normalize("I wouldn't take [those] odds!")
      "i wouldnt take those odds"

      iex> WordCount.normalize("\\"Do you know that man?\\" he said.")
      "do you know that man he said"
  """
  def normalize(text) do
    text
    |> String.downcase
    |> String.replace(~r/[\p{P}]/, "")
  end

  @doc """
  ## Examples

      iex> WordCount.to_words("Hello, John.\\nNice to see you again!\\n\\nWhere are you going today?")
      ["hello", "john", "nice", "see", "you", "again", "where", "are",
      "you", "going", "today"]
  """
  def to_words(text) do
    text
    |> normalize
    |> String.split(~r/\s/, trim: true)
    |> Enum.reject(&short_word?/1)
  end

  @doc """
  ## Examples

      iex> WordCount.to_occurrences(["a", "b", "x", "c", "x", "a", "x", "z", "z"])
      [{3, "x"}, {2, "z"}, {2, "a"}, {1, "c"}, {1, "b"}]
  """
  def to_occurrences(words) do
    words
    |> Enum.group_by(&(&1))
    |> Enum.map(fn ({word, occurrences}) ->
      {Enum.count(occurrences), word}
    end)
    |> Enum.sort
    |> Enum.reverse
  end

  def print_count(occurrences) do
    IO.puts("There are #{Enum.count(occurrences)} unique words having at least #{@minimum_word_length} letters.")
    occurrences
  end

  @doc """
  ## Examples

      iex> WordCount.find_longest_word_length([{0, "a"}, {0, "aa"}, {0, "aaa"}])
      3
  """
  def find_longest_word_length(occurrences) do
    occurrences
    |> Enum.map(fn ({_, word}) -> String.length(word) end)
    |> Enum.max
  end

  def print_top_words(occurrences) do
    number_of_words_to_display = 20
    IO.puts("The top #{number_of_words_to_display} words are as follows: <word> <occurrences>:")

    top_words = Enum.take(occurrences, number_of_words_to_display)
    top_words_max_length = find_longest_word_length(top_words)

    Enum.each(top_words, fn({count, word}) ->
      IO.puts("#{pad(word, top_words_max_length)} #{count}")
    end)
    occurrences
  end

  def print_histogram(occurrences) do
    number_of_words_to_display = 5
    IO.puts("The top #{number_of_words_to_display} words' distributions are as follows: <word> <frequency>:")

    top_words = Enum.take(occurrences, number_of_words_to_display)
    top_words_max_length = find_longest_word_length(top_words)

    distributions = calculate_distributions(top_words)
    Enum.each(distributions, fn({distribution, word}) ->
      IO.puts("#{pad(word, top_words_max_length)} #{distribution}")
    end)
    occurrences
  end

  @doc """
  ## Examples

      iex> WordCount.sum_occurrences([{3, ""}, {2, ""}, {1, ""}])
      6
  """
  def sum_occurrences(occurrences) do
    Enum.reduce(occurrences, 0, fn ({count, _}, sum) -> sum + count end)
  end

  @doc """
  ## Examples

      iex> WordCount.calculate_distributions([{7, "a"}, {2, "b"}, {1, "c"}])
      [{"|||||||", "a"}, {"||", "b"}, {"|", "c"}]
  """
  def calculate_distributions(occurrences) do
    total_occurrences = sum_occurrences(occurrences)
    Enum.map(occurrences, fn ({count, word}) ->
      relative_frequency = count / total_occurrences
      {String.duplicate("|", trunc(Float.round(relative_frequency * 10))), word}
    end)
  end

  @doc """
  ## Examples

      iex> WordCount.pad("a", 4)
      "   a"
  """
  def pad(word, max_word_length) do
    String.pad_leading(word, max_word_length)
  end
end

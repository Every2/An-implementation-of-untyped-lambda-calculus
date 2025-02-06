defmodule LambdaCalculus.Tokens do
  @type t ::
          :left_paren
          | :right_paren
          | :dot
          | :lambda
          | :variable

  def is_var(c), do: (c >= "a" && c <= "z") || (c >= "A" && c <= "Z")


  def new(c) do
    cond do
      is_var(c) -> :variable
      c == "\\" -> :lambda
      c == "(" -> :left_paren
      c == ")" -> :right_paren
      c == "." -> :dot
      true -> nil
    end
  end

  defimpl String.Chars, for: Tokens do
    def to_string(:left_paren), do: "Left Parenthesis"
    def to_string(:right_paren), do: "Right Parenthesis"
    def to_string(:dot), do: "Dot"
    def to_string(:lambda), do: "Lambda"
    def to_string(:variable), do: "Variable"
  end
end

defmodule LambdaCalculus.Lexer do
  def tokenizer(expr) do
    expr
    |> String.trim()
    |> String.graphemes()
    |> Enum.reduce_while([], fn c, acc ->
      case LambdaCalculus.Tokens.new(c) do
        nil -> {:halt, nil}
        token -> {:cont, [token | acc]}
      end
    end)
    |> case do
      nil -> nil
      tokens -> Enum.reverse(tokens)
    end
  end
end

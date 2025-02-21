defmodule LambdaCalculus.Tokens do
  @enforce_keys [:type, :lexeme]
  defstruct [:type, :lexeme]

  defp is_var(c), do: (c >= "a" && c <= "z") || (c >= "A" && c <= "Z")

  def new(c) do
    cond do
      is_var(c) -> %LambdaCalculus.Tokens{type: :variable, lexeme: c}
      c == "\\" -> %LambdaCalculus.Tokens{type: :lambda, lexeme: c}
      c == "(" -> %LambdaCalculus.Tokens{type: :left_paren, lexeme: c}
      c == ")" -> %LambdaCalculus.Tokens{type: :right_paren, lexeme: c}
      c == "." -> %LambdaCalculus.Tokens{type: :dot, lexeme: c}
      true -> nil
    end
  end

  defimpl String.Chars, for: LambdaCalculus.Tokens do
    def to_string(%LambdaCalculus.Tokens{type: type, lexeme: _lexeme}) do
      "#{type}"
    end
  end
end

defmodule LambdaCalculus.Lexer do
  alias LambdaCalculus.Tokens

  def tokenizer(expr) do
    expr
	|> String.replace(" ", "")
    |> String.graphemes()
    |> Enum.reduce_while([], fn c, acc ->
      case Tokens.new(c) do
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

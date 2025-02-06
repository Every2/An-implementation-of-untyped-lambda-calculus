defmodule LambdaCalculus do
  alias LambdaCalculus.Lexer, as: L
  alias LambdaCalculus.Parser, as: P

  def start do
    IO.puts("Welcome to Lambda Calculus REPL")

    loop()
  end

  defp loop do
    IO.write("> ")
    input = IO.gets("") |> String.trim()

    case L.tokenizer(input) do
      nil -> IO.puts("Invalid input.")
      tokens -> 
        print_tokens(tokens)
    end

	case P.parse(input) do
	  nil -> IO.puts("Não é um termo")
	  term -> IO.puts("É um termo")
	end

    loop()
  end

  defp print_tokens(tokens) do
    Enum.each(tokens, fn token ->
      IO.puts(to_string(token))
    end)
  end
end

LambdaCalculus.start()

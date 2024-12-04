defmodule LambdaCalculus do
  def main do
    run_prompt()
  end

  defp run_prompt do
    IO.puts("Welcome to Lambda Calculus REPL")
    loop()
  end

  defp loop do
    IO.write("> ")

    case IO.gets(" ") do
      :eof ->
        IO.puts("\nGoodBye!")

      nil ->
        IO.puts("No input detected, exiting...")

      input ->
        input
        |> String.trim()
        |> run()

        loop()
    end
  end

  defp run(source) do
    tokens = LambdaCalculus.Lexer.Scanner.tokenize(source)
    Enum.each(tokens, fn token ->
      IO.puts("#{token}")
    end)
  end
end

LambdaCalculus.main()

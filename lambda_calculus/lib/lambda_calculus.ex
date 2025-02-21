defmodule LambdaCalculus do
  alias LambdaCalculus.Parser, as: P
  alias LambdaCalculus.Op, as: O

  def start do
    IO.puts("Bem vindo ao REPL do cálculo λ")

    loop()
  end

  defp loop do
    IO.write("> ")
    input = IO.gets("") |> String.trim()

    case P.parse(input) do
      nil ->
        IO.puts("Não é um termo")

      term ->
        IO.puts("É um termo")
        IO.puts(O.exec(term))
    end

    loop()
  end
end

LambdaCalculus.start()

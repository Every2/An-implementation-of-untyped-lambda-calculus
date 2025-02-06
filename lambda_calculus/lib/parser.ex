defmodule LambdaCalculus.Parser do
  alias LambdaCalculus.Ast.{
    Variable,
    Abstraction,
    Application
  }

  alias LambdaCalculus.Tokens
  alias LambdaCalculus.Lexer

  def parse(expr) do
    token_vec = LambdaCalculus.Lexer.tokenizer(expr)
    parse_tokens(token_vec)
  end

  def parse_tokens(tvec) do
    cond do
      parse_var(tvec) != nil -> parse_var(tvec)
      parse_abstraction(tvec) != nil -> parse_abstraction(tvec)
      true -> nil
    end
  end

  def parse_var(tvec) do
    if length(tvec) == 1 do
      elem = Enum.at(tvec, 0)

      if elem == :variable do
        %Variable{name: elem}
      else
        nil
      end
    else
      nil
    end
  end

  def parse_abstraction(tvec) do
    cond do
      length(tvec) < 4 ->
        nil

      Enum.at(tvec, 0) != :left_paren or List.last(tvec) != :right_paren ->
        nil

      true ->
        if Enum.at(tvec, 1) == :lambda and Enum.at(tvec, 3) == :dot do
          lnode =
            case Enum.at(tvec, 2) do
              :variable -> %Variable{name: :variable}
              _ -> nil
            end

          slice = 4..(length(tvec) - 2) |> Enum.map(fn x -> Enum.at(tvec, x) end)
          rnode = parse_tokens(slice)

          if rnode != nil do
            %Abstraction{param: lnode, term: rnode}
          else
            nil
          end
        else
          nil
        end
    end
  end
end

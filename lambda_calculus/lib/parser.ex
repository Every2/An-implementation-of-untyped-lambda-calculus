defmodule LambdaCalculus.Parser do
  alias LambdaCalculus.Ast.{
    Variable,
    Abstraction,
    Application
  }

  def parse(expr) do
    token_vec = LambdaCalculus.Lexer.tokenizer(expr)
    parse_tokens(token_vec)
  end

  defp parse_tokens(tvec) do
    cond do
      parse_var(tvec) != nil -> parse_var(tvec)
      parse_abstraction(tvec) != nil -> parse_abstraction(tvec)
      parse_application(tvec) != nil -> parse_application(tvec)
      true -> nil
    end
  end

  defp parse_var(tvec) do
    if length(tvec) == 1 do
      elem = Enum.at(tvec, 0)

      if elem.type == :variable do
        %Variable{name: elem.lexeme}
      else
        nil
      end
    else
      nil
    end
  end

  defp parse_abstraction(tvec) do
    cond do
      length(tvec) < 4 ->
        nil

      Enum.at(tvec, 0).type != :left_paren or List.last(tvec).type != :right_paren ->
        nil

      true ->
        if Enum.at(tvec, 1).type == :lambda and Enum.at(tvec, 3).type == :dot do
          lnode =
            case Enum.at(tvec, 2).type do
              :variable -> %Variable{name: Enum.at(tvec, 2).lexeme}
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

  defp parse_application(tvec) do
    cond do
      Enum.at(tvec, 0).type != :left_paren or List.last(tvec).type != :right_paren ->
        nil

      true ->
        slice = 1..(length(tvec) - 1) |> Enum.map(fn x -> Enum.at(tvec, x) end)

        {pos, _, _} =
          Enum.reduce_while(slice, {1, 0, 0}, fn x, {i, lp, rp} ->
            new_lp =
              if x.type == :left_paren do
                lp + 1
              else
                lp
              end

            new_rp =
              if x.type == :right_paren do
                rp + 1
              else
                rp
              end

            if new_lp == new_rp do
              {:halt, {i + 1, new_lp, new_rp}}
            else
              {:cont, {i + 1, new_lp, new_rp}}
            end
          end)

        lslice = 1..(pos - 1) |> Enum.map(fn x -> Enum.at(tvec, x) end)
        lnode = parse_tokens(lslice)
        rslice = pos..(length(tvec) - 2) |> Enum.map(fn x -> Enum.at(tvec, x) end)
        rnode = parse_tokens(rslice)

        if lnode != nil and rnode != nil do
          %Application{lterm: lnode, rterm: rnode}
        else
          nil
        end
    end
  end
end

defmodule LambdaCalculus.Op do
  alias LambdaCalculus.Ast.{
    Variable,
    Abstraction,
    Application
  }

  def exec(term) do
    case term do
      %Variable{name: _} ->
        term

      %Abstraction{param: x, term: rterm} ->
        new_rterm = exec(rterm)
        %Abstraction{param: x, term: new_rterm}

      %Application{lterm: lterm, rterm: rterm} ->
        if is_redex?(term) do
          beta(term) |> exec()
        else
          new_lterm = exec(lterm)
          new_rterm = exec(rterm)
          new_term = %Application{lterm: new_lterm, rterm: new_rterm}

          if is_redex?(new_term) do
            exec(new_term)
          else
            new_term
          end
        end
    end
  end

  defp alpha(term, var) do
    case term do
      %Abstraction{param: x, term: rterm} ->
        if not is_free?(var, rterm) do
          %Abstraction{param: var, term: replace(rterm, x.name, var)}
        else
          term
        end

      _ ->
        term
    end
  end

  defp beta(term) do
    case term do
      %Application{lterm: lterm, rterm: rterm} ->
        case lterm do
          %Abstraction{param: x, term: nterm} -> replace(nterm, x.name, rterm)
          _ -> term
        end

      _ ->
        term
    end
  end

  defp is_free?(var, term) do
    case term do
      %Variable{name: x} ->
        x == var

      %Abstraction{param: x, term: rterm} ->
        if x.name == var do
          false
        else
          is_free?(var, rterm)
        end

      %Application{lterm: lterm, rterm: rterm} ->
        is_free?(var, lterm) or is_free?(var, rterm)
    end
  end

  defp replace(term, from, to) do
    case term do
      %Variable{name: x} ->
        if x == from do
          to
        else
          term
        end

      %Abstraction{param: x, term: rterm} ->
        cond do
          x.name == from ->
            term

          not is_free?(from, rterm) ->
            term

          not is_free?(x.name, to) ->
            %Abstraction{param: x, term: replace(rterm, from, to)}

          true ->
            new_x = get_var_for_alpha(term)
            replace(alpha(term, new_x), from, to)
        end

      %Application{lterm: lterm, rterm: rterm} ->
        %Application{lterm: replace(lterm, from, to), rterm: replace(rterm, from, to)}
    end
  end

  defp get_var_for_alpha(term) do
    case term do
      %Abstraction{param: x, term: _} ->
        Enum.reduce_while([?a..?z, ?A..?Z], "a", fn c, _var ->
          if not is_free?(c, term) and c != x.name do
            {:halt, c}
          end
        end)

      _ ->
        "a"
    end
  end

  defp is_redex?(term) do
    case term do
      %Application{lterm: lterm, rterm: _} ->
        case lterm do
          %Abstraction{param: _, term: _} -> true
          _ -> false
        end

      _ ->
        false
    end
  end
end

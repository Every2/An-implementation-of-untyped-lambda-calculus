defmodule LambdaCalculus.Ast.Abstraction do
  @enforce_keys [:param, :term]
  defstruct [:param, :term]
end

defimpl String.Chars, for: LambdaCalculus.Ast.Abstraction do
  def to_string(%LambdaCalculus.Ast.Abstraction{param: x, term: term}) do
    "(λ#{x}.#{term})"
  end
end

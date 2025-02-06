defmodule LambdaCalculus.Ast.Abstraction do
  @enforce_keys [:param, :term]
  defstruct [:param, :term]
end

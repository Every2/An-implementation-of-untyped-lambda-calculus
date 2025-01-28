defmodule LambdaCalculus.Ast.Abstraction do
  @enforce_keys [:term, :param]
  defstruct [:term, :param] 
end

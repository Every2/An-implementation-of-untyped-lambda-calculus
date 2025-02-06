defmodule LambdaCalculus.Ast.Application do
  @enforce_keys [:lterm, :rterm]
  defstruct [:lterm, :rterm]
end

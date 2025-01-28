defmodule LambdaCalculus.Ast.Application do
  @enforce_keys [:terms, :body]
  defstruct [:terms, :body] 
end

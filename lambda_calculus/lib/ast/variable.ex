defmodule LambdaCalculus.Ast.Variable  do
  @enforce_keys [:name]
  defstruct [:name] 
end

defimpl String.Chars, for: LambdaCalculus.Ast.Variable do
  def to_string(%LambdaCalculus.Ast.Variable{name: x}) do
    "#{x}"
  end
end

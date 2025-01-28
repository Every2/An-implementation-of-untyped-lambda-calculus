defmodule LambdaCalculus.Ast.Variable  do
  @enforce_keys [:name]
  defstruct [:name] 
end

defimpl String.Chars, for: Variable do
  def to_string(var) do
	"#{Kernel.to_string(var.token.lexeme)}"
  end
end

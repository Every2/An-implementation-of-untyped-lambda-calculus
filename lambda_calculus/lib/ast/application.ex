defmodule LambdaCalculus.Ast.Application do
  @enforce_keys [:lterm, :rterm]
  defstruct [:lterm, :rterm]
end

defimpl String.Chars, for: LambdaCalculus.Ast.Application do
  def to_string(%LambdaCalculus.Ast.Application{lterm: lterm, rterm: rterm}) do
    "(#{lterm} #{rterm})"
  end
end

defmodule BananaBank.Accounts do
  alias BananaBank.Accounts.Create

  # Users.Create chama o Modulo Create na funcao call
  defdelegate create(params), to: Create, as: :call
end

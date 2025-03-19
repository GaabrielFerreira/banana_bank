defmodule BananaBank.Users.Delete do
  alias BananaBank.Users.User
  alias BananaBank.Repo

  def call(%{"id" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end

  def call(_), do: {:error, :bad_request}
end

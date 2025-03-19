defmodule BananaBankWeb.AccountsController do
  use BananaBankWeb, :controller

  alias BananaBank.Accounts
  alias Accounts.Account

  action_fallback BananaBankWeb.FallbackController

  def create(conn, params) do
    with ({:ok, %Account{} = account} <- Accounts.create(params)) do
      conn
      |> put_status(:created) #created = status 201
      |> render(:create, account: account)
    end
  end
end

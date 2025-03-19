defmodule BananaBankWeb.WelcomeController do
  use BananaBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(200) #200, mesma coisa que status: :ok
    |> json(%{message: "Bem vindo ao Banana Bank"})
  end
end

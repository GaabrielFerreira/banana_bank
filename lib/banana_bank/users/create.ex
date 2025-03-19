defmodule BananaBank.Users.Create do
  alias BananaBank.Users.User
  alias BananaBank.Repo
  alias BananaBank.ViaCep.Client, as: ViaCepClient

  def call(%{"cep" => cep} = params) do
    # Se sucesso na validacao do cep, cria user
    with {:ok, _result} <- client().call(cep) do
      # Se tiver erro, chama o fallbackcontroller p tratar
      params
      |> User.changeset()
      |> Repo.insert()
    end
  end

  defp client() do
    Application.get_env(:banana_bank, :via_cep_client, ViaCepClient)
  end
end

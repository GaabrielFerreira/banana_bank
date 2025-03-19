defmodule BananaBank.ViaCep.ClientBehaviour do
  @callback call(String.t()) :: {:ok, map()} | {:error, :atom} #Retorna :ok e map ou :error e atom
end

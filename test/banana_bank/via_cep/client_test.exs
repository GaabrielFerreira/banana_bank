defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      cep = "18087180"

      body = ~s({
        "bairro": "Aparecidinha",
        "cep": "18087-180",
        "complemento": "",
        "ddd":"15",
        "estado": "São Paulo",
        "gia": "6695",
        "ibge": "3552205",
        "localidade": "Sorocaba",
        "logradouro": "Avenida Três de Março",
        "regiao": "Sudeste",
        "siafi": "7145",
        "uf": "SP",
        "unidade": ""
      })

      expected_response =
        {:ok,
         %{
           "bairro" => "Aparecidinha",
           "cep" => "18087-180",
           "complemento" => "",
           "ddd" => "15",
           "estado" => "São Paulo",
           "gia" => "6695",
           "ibge" => "3552205",
           "localidade" => "Sorocaba",
           "logradouro" => "Avenida Três de Março",
           "regiao" => "Sudeste",
           "siafi" => "7145",
           "uf" => "SP",
           "unidade" => ""
         }}

      Bypass.expect(bypass, "GET", "/18087180/json", fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(cep)

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end

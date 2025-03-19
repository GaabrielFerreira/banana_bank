defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users
  alias Users.User

  setup do
    params = %{
      "name" => "Joao",
      "cep" => "18087180",
      "email" => "joao@frutas.com",
      "password" => "123456"
    }

    body = %{
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
    }
    {:ok, %{user_params: params, body: body}}
  end

  describe "create/2" do
    test "successfully creates an user", %{conn: conn, body: body, user_params: params} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "18087180" ->
        {:ok, body}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
               "data" => %{"cep" => "18087180", "email" => "joao@frutas.com", "id" => _id, "name" => "Joao"},
               "message" => "User created with successful"
             } = response
    end

    test "where there are invalid params, returns an error", %{conn: conn} do
      params = %{
        name: nil,
        cep: "12",
        email: "joao@frutas.com",
        password: "123"
      }

      expect(BananaBank.ViaCep.ClientMock, :call, fn "12" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{
        "error" => %{
          "cep" => ["should be 8 character(s)"],
          "name" => ["can't be blank"],
          "password" => ["should be at least 6 character(s)"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn, body: body, user_params: params} do
      expect(BananaBank.ViaCep.ClientMock, :call, fn "18087180" ->
        {:ok, body}
      end)

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{
        "data" => %{"cep" => "18087180", "email" => "joao@frutas.com", "id" => id, "name" => "Joao"},
        "message" => "User deleted with successful"
      }

      assert response == expected_response
    end
  end
end

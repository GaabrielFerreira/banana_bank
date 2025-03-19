defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias BananaBank.Accounts.Account

  @required_params_create [:name, :password, :email, :cep]
  @required_params_update [:name, :email, :cep]

  # @derive {Jason.Encoder, except: [:__meta__]} #Schema pode ser encodado em jason, apenas o nome (, only [:name])
  # tbm podendo ser (, except [__meta__]) exibe tudo menos __meta__, remove usersjson data()
  schema "users" do
    field :name, :string
    # virtual: true significa que nao existe no banco de dados
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :cep, :string
    has_one :account, Account

    timestamps()
  end

  # Mapeamento e validacao de dados do usuario
  # (CREATE) se receber struct vazia, executa esse changeset
  def changeset(params) do
    # Inicia com uma struct vazia
    %__MODULE__{}
    |> cast(params, @required_params_create)
    # rq_params_create como field para do_validations
    |> do_validations(@required_params_create)
    |> add_password_hash()
  end

  # (UPDATE) se receber struct com dados, executa esse changeset
  def changeset(user, params) do
    user
    # Utilizar rq_parms_create para fazer o cast caso tbm receba o password no update
    |> cast(params, @required_params_create)
    # rq_params_update como field para do_validations
    |> do_validations(@required_params_update)
    |> add_password_hash()
  end

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    # Nome precisa ter no minimo 3 caracteres
    |> validate_length(:name, min: 3)
    # Email precisa ter @
    |> validate_format(:email, ~r/@/)
    # Senha precisa ter no minimo 6 caracteres
    |> validate_length(:password, min: 6)
    # Cep precisa ter 8 caracteres
    |> validate_length(:cep, is: 8)
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    password_hash = Argon2.hash_pwd_salt(password)
    # Retorna o password criptrografado
    change(changeset, %{password_hash: password_hash})
  end

  # Se o changeset for invalido retorna para nao salvar um erro
  defp add_password_hash(changeset), do: changeset
end

defmodule Client.Factory do
  use ExMachina.Ecto, repo: Client.Repo

  def user_factory(attrs) do
    pw = Map.get(attrs, :password, "password123")
    {:ok, pw_hash} = Auth.hash_password(pw)

    user = %Client.User{
      email: sequence(:email, &"email-#{&1}@t.co"),
      password: pw,
      password_hash: pw_hash
    }

    merge_attributes(user, attrs)
  end

  def api_token_factory do
    %Client.ApiTokens.ApiToken{
      token: Client.ApiTokens.ApiToken.gen_token(),
      description: sequence(:description, &"description-#{&1}"),
      user_id: insert(:user).id
    }
  end

  def food_log_factory do
    %Client.FoodLogs.FoodLog{
      name: sequence(:food_log, &"food-log-#{&1}"),
      owner_id: integer()
    }
  end

  def food_log_entry_factory do
    %Client.FoodLogs.Entry{
      description: sequence(:description, &"food-item-#{&1}"),
      user_id: integer(),
      food_log_id: uuid(),
      occurred_at: DateTime.utc_now()
    }
  end

  def water_log_factory do
    %Client.WaterLogs.WaterLog{
      name: sequence(:name, &"water log #{&1}"),
      user_id: integer()
    }
  end

  def water_log_entry_factory do
    %Client.WaterLogs.Entry{
      ml: integer(),
      user_id: integer(),
      water_log_id: uuid()
    }
  end

  def water_log_filter_factory do
    %Client.WaterLogs.Filter{
      water_log_id: insert(:water_log).id
    }
  end

  defp integer, do: System.unique_integer([:positive])
  defp uuid, do: Ecto.UUID.generate()
end

defmodule Twitch.Auth do
  @scope "chat:read chat:edit channel:moderate user:read:email"

  def authorize_url do
    query =
      %{
        client_id: client_id(),
        redirect_uri: redirect_uri(),
        response_type: "code",
        scope: @scope
      }
      |> URI.encode_query()

    uri =
      %URI{
        host: "id.twitch.tv",
        query: query,
        scheme: "https",
        path: "/oauth2/authorize"
      }
      |> URI.to_string()

    {:ok, uri}
  end

  def exchange(code) do
    query = %{
      client_id: client_id(),
      client_secret: client_secret(),
      redirect_uri: redirect_uri(),
      grant_type: "authorization_code",
      code: code
    }

    headers = [
      {"Accept", "application/json"}
    ]

    response =
      HTTPoison.post(
        "https://id.twitch.tv/oauth2/token",
        "",
        headers,
        params: query
      )

    IO.inspect(response)

    response |> parse_response
  end

  def current_user(access_token \\ "8yrp2vl7kwikrc5edi5qiefbgqn0k5") do
    with {:ok, json} <- Twitch.Auth.twitch_connection(access_token, :get, "/helix/users"),
         do:
           (
             %{"data" => [user]} = json
             {:ok, user}
           ),
         else:
           (
             {:error, reason} -> {:error, reason}
             _ -> {:error, "Failed to fetch user"}
           )
  end

  def twitch_connection(access_token, method, path, opts \\ []) do
    default_opts = [body: "", headers: []]
    options = Keyword.merge(opts, default_opts) |> Enum.into(%{})
    %{body: body, headers: user_headers} = options

    persistent_headers = [
      {"Authorization", "Bearer #{access_token}"},
      {"Accept", "application/json"}
    ]

    headers = user_headers ++ persistent_headers

    url = Twitch.Auth.base_url() |> URI.merge(path) |> URI.to_string()

    case method do
      :get -> HTTPoison |> apply(method, [url, headers]) |> Twitch.Auth.parse_response()
      _ -> HTTPoison |> apply(method, [url, body, headers]) |> Twitch.Auth.parse_response()
    end
  end

  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = body |> Poison.decode()
        # TODO: Also confirm scope?
        {:ok, decoded}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, "#{status_code}: #{body}"}

      _ ->
        {:error, "nope"}
    end
  end

  def client_id do
    Application.get_env(:twitch, :oauth)[:client_id]
  end

  def client_secret do
    Application.get_env(:twitch, :oauth)[:client_secret]
  end

  def redirect_uri do
    Application.get_env(:twitch, :oauth)[:redirect_uri]
  end

  def base_url do
    "https://api.twitch.tv/helix"
  end
end
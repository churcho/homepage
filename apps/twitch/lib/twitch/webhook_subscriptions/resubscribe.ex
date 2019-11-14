defmodule Twitch.WebhookSubscriptions.Resubscribe do
  alias Twitch.WebhookSubscriptions
  alias Twitch.WebhookSubscriptions.Query

  def perform do
    Enum.each(subs_expiring_soon(), &resubscribe_to/1)
  end

  defp resubscribe_to(sub) do

  end

  defp subs_expiring_soon do
    yesterday = Timex.now() |> Timex.shift(days: -1)

    Subscription
    |> Query.by_resubscribe(true)
    |> Query.expires_between(yesterday, DateTime.utc_now())
    |> Twitch.Repo.all()
  end
end

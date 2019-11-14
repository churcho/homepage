defmodule Twitch.WebhookSubscriptions.Query do
  import Ecto.Query, only: [from: 2]

  def by_user_id(query, user_id) do
    from(sub in query, where: sub.user_id == ^user_id)
  end

  def by_topic(query, topic) do
    from(sub in query, where: sub.topic == ^topic)
  end

  def by_resubscribe(query, resubscribe) do
    from(sub in query, where: sub.resubscribe == ^resubscribe)
  end

  def expires_between(query, start_time, end_time) do
    from(sub in query,
      where: sub.expires_at > ^start_time,
      where: sub.expires_at < ^end_time
    )
  end
end

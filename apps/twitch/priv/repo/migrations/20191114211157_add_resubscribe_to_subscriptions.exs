defmodule Twitch.Repo.Migrations.AddResubscribeToSubscriptions do
  use Ecto.Migration

  def change do
    alter(table(:webhook_subscriptions)) do
      add(:resubscribe, :boolean, default: true)
    end
  end
end

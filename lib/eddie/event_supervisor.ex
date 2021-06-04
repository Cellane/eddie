defmodule Eddie.EventSupervisor do
  def process("follow", event) do
    Task.Supervisor.start_child(__MODULE__, Eddie.LINE.Handler.Follow, :follow, [event])
  end

  def process("unfollow", event) do
    Task.Supervisor.start_child(__MODULE__, Eddie.LINE.Handler.Follow, :unfollow, [event])
  end

  def process(_, _), do: nil
end

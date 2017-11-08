defmodule Chat.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  `{:ok, socket}` to authorize subscription for channel for requested topic

  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  # def join("rooms:lobby", message, socket) do
  #   Process.flag(:trap_exit, true)
  #   :timer.send_interval(5000, :ping)
  #   send(self(), {:after_join, message})

  #   {:ok, socket}
  # end

  def join("rooms:" <> chat_id, message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping)
    send(self(), {:after_join, message})
    {:ok, assign(socket, :chat_id, chat_id)}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end
  def handle_info(:ping, socket) do
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
    payload = txt_msg_payload(msg["body"], msg["user"], socket.assigns.chat_id) 
    broadcast! socket, "new:msg", payload
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

  defp txt_msg_payload(txt_message, chat_id, user_id) do
    current_timestamp = Calendar.DateTime.now_utc |> Calendar.DateTime.Format.iso8601

    %{ id: Ecto.UUID.generate(),
       chat_id: chat_id, 
       parts: [
          %{ mime_type: "text/plain", body: txt_message }
       ],
       user_id: user_id, 
       inserted_at: current_timestamp, 
       updated_at: current_timestamp 
    }
  end
end

defmodule Bombero.MessageHandlerTest do
  use BomberoCase

  alias Bombero.MessageHandler, as: Subject
  alias Bombero.{Game, TestMessenger}

  test "start game postback" do
    Subject.handle(start_game_message)
    game = Bombero.Game.find(sender.id)
    assert game

    assert sent_message.text == "Sample text"
    assert sent_message.options == ["Option 1", "Option 2"]
  end

  test "option postbacks" do
    {:ok, game} = Game.start(sender.id)

    Subject.handle(option_1_message)
    assert Game.state(game) == :set_2
    assert sent_message.text == "Sample text for set 2"
    assert sent_message.options == ["Set 2: Option 1", "Set 2: Option 2", "Set 2: Option 3"]
  end


  defp option_1_message do
    postback_message("OPTION_1")
  end

  defp sent_message do
    TestMessenger.button_messages |> List.first()
  end

  defp start_game_message do
    postback_message("START_GAME")
  end

  defp postback_message(payload) do
    %{sender: sender,
      postback: %{
        payload: payload
      }
    }
  end

  defp sender do
    %{id: 123456}
  end
end

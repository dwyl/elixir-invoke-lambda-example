defmodule AppWeb.InvokeLambdaControllerTest do
  use ExUnit.Case

  test "Invoke the aws-ses-lambda-v1 Lambda Function!" do
    payload = %{
      name: "Elixir Lover",
      email: System.get_env("RECIPIENT_EMAIL_ADDRESS"),
      template: "welcome",
      id: "1"
    }

    {:ok, response} = AppWeb.InvokeLambdaController.invoke(payload)
    # IO.inspect(response, label: "response")
    message_id = Map.get(response, "message_id")
    assert String.length(message_id) == 60
  end
end

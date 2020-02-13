defmodule AppWeb.InvokeLambdaControllerTest do
  use ExUnit.Case

  test "Invoke the aws-ses-lambda-v1 Lambda Function!" do
    payload = %{
      name: "Elixir Lover",
      email: System.get_env("RECIPIENT_EMAIL_ADDRESS"),
      template: "welcome"
    }

    {:ok, %{"MessageId" => mid}} = AppWeb.InvokeLambdaController.invoke(payload)
    # IO.inspect mid, label: "MessageId"
    assert String.length(mid) == 60
  end
end

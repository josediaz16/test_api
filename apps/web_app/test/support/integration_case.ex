defmodule WebApp.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use WebApp.ConnCase
      use PhoenixIntegration
    end
  end
end

defmodule Checkout.Application do
  @moduledoc """
  The Checkout Application Service.

  The checkout system business domain lives in this application.

  Exposes API to clients such as the `CheckoutWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Checkout.Repo, []),
      worker(Cachex, [Checkout.Cart, []]),
    ], strategy: :one_for_one, name: Checkout.Supervisor)
  end
end

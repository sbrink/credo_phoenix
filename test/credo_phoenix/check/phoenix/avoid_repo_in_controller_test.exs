defmodule CredoEcto.Check.Ecto.HasManyOnDeleteTest do
  use Credo.Test.Case

  alias CredoPhoenix.Check.Phoenix.AvoidRepoInController

  test "does report warning when repo used in controller" do
    """
    defmodule MyAppWeb.DemoController do
      alias MyApp.Repo

      def index(conn, params) do
        Repo.all()
        html(conn, "Hello")
      end
    end
    """
    |> to_source_file
    |> run_check(AvoidRepoInController)
    |> assert_issue()
  end

  test "does not report warning when repo not used in controller" do
    """
    defmodule MyAppWeb.DemoController do
      def index(conn, params) do
        html(conn, "Hello")
      end
    end
    """
    |> to_source_file
    |> run_check(AvoidRepoInController)
    |> refute_issues()
  end

  test "does not report warning when repo used in non-controller" do
    """
    defmodule MyApp.Core.User do
      def all() do
        User
        |> Repo.all()
      end
    end
    """
    |> to_source_file
    |> run_check(AvoidRepoInController)
    |> refute_issues()
  end
end

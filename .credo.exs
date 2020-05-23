%{
  configs: [
    %{
      name: "default",
      checks: [
        {CredoPhoenix.Check.Phoenix.AvoidRepoInController, []}
      ]
    }
  ]
}

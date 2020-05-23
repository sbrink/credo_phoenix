defmodule CredoPhoenix.Check.Phoenix.AvoidRepoInController do
  @moduledoc false

  use Credo.Check,
    base_priority: :high,
    tags: [:phoenix],
    explanations: [
      check: """
      Checks if ecto schema has set on_delete for has_many associatons.
      """
    ]

  def param_defaults, do: [repo: "Repo"]

  alias Credo.Code

  @doc false
  def run(source_file, params \\ []) do
    # IO.inspect(source_file.filename)
    repo = Params.get(params, :repo, __MODULE__)
    # IO.inspect(params)
    # IO.inspect(repo)

    issue_meta = IssueMeta.for(source_file, params)
    Code.prewalk(source_file, &traverse(&1, &2, issue_meta))
  end

  # Private functions
  defp traverse({:defmodule, _meta, [mod_ast | _]} = ast, issues, issue_meta) do
    module_name = Macro.to_string(mod_ast)

    if String.ends_with?(module_name, "Controller") do
      issues = Credo.Code.prewalk(ast, &traverse_children(&1, &2, issue_meta))
      {ast, issues}
    else
      {ast, issues}
    end
  end

  defp traverse(ast, issues, _), do: {ast, issues}

  defp traverse_children({:., _, [{:__aliases__, meta, [:Repo]}, _fn_name]} = ast, issues, issue_meta) do
    trigger = ""
    issues = [issue_for(issue_meta, meta[:line], trigger) | issues]
    {ast, issues}
  end

  defp traverse_children(ast, issues, _issue_meta) do
    {ast, issues}
  end

  defp issue_for(issue_meta, line_no, trigger) do
    format_issue(issue_meta,
      message: "Should not use Repo in Controller directly. Use a context.",
      trigger: trigger,
      line_no: line_no
    )
  end
end

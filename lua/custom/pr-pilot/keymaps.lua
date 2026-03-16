local M = {}

function M.setup(cfg)
  local commands = require("custom.pr-pilot.commands")

  vim.keymap.set("n", "<leader>prc", function()
    commands.pr_create(nil)
  end, { noremap = true, silent = true, desc = "PR: Create issue + PR" })

  vim.keymap.set("n", "<leader>pri", function()
    commands.pr_issue(nil)
  end, { noremap = true, silent = true, desc = "PR: Create issue only" })

  vim.keymap.set("n", "<leader>prr", function()
    commands.pr_only(nil)
  end, { noremap = true, silent = true, desc = "PR: Create PR only" })

  vim.keymap.set("n", "<leader>prp", function()
    commands.pr_preview(nil)
  end, { noremap = true, silent = true, desc = "PR: Preview (dry-run)" })

  vim.keymap.set("n", "<leader>prd", function()
    commands.pr_diff()
  end, { noremap = true, silent = true, desc = "PR: Show git diff" })

  vim.keymap.set("n", "<leader>prs", function()
    commands.pr_search(nil)
  end, { noremap = true, silent = true, desc = "PR: Search Jira tickets" })
end

return M

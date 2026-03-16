local M = {}

M.config = {
  binary_path = "pr-pilot",
  env_file = vim.fn.stdpath("config") .. "/.env",
  keymaps = true,
  base_branch = "origin/dev",
  jira_project = vim.env.JIRA_PROJECT or "",
  float_opts = {
    width_ratio = 0.8,
    height_ratio = 0.7,
  },
}

local function load_env_file(path)
  local f = io.open(path, "r")
  if not f then return end
  for line in f:lines() do
    local key, value = line:match("^([%w_]+)=(.+)$")
    if key then
      value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
      vim.env[key] = value
    end
  end
  f:close()
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  load_env_file(M.config.env_file)
  require("custom.pr-pilot.commands").setup(M.config)
  if M.config.keymaps then
    require("custom.pr-pilot.keymaps").setup(M.config)
  end
end

return M

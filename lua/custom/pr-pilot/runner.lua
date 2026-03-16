local M = {}

local function get_binary(cfg)
  return (cfg and cfg.binary_path) or "pr-pilot"
end

function M.run(args, cfg, callback)
  local binary = get_binary(cfg)
  local cmd = { binary }
  for _, arg in ipairs(args) do
    table.insert(cmd, arg)
  end

  local stdout_data = {}
  local stderr_data = {}

  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(stdout_data, line)
        end
      end
    end,
    on_stderr = function(_, data)
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(stderr_data, line)
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        local err = table.concat(stderr_data, "\n")
        if err == "" then err = "pr-pilot exited with code " .. code end
        callback(nil, err)
        return
      end
      local output = table.concat(stdout_data, "\n")
      local ok, parsed = pcall(vim.json.decode, output)
      if ok then
        callback(parsed, nil)
      else
        callback(output, nil)
      end
    end,
  })
end

function M.run_sync(args, cfg)
  local binary = get_binary(cfg)
  -- Use table form to avoid shell injection from args with special chars
  local cmd = { binary }
  for _, arg in ipairs(args) do
    table.insert(cmd, arg)
  end
  return vim.fn.system(cmd)
end

return M

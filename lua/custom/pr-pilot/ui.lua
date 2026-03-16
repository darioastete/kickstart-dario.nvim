local M = {}

local function calc_size(ratio_w, ratio_h)
  local width = math.floor(vim.o.columns * ratio_w)
  local height = math.floor(vim.o.lines * ratio_h)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  return width, height, row, col
end

function M.open_float(content, opts)
  opts = opts or {}
  local width_ratio = opts.width_ratio or 0.8
  local height_ratio = opts.height_ratio or 0.7
  local width, height, row, col = calc_size(width_ratio, height_ratio)

  local buf = vim.api.nvim_create_buf(false, true)
  local lines = type(content) == "string" and vim.split(content, "\n") or content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = opts.filetype or "markdown"
  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = opts.title or " PR Pilot ",
    title_pos = "center",
  })

  local close = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  vim.keymap.set("n", "q", close, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, noremap = true, silent = true })

  if opts.on_confirm then
    vim.keymap.set("n", "<CR>", function()
      close()
      opts.on_confirm()
    end, { buffer = buf, noremap = true, silent = true })
  end

  return buf, win, close
end

function M.show_progress(steps)
  local lines = { " PR Pilot — Progress", "" }
  for _, step in ipairs(steps) do
    table.insert(lines, "  ☐ " .. step)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 50
  local height = #lines + 2
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Progress ",
    title_pos = "center",
  })

  local close = function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  local update = function(step_index, done, failed)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    vim.bo[buf].modifiable = true
    local icon = done and "✓" or (failed and "✗" or "◌")
    local line = lines[step_index + 2]
    if line then
      lines[step_index + 2] = "  " .. icon .. " " .. steps[step_index]
      vim.api.nvim_buf_set_lines(buf, step_index + 1, step_index + 2, false, { lines[step_index + 2] })
    end
    vim.bo[buf].modifiable = false
  end

  return { close = close, update = update, buf = buf, win = win }
end

function M.confirm(message, on_yes)
  local lines = { "", "  " .. message, "", "  [y] Yes    [n] No / <Esc> Cancel", "" }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local width = math.max(50, #message + 6)
  local height = #lines
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Confirm ",
    title_pos = "center",
  })

  local close = function()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  vim.keymap.set("n", "y", function() close(); on_yes() end, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<CR>", function() close(); on_yes() end, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "n", close, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "q", close, { buffer = buf, noremap = true, silent = true })
end

return M

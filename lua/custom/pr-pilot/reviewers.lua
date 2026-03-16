local M = {}
local ui = require("custom.pr-pilot.ui")

function M.select_reviewers(reviewers_list, callback)
  if not reviewers_list or #reviewers_list == 0 then
    callback({})
    return
  end

  local selected = {}
  local lines = { " Select reviewers (Space to toggle, Enter to confirm):", "" }
  for _, r in ipairs(reviewers_list) do
    table.insert(lines, "  [ ] " .. r)
    selected[r] = false
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 50
  local height = #lines + 2
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
    title = " Reviewers ",
    title_pos = "center",
  })

  -- Start cursor on first reviewer
  vim.api.nvim_win_set_cursor(win, { 3, 0 })

  local close = function()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  local toggle = function()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line_idx = cursor[1]
    local reviewer_idx = line_idx - 2
    if reviewer_idx < 1 or reviewer_idx > #reviewers_list then return end

    local reviewer = reviewers_list[reviewer_idx]
    selected[reviewer] = not selected[reviewer]

    vim.bo[buf].modifiable = true
    local mark = selected[reviewer] and "[x]" or "[ ]"
    local new_line = "  " .. mark .. " " .. reviewer
    vim.api.nvim_buf_set_lines(buf, line_idx - 1, line_idx, false, { new_line })
    vim.bo[buf].modifiable = false
  end

  local confirm = function()
    local result = {}
    for _, r in ipairs(reviewers_list) do
      if selected[r] then
        table.insert(result, r)
      end
    end
    close()
    callback(result)
  end

  vim.keymap.set("n", "<Space>", toggle, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Tab>", toggle, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<CR>", confirm, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "q", close, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, noremap = true, silent = true })
end

return M

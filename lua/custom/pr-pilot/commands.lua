local M = {}
local runner = require 'custom.pr-pilot.runner'
local ui = require 'custom.pr-pilot.ui'

local config = {}

local function get_current_branch()
  return vim.trim(vim.fn.system 'git branch --show-current')
end

local function show_result(result)
  local lines = {}
  if type(result) == 'table' then
    table.insert(lines, '## PR Pilot — Done!')
    table.insert(lines, '')
    if result.ticket then
      table.insert(lines, '**Ticket:** [' .. result.ticket.key .. '](' .. result.ticket.url .. ') — ' .. result.ticket.summary)
    end
    if result.issue and result.issue.url ~= '' then
      table.insert(lines, '**Issue:** #' .. result.issue.number .. ' ' .. result.issue.url)
    end
    if result.pr and result.pr.url ~= '' then
      table.insert(lines, '**PR:** #' .. result.pr.number .. ' ' .. result.pr.url)
    end
    if result.diff_stat and result.diff_stat ~= '' then
      table.insert(lines, '')
      table.insert(lines, '**Diff:** ' .. result.diff_stat)
    end
  else
    for _, line in ipairs(vim.split(tostring(result), '\n')) do
      table.insert(lines, line)
    end
  end
  ui.open_float(lines, { title = ' PR Pilot — Done ' })
end

local function ask_ticket(callback)
  local ok, fzf = pcall(require, 'fzf-lua')
  if not ok then
    vim.ui.input({ prompt = 'Jira Ticket ID: ' }, function(input)
      if input and input ~= '' then
        callback(input)
      end
    end)
    return
  end

  local project = (config and config.jira_project) or ''
  local binary = (config and config.binary_path) or 'pr-pilot'

  local function launch(proj)
    fzf.fzf_live(function(query)
      if type(query) == 'table' then
        query = query[1]
      end
      if not query or #query < 2 then
        return {}
      end
      local cmd = string.format('%s search %s --project %s --json 2>/dev/null', vim.fn.shellescape(binary), vim.fn.shellescape(query), vim.fn.shellescape(proj))
      local handle = io.popen(cmd)
      if not handle then
        return {}
      end
      local output = handle:read '*a'
      handle:close()
      local parsed_ok, tickets = pcall(vim.json.decode, output)
      local items = {}
      if parsed_ok and type(tickets) == 'table' then
        for i, t in ipairs(tickets) do
          if i > 20 then
            break
          end
          local status = t.status and (' [' .. t.status .. ']') or ''
          table.insert(items, t.key .. status .. '  ' .. (t.summary or ''))
        end
      end
      return items
    end, {
      prompt = 'Jira> ',
      winopts = { title = ' Buscar Ticket Jira ', title_pos = 'center' },
      actions = {
        ['default'] = function(selected)
          if not selected or #selected == 0 then
            return
          end
          local key = selected[1]:match '^(%S+)'
          if key then
            callback(key)
          end
        end,
      },
    })
  end

  if project ~= '' then
    launch(project)
  else
    vim.ui.input({ prompt = 'Jira project key (ej. HVACAI): ' }, function(proj)
      if proj and proj ~= '' then
        launch(proj)
      end
    end)
  end
end

local function ask_repo(callback)
  local repo = (config and config.repo) or ''
  if repo ~= '' then
    callback(repo)
    return
  end
  local repos = config and type(config.repos) == 'table' and #config.repos > 0 and config.repos
  if repos then
    local ok, fzf = pcall(require, 'fzf-lua')
    if ok then
      fzf.fzf_exec(repos, {
        prompt = 'Repo> ',
        winopts = { title = ' Select Repository ', title_pos = 'center' },
        actions = {
          ['default'] = function(selected)
            if selected and selected[1] then
              callback(selected[1])
            end
          end,
        },
      })
    else
      vim.ui.select(repos, { prompt = 'GitHub repo:' }, function(choice)
        if choice then
          callback(choice)
        end
      end)
    end
    return
  end
  vim.ui.input({ prompt = 'GitHub repo (owner/repo): ' }, function(input)
    if input and input ~= '' then
      callback(input)
    end
  end)
end

-- :PRCreate [ticket-id] — full flow: issue + PR
function M.pr_create(ticket_id)
  if not ticket_id or ticket_id == '' then
    ask_ticket(M.pr_create)
    return
  end

  local branch = get_current_branch()
  if branch == '' then
    vim.notify('pr-pilot: could not detect current git branch', vim.log.levels.ERROR)
    return
  end

  ask_repo(function(repo)
    local progress = ui.show_progress {
      'Fetching Jira ticket...',
      'Generating product requirement with Claude...',
      'Getting diff...',
      'Creating GitHub issue...',
      'Creating PR...',
    }

    local args = { 'create', ticket_id, '--branch', branch, '--repo', repo, '--json' }
    runner.run(args, config, function(result, err)
      vim.schedule(function()
        progress.close()
        if err then
          vim.notify('pr-pilot error: ' .. err, vim.log.levels.ERROR)
          return
        end
        show_result(result)
      end)
    end)
  end)
end

-- :PRIssue [ticket-id] — create only the GitHub issue
function M.pr_issue(ticket_id)
  if not ticket_id or ticket_id == '' then
    ask_ticket(M.pr_issue)
    return
  end

  ask_repo(function(repo)
    local progress = ui.show_progress {
      'Fetching Jira ticket...',
      'Generating product requirement with Claude...',
      'Creating GitHub issue...',
    }

    local args = { 'issue', ticket_id, '--repo', repo, '--json' }
    runner.run(args, config, function(result, err)
      vim.schedule(function()
        progress.close()
        if err then
          vim.notify('pr-pilot error: ' .. err, vim.log.levels.ERROR)
          return
        end
        show_result(result)
      end)
    end)
  end)
end

-- :PRPR [ticket-id] — create only the PR (requires existing issue number)
function M.pr_only(ticket_id)
  if not ticket_id or ticket_id == '' then
    ask_ticket(M.pr_only)
    return
  end

  local branch = get_current_branch()
  if branch == '' then
    vim.notify('pr-pilot: could not detect current git branch', vim.log.levels.ERROR)
    return
  end

  vim.ui.input({ prompt = 'GitHub issue number: ' }, function(issue_num)
    if not issue_num or issue_num == '' then
      return
    end

    ask_repo(function(repo)
      local progress = ui.show_progress {
        'Fetching Jira ticket...',
        'Generating product requirement with Claude...',
        'Getting diff...',
        'Creating PR...',
      }

      local args = { 'pr', ticket_id, '--branch', branch, '--issue', issue_num, '--repo', repo, '--json' }
      runner.run(args, config, function(result, err)
        vim.schedule(function()
          progress.close()
          if err then
            vim.notify('pr-pilot error: ' .. err, vim.log.levels.ERROR)
            return
          end
          show_result(result)
        end)
      end)
    end)
  end)
end

-- :PRPreview [ticket-id] — dry-run preview
function M.pr_preview(ticket_id)
  if not ticket_id or ticket_id == '' then
    ask_ticket(M.pr_preview)
    return
  end

  local branch = get_current_branch()
  if branch == '' then
    vim.notify('pr-pilot: could not detect current git branch', vim.log.levels.ERROR)
    return
  end

  ask_repo(function(repo)
    local args = { 'preview', ticket_id, '--branch', branch, '--repo', repo, '--json' }
    runner.run(args, config, function(result, err)
      vim.schedule(function()
        if err then
          vim.notify('pr-pilot error: ' .. err, vim.log.levels.ERROR)
          return
        end

        local content
        if type(result) == 'table' and result.bdd then
          content = '# Preview: [' .. ticket_id .. ']\n\n## Product Requirement\n\n' .. result.bdd
          if result.diff_stat and result.diff_stat ~= '' then
            content = content .. '\n\n## Diff Summary\n\n' .. result.diff_stat
          end
        else
          content = tostring(result)
        end

        ui.open_float(content, {
          title = ' PR Preview — <CR> to create ',
          on_confirm = function()
            M.pr_create(ticket_id)
          end,
        })
      end)
    end)
  end)
end

-- :PRSearch [query] — search Jira tickets and pick one to act on
function M.pr_search(query)
  local function run_search(q, project)
    local args = { 'search', q, '--project', project, '--json' }
    runner.run(args, config, function(result, err)
      vim.schedule(function()
        if err then
          vim.notify('pr-pilot search error: ' .. err, vim.log.levels.ERROR)
          return
        end
        local tickets = type(result) == 'table' and result or {}
        if #tickets == 0 then
          vim.notify("pr-pilot: no tickets found for '" .. q .. "'", vim.log.levels.WARN)
          return
        end
        vim.ui.select(tickets, {
          prompt = 'Jira tickets (' .. project .. '):',
          format_item = function(t)
            local status = t.status and (' [' .. t.status .. ']') or ''
            return t.key .. status .. ' — ' .. (t.summary or '')
          end,
        }, function(choice)
          if not choice then
            return
          end
          vim.ui.select(
            { 'Create issue only', 'Create issue + PR', 'Create PR only', 'Preview (dry-run)' },
            { prompt = 'Acción para ' .. choice.key .. ':' },
            function(action)
              if not action then
                return
              end
              if action == 'Create issue only' then
                M.pr_issue(choice.key)
              elseif action == 'Create issue + PR' then
                M.pr_create(choice.key)
              elseif action == 'Create PR only' then
                M.pr_only(choice.key)
              elseif action == 'Preview (dry-run)' then
                M.pr_preview(choice.key)
              end
            end
          )
        end)
      end)
    end)
  end

  local function ask_project_then_search(q)
    local project = (config and config.jira_project) or ''
    if project ~= '' then
      run_search(q, project)
    else
      vim.ui.input({ prompt = 'Jira project key (e.g. HVACAI): ' }, function(proj)
        if proj and proj ~= '' then
          run_search(q, proj)
        end
      end)
    end
  end

  if query and query ~= '' then
    ask_project_then_search(query)
  else
    vim.ui.input({ prompt = 'Buscar tickets Jira: ' }, function(input)
      if input and input ~= '' then
        ask_project_then_search(input)
      end
    end)
  end
end

-- :PRDiff — show git diff in float window
function M.pr_diff()
  local branch = get_current_branch()
  if branch == '' then
    vim.notify('pr-pilot: could not detect current git branch', vim.log.levels.ERROR)
    return
  end

  local base = (config.base_branch or 'origin/dev')
  -- Use table form to avoid shell injection from branch names with special chars
  local diff_output = vim.fn.system { 'git', 'diff', base .. '..' .. branch }
  if diff_output == '' then
    local base_local = base:gsub('^origin/', '')
    diff_output = vim.fn.system { 'git', 'diff', base_local .. '..' .. branch }
  end
  if diff_output == '' then
    diff_output = '(no diff available)'
  end

  ui.open_float(diff_output, { title = ' Git Diff ', filetype = 'diff' })
end

function M.setup(cfg)
  config = cfg or {}

  vim.api.nvim_create_user_command('PRCreate', function(opts)
    M.pr_create(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?', desc = 'Create GitHub issue + PR from Jira ticket' })

  vim.api.nvim_create_user_command('PRIssue', function(opts)
    M.pr_issue(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?', desc = 'Create only GitHub issue from Jira ticket' })

  vim.api.nvim_create_user_command('PRPR', function(opts)
    M.pr_only(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?', desc = 'Create only PR (links to existing issue)' })

  vim.api.nvim_create_user_command('PRPreview', function(opts)
    M.pr_preview(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?', desc = 'Preview PR from Jira ticket (dry-run)' })

  vim.api.nvim_create_user_command('PRDiff', function()
    M.pr_diff()
  end, { nargs = 0, desc = 'Show git diff in float window' })

  vim.api.nvim_create_user_command('PRSearch', function(opts)
    M.pr_search(opts.args ~= '' and opts.args or nil)
  end, { nargs = '?', desc = 'Search Jira tickets and create issue/PR' })
end

return M

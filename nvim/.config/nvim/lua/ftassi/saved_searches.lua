local M = {}

local function data_dir()
  return vim.fn.stdpath 'data' .. '/saved_searches'
end

local function search_path(name)
  return data_dir() .. '/' .. name .. '.json'
end

function M.save()
  local qflist = vim.fn.getqflist { all = 1 }
  if #qflist.items == 0 then
    vim.notify('Quickfix list is empty', vim.log.levels.WARN, { title = 'Saved Searches' })
    return
  end
  vim.ui.input({ prompt = 'Save search as: ' }, function(name)
    if not name or name == '' then return end
    vim.fn.mkdir(data_dir(), 'p')
    local file = io.open(search_path(name), 'w')
    if file then
      file:write(vim.json.encode(qflist))
      file:close()
      vim.notify('Saved: ' .. name, vim.log.levels.INFO, { title = 'Saved Searches' })
    end
  end)
end

function M.restore(name)
  local file = io.open(search_path(name), 'r')
  if not file then
    vim.notify('Search not found: ' .. name, vim.log.levels.ERROR, { title = 'Saved Searches' })
    return
  end
  local json = file:read '*a'
  file:close()
  local data = vim.json.decode(json)
  vim.fn.setqflist({}, 'r', data)
  vim.cmd 'copen'
end

function M.find()
  local dir = data_dir()
  local files = vim.fn.glob(dir .. '/*.json', false, true)
  if #files == 0 then
    vim.notify('No saved searches', vim.log.levels.INFO, { title = 'Saved Searches' })
    return
  end
  local names = vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ':t:r')
  end, files)

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers.new({}, {
    prompt_title = 'Saved Searches',
    finder = finders.new_table { results = names },
    sorter = conf.generic_sorter {},
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        M.restore(action_state.get_selected_entry()[1])
      end)
      map({ 'i', 'n' }, '<C-d>', function()
        local name = action_state.get_selected_entry()[1]
        os.remove(search_path(name))
        vim.notify('Deleted: ' .. name, vim.log.levels.INFO, { title = 'Saved Searches' })
        actions.close(prompt_bufnr)
        vim.schedule(function()
          local remaining = vim.fn.glob(data_dir() .. '/*.json', false, true)
          if #remaining > 0 then M.find() end
        end)
      end)
      return true
    end,
  }):find()
end

return M

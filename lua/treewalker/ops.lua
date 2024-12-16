local util = require('treewalker.util')
local nodes = require('treewalker.nodes')
local lines = require('treewalker.lines')

---@param row integer
---@param line string
---@param candidate TSNode
---@return nil
local function log(row, line, candidate)
  local col = lines.get_start_col(line)
  util.log(
    "dest: [L " ..
    row .. ", I " .. col .. "] |" .. line .. "| [" .. candidate:type() .. "]" .. vim.inspect(nodes.range(candidate))
  )
end

local M = {}

---Flash a highlight over the given range
---@param range Range4
---@param duration integer
function M.highlight(range, duration)
  local start_row, start_col, end_row, end_col = range[1], range[2], range[3], range[4]
  local ns_id = vim.api.nvim_create_namespace("")
  -- local hl_group = "DiffAdd"
  -- local hl_group = "MatchParen"
  -- local hl_group = "Search"
  local hl_group = "ColorColumn"


  for row = start_row, end_row do
    if row == start_row and row == end_row then
      -- Highlight within the same line
      vim.api.nvim_buf_add_highlight(0, ns_id, hl_group, start_row, start_col, end_col)
    elseif row == start_row then
      -- Highlight from start_col to the end of the start_row
      vim.api.nvim_buf_add_highlight(0, ns_id, hl_group, start_row, start_col, -1)
    elseif row == end_row then
      -- Highlight from the beginning of the end_row to end_col
      vim.api.nvim_buf_add_highlight(0, ns_id, hl_group, end_row, 0, end_col)
    else
      -- Highlight the entire row for intermediate rows
      vim.api.nvim_buf_add_highlight(0, ns_id, hl_group, row, 0, -1)
    end
  end

  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end, duration)
end

---@param row integer
---@param node TSNode
function M.jump(row, node)
  -- local line = lines.get_line(row)
  -- log(row, line, node)
  vim.api.nvim_win_set_cursor(0, { row, 0 })
  vim.cmd('normal! ^')
  local highlight = require("treewalker").opts.highlight
  if highlight and highlight ~= 0 then
    node = nodes.get_highest_coincident(node)
    M.highlight(nodes.range(node), highlight ~= true and highlight or 250)
  end
end

return M

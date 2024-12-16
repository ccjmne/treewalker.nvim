local util = require "treewalker.util"
local load_fixture = require "tests.load_fixture"
local spy = require 'luassert.spy'
local assert = require "luassert"
local treewalker = require 'treewalker'
local ops = require 'treewalker.ops'

describe("Treewalker highlighting", function()
  local highlight_spy = spy.on(ops, "highlight")
  local bufclear_spy = spy.on(vim.api, "nvim_buf_clear_namespace")

  -- use with rows as they're numbered in vim lines (1-indexed)
  local function assert_highlighted(srow, scol, erow, ecol, desc)
    assert.same(
      { srow - 1, scol - 1, erow - 1, ecol },
      highlight_spy.calls[1].refs[1],
      "highlight wrong for: " .. desc
    )
  end

  describe("regular lua file: ", function()
    load_fixture("/lua.lua", "lua")

    before_each(function()
      treewalker.setup({ highlight = true })
      highlight_spy = spy.on(ops, "highlight")
      bufclear_spy = spy.on(vim.api, "nvim_buf_clear_namespace")
    end)

    it("respects highlight config option", function()
      vim.wait(250 + 5) -- wait out potential "buf_clear" calls queue up from previous tests

      -- 'nvim_buf_clear_namespace' should be called <calls> times
      -- within a 10ms tolerance window after <timeout>ms
      local function assert_bufclears_after(timeout, calls)
        bufclear_spy:clear()
        vim.wait(timeout - 5)
        assert.spy(bufclear_spy).was.not_called()
        vim.wait(10)
        assert.spy(bufclear_spy).was.called(calls)
      end

      highlight_spy:clear()
      treewalker.setup() -- highlight defaults to true, doesn't blow up with empty setup
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.spy(highlight_spy).was.called(4)
      assert_bufclears_after(250, 4)

      highlight_spy:clear()
      treewalker.setup({ highlight = 0 })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.spy(highlight_spy).was.not_called()

      highlight_spy:clear()
      treewalker.setup({ highlight = false })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.spy(highlight_spy).was.not_called()

      highlight_spy:clear()
      treewalker.setup({ highlight = true })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.spy(highlight_spy).was.called(4)
      assert_bufclears_after(250, 4)

      highlight_spy:clear()
      treewalker.setup({ highlight = 50 })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.spy(highlight_spy).was.called(4)
      assert_bufclears_after(50, 4)

      highlight_spy:clear()
      treewalker.setup({ highlight = 500 })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.spy(highlight_spy).was.called(4)
      assert_bufclears_after(500, 4)
    end)

    it("highlights whole functions", function()
      vim.fn.cursor(10, 1)
      treewalker.move_down()
      assert_highlighted(21, 1, 28, 3, "is_jump_target function")
    end)

    it("highlights whole lines starting with identifiers", function()
      vim.fn.cursor(134, 5)
      treewalker.move_up()
      assert_highlighted(133, 5, 133, 33, "table.insert call")
    end)

    it("highlights whole lines starting assignments", function()
      vim.fn.cursor(133, 5)
      treewalker.move_down()
      assert_highlighted(134, 5, 134, 18, "child = iter()")
    end)

    -- Note this is highly language dependent, so this test is not so powerful
    it("doesn't highlight the whole file", function()
      vim.fn.cursor(3, 1)
      treewalker.move_up()
      assert_highlighted(1, 1, 1, 39, "first line")
    end)

    -- Also very language dependent
    it("highlights only the first item in a block", function()
      vim.fn.cursor(27, 3)
      treewalker.move_up()
      assert_highlighted(22, 3, 26, 5, "child = iter()")
    end)
  end)
end)

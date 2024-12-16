local util = require "treewalker.util"
local load_fixture = require "tests.load_fixture"
local stub = require 'luassert.stub'
local assert = require "luassert"
local treewalker = require 'treewalker'
local ops = require 'treewalker.ops'

describe("Treewalker highlighting", function()
  local highlight_stub = stub(ops, "highlight")

  -- use with rows as they're numbered in vim lines (1-indexed)
  local function assert_highlighted(srow, scol, erow, ecol, desc)
    assert.same(
      { srow - 1, scol - 1, erow - 1, ecol },
      highlight_stub.calls[1].refs[1],
      "highlight wrong for: " .. desc
    )
  end

  describe("regular lua file: ", function()
    load_fixture("/lua.lua", "lua")

    before_each(function()
      treewalker.setup({ highlight = true })
      highlight_stub = stub(ops, "highlight")
    end)

    it("respects highlight config option", function()
      treewalker.setup() -- highlight defaults to true, doesn't blow up with empty setup
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.equal(4, #highlight_stub.calls)

      highlight_stub = stub(ops, "highlight")
      treewalker.setup({ highlight = false })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.equal(0, #highlight_stub.calls)

      highlight_stub = stub(ops, "highlight")
      treewalker.setup({ highlight = true })
      vim.fn.cursor(23, 5)
      treewalker.move_out()
      treewalker.move_down()
      treewalker.move_up()
      treewalker.move_in()
      assert.equal(4, #highlight_stub.calls)
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

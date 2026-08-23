local repo = assert(vim.env.DOTFILES_REPO, "DOTFILES_REPO is required")
local temporary_dir = vim.fn.tempname()
local original_path = vim.env.PATH

local function assert_equal(actual, expected, message)
  if actual ~= expected then
    error(("%s\nexpected: %s\nactual: %s"):format(message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function run(command, cwd)
  local result = vim.system(command, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    error(("command failed: %s\n%s"):format(table.concat(command, " "), result.stderr or result.stdout or ""))
  end
end

package.path = repo .. "/neovim/.config/nvim/lua/?.lua;" .. package.path
local git = require("utils.git")

local function fx_response(output, exit_code, err)
  return vim.json.encode({
    error = err,
    exit_code = exit_code,
    model = "gpt-5.6-luna",
    output = output,
    session_id = "",
    steps = 0,
    tool_calls = {},
  })
end

local function prepare_workspace(name, fx_output, exit_code)
  local workspace = temporary_dir .. "/" .. name .. "-workspace"
  local bin_dir = temporary_dir .. "/" .. name .. "-bin"
  vim.fn.mkdir(workspace, "p")
  vim.fn.mkdir(bin_dir, "p")

  local fx = bin_dir .. "/fx"
  vim.fn.writefile({
    "#!/bin/sh",
    [[test "$FX_MODEL" = "gpt-5.6-luna" || exit 10]],
    [[test "$FX_PERMISSION_MODE" = "ask" || exit 11]],
    [[test "$FX_MAX_AGENT_STEPS" = "1" || exit 12]],
    [[test "$1" = "ask" || exit 13]],
    [[test "$2" = "--json" || exit 14]],
    [[test "$3" = "--no-save" || exit 15]],
    [[case "$4" in]],
    [[  *"Describe the primary behavior change across the entire diff"*) ;;]],
    [[  *) exit 16 ;;]],
    [[esac]],
    [[case "$4" in]],
    [[  *"Treat tests and verification as supporting changes unless they are the only changes"*) ;;]],
    [[  *) exit 17 ;;]],
    [[esac]],
    ("printf '%%s\\n' '%s'"):format(fx_output),
    ("exit %d"):format(exit_code),
  }, fx)
  vim.fn.setfperm(fx, "rwxr-xr-x")
  vim.env.PATH = bin_dir .. ":" .. original_path

  run({ "git", "init", "--quiet" }, workspace)
  vim.fn.writefile({ "staged change" }, workspace .. "/change.txt")
  run({ "git", "add", "change.txt" }, workspace)
  vim.fn.chdir(workspace)
end

local function generate_commit_message()
  local finished = false
  local success
  local message

  git.generate_commit_msg({
    callback = function(callback_success, callback_message)
      success = callback_success
      message = callback_message
      finished = true
    end,
  })

  assert(vim.wait(5000, function()
    return finished
  end), "commit message generation timed out")
  return success, message
end

local function test_generates_message_with_fx()
  prepare_workspace("success", fx_response("fix(test): use fx", 0), 0)

  local success, message = generate_commit_message()
  assert_equal(success, true, "fx should generate a commit message")
  assert_equal(message, "fix(test): use fx", "fx output should become the commit message")
end

local function test_reports_fx_failure()
  prepare_workspace("failure", fx_response("", 1, "authentication expired"), 1)

  local success, message = generate_commit_message()
  assert_equal(success, false, "fx failure should fail commit message generation")
  assert_equal(message, "Failed to generate commit message: authentication expired", "fx error should be reported")
end

local function test_rejects_explanatory_fx_output()
  prepare_workspace("prose", fx_response("Here is the message:\nfix(test): use fx", 0), 0)

  local success, message = generate_commit_message()
  assert_equal(success, false, "explanatory fx output should be rejected")
  assert_equal(
    message,
    "Failed to extract commit message: response must be exactly one Conventional Commit subject",
    "invalid output should explain the one-line requirement"
  )
end

local function run_tests()
  test_generates_message_with_fx()
  test_reports_fx_failure()
  test_rejects_explanatory_fx_output()
end

local ok, err = xpcall(run_tests, debug.traceback)
vim.env.PATH = original_path
vim.fn.delete(temporary_dir, "rf")

if not ok then
  error(err)
end

print("Neovim git tests passed.")

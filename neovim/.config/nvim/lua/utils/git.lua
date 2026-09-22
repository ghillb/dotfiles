local M = {}

function M.is_git_work_tree()
  local result = vim.system({ "git", "rev-parse", "--is-inside-work-tree" }):wait()
  return result.code == 0
end

function M.get_git_work_tree_path()
  local result = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
  return ""
end

function M.review_changes()
  local git_root = vim.fs.root(0, ".git")
  if not git_root then
    vim.notify("Current file is not in a Git repository", vim.log.levels.WARN, { title = "Difit" })
    return
  end

  vim.system({ "difit", ".", "--include-untracked" }, {
    cwd = git_root,
    detach = true,
    text = true,
  }, function(result)
    if result.code == 0 then
      return
    end

    local message = vim.trim(result.stderr or "")
    if message == "" then
      message = ("Difit exited with code %d"):format(result.code)
    end
    vim.schedule(function()
      vim.notify(message, vim.log.levels.ERROR, { title = "Difit" })
    end)
  end)
end

local VALID_TYPES =
  { feat = 1, fix = 1, refactor = 1, perf = 1, docs = 1, style = 1, test = 1, build = 1, ci = 1, chore = 1 }
local INVALID_COMMIT_RESPONSE = "response must be exactly one Conventional Commit subject"
local COMMIT_SCOPE = "%([a-z0-9._/%-]+%)"
local COMMIT_PATTERNS = {
  "^([a-z]+)" .. COMMIT_SCOPE .. "!: %S[^%c]*$",
  "^([a-z]+)" .. COMMIT_SCOPE .. ": %S[^%c]*$",
  "^([a-z]+)!: %S[^%c]*$",
  "^([a-z]+): %S[^%c]*$",
}

local function extract_commit_msg(raw_output)
  if type(raw_output) ~= "string" then
    return nil, INVALID_COMMIT_RESPONSE
  end

  local commit_msg = vim.trim(raw_output)
  if commit_msg == "" or commit_msg:find("\n", 1, true) or #commit_msg >= 50 or commit_msg:sub(-1) == "." then
    return nil, INVALID_COMMIT_RESPONSE
  end

  for _, pattern in ipairs(COMMIT_PATTERNS) do
    local msg_type = commit_msg:match(pattern)
    if msg_type and VALID_TYPES[msg_type] then
      return commit_msg
    end
  end

  return nil, INVALID_COMMIT_RESPONSE
end

local function truncate_diff_simple(diff, max_total_chars)
  if string.len(diff) <= max_total_chars then
    return diff
  end

  local MAX_CHARS_PER_FILE = 500
  local files = {}
  local current_file = {}
  local lines = vim.split(diff, "\n", { plain = true })

  for _, line in ipairs(lines) do
    if line:match("^diff %-%-git") and #current_file > 0 then
      table.insert(files, table.concat(current_file, "\n"))
      current_file = { line }
    else
      table.insert(current_file, line)
    end
  end
  if #current_file > 0 then
    table.insert(files, table.concat(current_file, "\n"))
  end

  local result = {}
  local total_chars = 0
  local truncated_files = 0

  for _, file_diff in ipairs(files) do
    if total_chars >= max_total_chars then
      break
    end

    local remaining_budget = max_total_chars - total_chars
    local file_limit = math.min(MAX_CHARS_PER_FILE, remaining_budget)

    if string.len(file_diff) <= file_limit then
      table.insert(result, file_diff)
      total_chars = total_chars + string.len(file_diff)
    else
      table.insert(result, file_diff:sub(1, file_limit))
      total_chars = total_chars + file_limit
      truncated_files = truncated_files + 1
    end
  end

  local truncated_diff = table.concat(result, "\n\n")
  if truncated_files > 0 or #files > #result then
    local omitted_files = #files - #result
    truncated_diff = truncated_diff
      .. string.format(
        "\n\n[... %d files truncated, %d files omitted due to size limits]",
        truncated_files,
        omitted_files
      )
  end

  return truncated_diff
end

function M.generate_commit_msg(opts)
  opts = opts or {}

  local git_root_result = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
  local git_root

  if git_root_result.code ~= 0 then
    if opts.callback then
      opts.callback(false, "Failed to find git repository. Are you in a git repository?")
    end
    return
  end

  git_root = vim.trim(git_root_result.stdout)
  local diff_command = { "git", "diff", "--staged", "--no-color" }
  if opts.amend then
    table.insert(diff_command, "HEAD^")
  end

  local diff_result = vim
    .system(diff_command, {
      cwd = git_root,
      text = true,
      timeout = 30000,
    })
    :wait()

  if diff_result.code ~= 0 then
    if opts.callback then
      opts.callback(false, "Failed to get git diff. Are you in a git repository?")
    end
    return
  end

  local diff = diff_result.stdout
  if diff == nil or diff:match("^%s*$") then
    if opts.callback then
      opts.callback(false, "No staged changes found. Stage some changes first with 'git add'")
    end
    return
  end

  local has_precommit = vim.fn.executable("pre-commit") == 1
  local has_precommit_config = vim.fn.filereadable(git_root .. "/.pre-commit-config.yaml") == 1
    or vim.fn.filereadable(git_root .. "/.pre-commit-config.yml") == 1

  if has_precommit and has_precommit_config then
    local git_dir_result = vim
      .system({ "git", "rev-parse", "--git-dir" }, {
        cwd = git_root,
        text = true,
      })
      :wait()

    local hooks_installed = false
    if git_dir_result.code == 0 then
      local git_dir = vim.trim(git_dir_result.stdout)
      if not vim.startswith(git_dir, "/") then
        git_dir = git_root .. "/" .. git_dir
      end
      hooks_installed = vim.fn.filereadable(git_dir .. "/hooks/pre-commit") == 1
    end

    if not hooks_installed then
      vim.notify(
        "Pre-commit config found but hooks not installed. Skipping pre-commit checks. Run: pre-commit install",
        vim.log.levels.WARN
      )
    else
      vim.notify("Running pre-commit hooks...", vim.log.levels.INFO)

      local precommit_result = vim
        .system({ "pre-commit", "run" }, {
          cwd = git_root,
          text = true,
          timeout = 120000,
          env = { PRE_COMMIT_NO_CONCURRENCY = "1" },
        })
        :wait()

      if precommit_result.code == 1 then
        vim.notify("Pre-commit output:\n" .. (precommit_result.stdout or ""), vim.log.levels.INFO)
        if opts.callback then
          opts.callback(false, "Pre-commit checks failed. Please review.")
        end
        return
      elseif precommit_result.code ~= 0 then
        if opts.callback then
          opts.callback(
            false,
            "Pre-commit hooks failed: " .. (precommit_result.stderr or precommit_result.stdout or "Unknown error")
          )
        end
        return
      end

      diff_result = vim
        .system(diff_command, {
          cwd = git_root,
          text = true,
          timeout = 30000,
        })
        :wait()

      if diff_result.code ~= 0 or not diff_result.stdout or diff_result.stdout:match("^%s*$") then
        if opts.callback then
          opts.callback(false, "No staged changes after pre-commit. Files may have been unstaged.")
        end
        return
      end
      diff = diff_result.stdout
    end
  end

  local MAX_DIFF_CHARS = 15000
  local processed_diff = truncate_diff_simple(diff, MAX_DIFF_CHARS)

  local target = opts.amend and "the complete commit being amended" or "the staged changes"
  local prompt = "Generate one Conventional Commit subject for " .. target .. ".\n\n"
    .. "RULES:\n"
    .. "- Describe the primary behavior change across the entire diff\n"
    .. "- Treat tests and verification as supporting changes unless they are the only changes\n"
    .. "- Format: type(scope): description OR type: description\n"
    .. "- Types: feat|fix|refactor|perf|docs|style|test|build|ci|chore\n"
    .. "- Use an imperative, lowercase description with no trailing period\n"
    .. "- Keep the complete subject under 50 characters\n"
    .. "- Reply with exactly one subject line and no Markdown\n\n"
    .. "DIFF:\n"
    .. processed_diff

  local fx_env = {
    FX_MAX_AGENT_STEPS = "1",
    FX_MODEL = "gpt-5.6-luna",
    FX_PERMISSION_MODE = "ask",
  }

  if vim.fn.executable("fx") ~= 1 then
    if opts.callback then
      opts.callback(false, "Agent executable not found.")
    end
    return
  end

  local cmd = { "fx", "ask", "--json", "--no-save", prompt }

  vim.system(cmd, { text = true, timeout = 60000, env = fx_env }, function(result)
    vim.schedule(function()
      local decoded_ok, response = pcall(vim.json.decode, result.stdout)

      if result.code ~= 0 or (decoded_ok and type(response) == "table" and response.exit_code ~= 0) then
        local detail = decoded_ok and type(response) == "table" and response.error or nil
        if type(detail) ~= "string" or detail:match("^%s*$") then
          detail = vim.trim(result.stderr or "")
        end

        if opts.callback then
          local message = "Failed to generate commit message. Make sure AI is available."
          if detail ~= "" then
            message = "Failed to generate commit message: " .. detail
          end
          opts.callback(false, message)
        end
        return
      end

      if
        not decoded_ok
        or type(response) ~= "table"
        or response.exit_code ~= 0
        or type(response.output) ~= "string"
      then
        if opts.callback then
          opts.callback(false, "Failed to decode the agent response.")
        end
        return
      end

      local commit_msg, err = extract_commit_msg(response.output)
      if not commit_msg then
        if opts.callback then
          opts.callback(false, "Failed to extract commit message: " .. (err or "unknown error"))
        end
        return
      end

      if opts.commit then
        local commit_result = vim
          .system({ "git", "commit", "-m", commit_msg }, {
            cwd = git_root,
            text = true,
          })
          :wait()

        if commit_result.code ~= 0 then
          if opts.callback then
            opts.callback(false, "Commit failed: " .. (commit_result.stderr or commit_result.stdout or "Unknown error"))
          end
        else
          if opts.callback then
            opts.callback(true, "Committed successfully!")
          end
        end
      else
        if opts.callback then
          opts.callback(true, commit_msg)
        end
      end
    end)
  end)
end

return M

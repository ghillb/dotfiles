	vim.wo.fcs = "eob: "
	vim.cmd("autocmd BufUnload <buffer> call timer_start(1, { tid -> execute('lua SetRoot(\"git_worktree\")')})")


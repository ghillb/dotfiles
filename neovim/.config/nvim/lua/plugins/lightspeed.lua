local packer_opts = {
  "ggandor/lightspeed.nvim",
  requires = { "tpope/vim-repeat" },
  config = function()
    if vim.env.NVIM_INIT then return end
    local lightspeed = require("lightspeed")

    lightspeed.setup({
      jump_to_unique_chars = { safety_timeout = 400 },
      exit_after_idle_msecs = { labeled = 1500, unlabeled = 1000 },
      match_only_the_start_of_same_char_seqs = true,
      limit_ft_matches = 4,
      substitute_chars = { ["\r"] = "¬" },
      instant_repeat_fwd_key = nil,
      instant_repeat_bwd_key = nil,
      -- If no values are given, these will be set at runtime,
      -- based on `jump_to_first_match`.
      labels = nil,
      cycle_group_fwd_key = nil,
      cycle_group_bwd_key = nil,
    })
  end,
}
return packer_opts

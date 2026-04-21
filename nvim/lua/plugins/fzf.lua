return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    local config = require("fzf-lua").config
    config.defaults.keymap.fzf["ctrl-j"] = "down"
    config.defaults.keymap.fzf["ctrl-k"] = "up"
    return opts
  end,
}

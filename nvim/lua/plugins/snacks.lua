return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["O"] = "pick_win",
              },
            },
          },
        },
      },
    },
  },
}

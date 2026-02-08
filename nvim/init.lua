-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- Learn more about Neovim lua api
-- https://neovim.io/doc/user/lua-guide.html
-- https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/

vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')

vim.lsp.config('ty', {
  settings = {
    ty = {
      -- ty language server settings
    }
  }
})
vim.lsp.enable('ty')

vim.lsp.config('ruff', {
  settings = {
  }
})
vim.lsp.enable('ruff')

vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.signcolumn = 'yes'
vim.o.winborder = 'rounded'

-- Space as leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local mini = {}

mini.branch = 'main'
mini.packpath = vim.fn.stdpath('data') .. '/site'

function mini.require_deps()
  local mini_path = mini.packpath .. '/pack/deps/start/mini.nvim'

  if not vim.uv.fs_stat(mini_path) then
    print('Installing mini.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/nvim-mini/mini.nvim',
      string.format('--branch=%s', mini.branch),
      mini_path
    })

    vim.cmd('packadd mini.nvim | helptags ALL')
  end

  local ok, deps = pcall(require, 'mini.deps')
  if not ok then
    return {}
  end

  return deps
end

local MiniDeps = mini.require_deps()
if not MiniDeps.setup then
  return
end

-- See :help MiniDeps.config
MiniDeps.setup({
  path = {
    package = mini.packpath,
  },
})

MiniDeps.add('folke/tokyonight.nvim')
MiniDeps.add('bluz71/vim-moonfly-colors')
MiniDeps.add('miikanissi/modus-themes.nvim')
MiniDeps.add('slugbyte/lackluster.nvim')
MiniDeps.add('github/copilot.vim')
MiniDeps.add('NickvanDyke/opencode.nvim')
MiniDeps.add('romus204/referencer.nvim')
MiniDeps.add('Dan7h3x/signup.nvim')
MiniDeps.add('folke/snacks.nvim')
MiniDeps.add('folke/which-key.nvim')
MiniDeps.add('VonHeikemen/ts-enable.nvim')
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('onsails/lspkind.nvim')
MiniDeps.add('nvim-tree/nvim-web-devicons')
MiniDeps.add('MunifTanjim/nui.nvim')

MiniDeps.add('lewis6991/gitsigns.nvim')
MiniDeps.add('stevearc/aerial.nvim')
MiniDeps.add({
  source = 'nvim-neo-tree/neo-tree.nvim',
  checkout = 'main',
})
MiniDeps.add({
  source = 'nvim-mini/mini.nvim',
  checkout = mini.branch,
})
MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = {
    post_checkout = function()
      vim.cmd.TSUpdate()
    end,
  },
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

-- See :help opencode.nvim
vim.g.opencode_opts = {
  provider = {
    enabled = "snacks",
  },
}

-- Required for `opts.events.reload`.
vim.o.autoread = true

-- Modus themes configuration (default theme)
local modusThemes = require('modus-themes')
modusThemes.setup({
  style = 'modus_vivendi',
  transparent = false,
  dim_inactive = false,
  line_nr_column_background = false,
  sign_column_background = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
    variables = {},
  },
  on_colors = function(colors)
    colors.bg_main = '#121212'
    colors.bg_dim = '#1a1a1a'
    colors.bg_status_line_active = '#2a2a2a'
    colors.comment = '#989898'
    colors.fg_inactive = '#bfc0c4'
  end,
})

-- Apply modus theme by default
vim.cmd('colorscheme modus')

-- Recommended/example keymaps.
vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })
vim.keymap.set({ "n", "t" }, "<leader>.", function() require("opencode").toggle() end,                         { desc = "Toggle opencode" })

vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })

-- See :help MiniIcons.config
-- Change style to 'glyph' if you have a font with fancy icons
require('mini.icons').setup({style = 'ascii'})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniNotify.config
require('mini.notify').setup({
  lsp_progress = {enable = false},
})

-- Aerial setup (code outline)
require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end,
})
vim.keymap.set('n', '<leader>fm', '<cmd>AerialToggle!<CR>', {desc = 'Toggle code outline'})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})

-- Snacks configuration
require('snacks').setup({
  input = {},
  picker = {},
  terminal = {},
})

-- Toggle file explorer (neo-tree)
vim.keymap.set('n', '<leader>e', '<cmd>Neotree filesystem toggle<CR>', {desc = 'File explorer'})
vim.keymap.set('n', '<leader>gg', '<cmd>Neotree git_status toggle<CR>', {desc = 'Git status'})

-- Git diff
vim.keymap.set('n', '<leader>gd', '<cmd>Gitsigns diffthis<CR>', {desc = 'Git diff this'})

-- See :help MiniPick.config
require('mini.pick').setup({})

-- See available pickers
-- :help MiniPick.builtin
-- :help MiniExtra.pickers
vim.keymap.set('n', '<leader>?', '<cmd>Pick oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Pick diagnostic<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Pick buf_lines<cr>', {desc = 'Buffer local search'})

-- See :help MiniStatusline.config
require('mini.statusline').setup({})

-- See :help MiniExtra
require('mini.extra').setup({})

-- See :help MiniSnippets.config
require('mini.snippets').setup({})

-- See :help MiniCompletion.config
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
  },
  mappings = {
    force_twostep = '<C-x>',
    force_fallback = '<A-e>',
  },
})

-- Accept completion with Shift+Tab - copilot takes priority
-- For LSP completion, use <C-y>
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("<CR>")', { expr = true, silent = true, desc = 'Copilot accept' })

-- See :help which-key.nvim-which-key-setup
require('which-key').setup({
  icons = {
    mappings = false,
    keys = {
      Space = 'Space',
      Esc = 'Esc',
      BS = 'Backspace',
      C = 'Ctrl-',
    },
  },
})

require('referencer').setup({
  enable = true,
  format = ' [%d ref]',
  show_no_reference = false,
  kinds = {5, 6, 8, 12, 13, 14, 23},
  hl_group = 'Comment',
  virt_text_pos = 'eol',
})

require('signup').setup({
  silent = true,
  active_parameter = true,
  active_parameter_colors = {
    bg = '#86e1fc',
    fg = '#1a1a1a',
  },
  border = 'rounded',
  winblend = 10,
  auto_close = true,
  trigger_chars = {'(', ',', ')'},
  max_height = 10,
  max_width = 40,
  floating_window_above_cur_line = true,
  debounce_time = 50,
})

require('which-key').add({
  {'<leader>f', group = 'Fuzzy Find'},
  {'<leader>b', group = 'Buffer'},
  {'<leader>w', group = 'Window'},
  {'<leader>r', group = 'References'},
  {'<leader>g', group = 'Git'},
})

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<cr>', {desc = 'Next buffer'})
vim.keymap.set('n', '<leader>bp', '<cmd>bprev<cr>', {desc = 'Previous buffer'})

-- Window management
vim.keymap.set('n', '<leader>wh', '<C-w>h', {desc = 'Go left'})
vim.keymap.set('n', '<leader>wj', '<C-w>j', {desc = 'Go down'})
vim.keymap.set('n', '<leader>wk', '<C-w>k', {desc = 'Go up'})
vim.keymap.set('n', '<leader>wl', '<C-w>l', {desc = 'Go right'})
vim.keymap.set('n', '<leader>wv', '<C-w>v', {desc = 'Split vertical'})
vim.keymap.set('n', '<leader>ws', '<C-w>s', {desc = 'Split horizontal'})
vim.keymap.set('n', '<leader>wq', '<C-w>q', {desc = 'Close window'})
vim.keymap.set('n', '<leader>w-', '<C-w>-', {desc = 'Decrease height'})
vim.keymap.set('n', '<leader>w=', '<C-w>=', {desc = 'Equalize windows'})
vim.keymap.set('n', '<leader>w+', '<C-w>+', {desc = 'Increase height'})
vim.keymap.set('n', '<leader>w<', '<C-w><', {desc = 'Decrease width'})
vim.keymap.set('n', '<leader>w>', '<C-w>>', {desc = 'Increase width'})
vim.keymap.set('n', '<leader>ww', '<C-w>w', {desc = 'Next window'})

-- Neo-tree setup
require('neo-tree').setup({
  filesystem = {
    follow_current_file = {enabled = true},
    use_libuv_file_watcher = true,
    scan_mode = 'deep',
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  git_status = {
    window = {
      position = 'right',
      width = 40,
    },
  },
})

-- Gitsigns setup
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Git [p]review hunk' })
    map('n', '<leader>gb', gitsigns.blame_line, { desc = 'Git [b]lame line' })
    map('n', '<leader>gi', gitsigns.diffthis, { desc = 'Git [i]ndex diff' })
  end,
})

-- Treesitter setup
-- NOTE: the list of supported parsers is in the documentation:
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local ts_parsers = {'lua', 'vim', 'vimdoc', 'c', 'query'}

-- See :help ts-enable-config
vim.g.ts_enable = {
  parsers = ts_parsers,
  auto_install = true,
  highlights = true,
}

-- LSP setup
require('lspkind').init({
  mode = 'symbol_text',
  preset = 'codicons',
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)

    if client and client:supports_method('textDocument/completion') then
      vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end

    -- Enable native Inlay Hints if the LSP server supports them (e.g., ty, rust_analyzer)
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
  end,
})

-- LSP Diagnostics keybinds
vim.keymap.set('n', '<C-d>', '<cmd>lua vim.diagnostic.jump({count=1})<cr>', {desc = 'Next diagnostic'})
vim.keymap.set('n', '<S-C-d>', '<cmd>lua vim.diagnostic.jump({count=-1})<cr>', {desc = 'Previous diagnostic'})
vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.show()<cr>', {desc = 'Show diagnostics in buffer'})
vim.keymap.set('n', '<leader>da', '<cmd>lua vim.diagnostic.open_float()<cr>', {desc = 'Show diagnostics as popup'})
vim.keymap.set('n', '<leader>dw', '<cmd>lua vim.diagnostic.open_float({scope="buffer"})<cr>', {desc = 'Show diagnostics in window'})
vim.keymap.set('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', {desc = 'Show diagnostics in quickfix'})

-- Standard diagnostic navigation
vim.keymap.set('n', 'n', '<cmd>lua vim.diagnostic.jump({count=1})<cr>', {desc = 'Next diagnostic line', noremap = true})
vim.keymap.set('n', 'N', '<cmd>lua vim.diagnostic.jump({count=-1})<cr>', {desc = 'Previous diagnostic line', noremap = true})

-- Automatically show diagnostics on current line in floating window
vim.api.nvim_create_autocmd('CursorMoved', {
  pattern = {'*'},
  callback = function()
    vim.diagnostic.open_float({scope = 'line'})
  end,
})

-- Rename across files (F2 like VSCode)
vim.keymap.set({'n', 'x'}, '<F2>', function()
  vim.lsp.buf.rename()
end, {desc = 'Rename symbol'})

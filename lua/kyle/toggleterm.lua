return {
  "akinsho/toggleterm.nvim",
  opts = {
    open_mapping = "<C-x>",
    direction = "float",
  },
  config = function ()
    require("toggleterm").setup({
      open_mapping = "<C-x>",
      direction = "float",
    })

    -- Create a persistent global cache to hold onto terminal objects after they exit
    _G.npm_terminal_cache = _G.npm_terminal_cache or {}
    local function run_npm_script()
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local Terminal = require("toggleterm.terminal").Terminal

      -- 1. Locate and read package.json
      local package_json_path = vim.fn.getcwd() .. "/package.json"
      if vim.fn.filereadable(package_json_path) == 0 then
        vim.notify("No package.json found in current directory", vim.log.levels.WARN)
        return
      end

      local file = io.open(package_json_path, "r")
      if not file then return end
      local content = file:read("*a")
      file:close()

      -- 2. Safely parse the JSON data using Neovim's built-in JSON decoder
      local ok, json = pcall(vim.json.decode, content)
      if not ok or not json.scripts then
        vim.notify("Could not parse scripts from package.json", vim.log.levels.WARN)
        return
      end

      -- 3. Auto-detect lockfiles to choose the correct package manager
      local manager = "npm"
      if vim.fn.filereadable(vim.fn.getcwd() .. "/pnpm-lock.yaml") == 1 then
        manager = "pnpm"
      elseif vim.fn.filereadable(vim.fn.getcwd() .. "/yarn.lock") == 1 then
        manager = "yarn"
      elseif vim.fn.filereadable(vim.fn.getcwd() .. "/bun.lockb") == 1 or vim.fn.filereadable(vim.fn.getcwd() .. "/bun.lock") == 1 then
        manager = "bun"
      end

      -- 4. Build a list of script names for Telescope
      local script_names = {}
      for script_name, _ in pairs(json.scripts) do
        table.insert(script_names, script_name)
      end
      table.sort(script_names)

      -- 5. Open Telescope picker
      pickers.new({}, {
        prompt_title = "Run Node Script (" .. manager .. ")",
        finder = finders.new_table({
          results = script_names,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function (prompt_bufnr, map)
          actions.select_default:replace(function ()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              local script = selection[1]
              -- Construct the terminal command string
              -- Append a read command so the shell process stays alive after completion
              local cmd = manager .. " run " .. script .. "; echo '\n[Process completed. Press Enter to exit terminal]'; read"
              -- Use a standardized, predictable ID (e.g., 99) for scripts
              local term_id = 99

              -- Create the terminal and store it permanently in our cache table
              local node_task = Terminal:new({
                id = term_id,
                cmd = cmd,
                direction = "float",
                close_on_exit = true, -- Keeps the terminal buffer from being wiped out
                on_close = function(term)
                  if not vim.api.nvim_buf_is_valid(term.bufnr) then
                    _G.npm_terminal_cache[term_id] = nil
                  end
                end,
              })

              node_task:toggle()
            end
          end)
          return true
        end
      }):find()
    end

    local function select_active_terminal()
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local toggleterm_terminal = require("toggleterm.terminal")

      -- Get all active terminal objects tracked by ToggleTerm
      local terms = toggleterm_terminal.get_all()

      if #terms == 0 then
        vim.notify("No active terminals running", vim.log.levels.INFO)
        return
      end

      -- Format the display string to show: "[ID] running_command"
      -- 1. Grab all active, live terminals from ToggleTerm
      local live_terms = toggleterm_terminal.get_all()
      local uniquely_tracked = {}
      local results = {}

      -- Add active live ones to our result list
      for _, term in ipairs(live_terms) do
        uniquely_tracked[term.id] = true
        -- If no explicit cmd was passed, default to the user's shell
        local cmd_display = term.cmd ~= "" and term.cmd or vim.o.shell
        table.insert(results, {
          display = string.format("[%d] %s (Running)", term.id, cmd_display),
          value = term,
        })
      end

      -- 2. Inject cached finished/dead scripts into the list if they aren't already there
      if _G.npm_terminal_cache then
        for id, term in pairs(_G.npm_terminal_cache) do
          if not uniquely_tracked[id] and vim.api.nvim_buf_is_valid(term.bufnr) then
            table.insert(results, {
              display = string.format("[%d] %s (Finished / Stopped)", term.id, term.cmd),
              value = term,
            })
          end
        end
      end

      if #results == 0 then
        vim.notify("No terminals available", vim.log.levels.INFO)
        return
      end
      pickers.new({}, {
        prompt_title = "Active Terminals / Running Processes",
        finder = finders.new_table({
          results = results,
          entry_maker = function(entry)
            return {
              value = entry.value,
              display = entry.display,
              ordinal = entry.display,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function (prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              -- Re-toggle the exact terminal object you selected
              selection.value:toggle()
            end
          end)
          return true
        end
      }):find()

    end

    vim.keymap.set("n", "<leader>ns", run_npm_script, { desc = "Run package.json script" })
    vim.keymap.set("n", "<leader>tl", select_active_terminal, { desc = "List active terminals" })
  end
}

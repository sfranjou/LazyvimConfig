return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    -- Windows MSVC debugger (vsdbg/cppvsdbg)
    dap.adapters.cppvsdbg = {
      id = "cppdbg", -- instead of cppvsdbg
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7.exe",
      options = {
        detached = false,
      },
    }

    -- CodeLLDB adapter (cross-platform alternative)
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe",
        args = { "--port", "${port}" },
      },
    }

    -- Load configurations from .vscode/launch.json and tasks.json
    require("dap.ext.vscode").load_launchjs(nil, { cppvsdbg = { "c", "cpp" }, codelldb = { "c", "cpp" } })
    
    -- Handle preLaunchTask execution
    local function execute_task(task_name)
      local tasks_file = vim.fn.getcwd() .. "/.vscode/tasks.json"
      if vim.fn.filereadable(tasks_file) == 1 then
        local tasks = vim.fn.json_decode(vim.fn.readfile(tasks_file))
        for _, task in ipairs(tasks.tasks or {}) do
          if task.label == task_name then
            local cmd = task.command .. " " .. table.concat(task.args or {}, " ")
            vim.fn.system(cmd)
            return
          end
        end
      end
    end
    
    -- Override the default run behavior to execute preLaunchTask
    local original_run = dap.run
    dap.run = function(config)
      if config.preLaunchTask then
        execute_task(config.preLaunchTask)
      end
      original_run(config)
    end
  end,
}

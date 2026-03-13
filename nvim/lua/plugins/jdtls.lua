return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local function start_jdtls()
        local jdtls = require("jdtls")
        local jdtls_setup = require("jdtls.setup")

        local root_dir = jdtls_setup.find_root({ ".git" }) or jdtls_setup.find_root({ "pom.xml" })
        if not root_dir then
          return
        end

        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

        local os_config = "linux"
        if vim.fn.has("mac") == 1 then
          os_config = "mac"
        elseif vim.fn.has("win32") == 1 then
          os_config = "win"
        end

        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/"
        local jdtls_path = mason_path .. "jdtls/"
        local launcher = vim.fn.glob(jdtls_path .. "plugins/org.eclipse.equinox.launcher_*.jar")

        local bundles = {}
        local java_test = vim.fn.glob(mason_path .. "java-test/extension/server/*.jar")
        if java_test ~= "" then
          vim.list_extend(bundles, vim.split(java_test, "\n"))
        end

        local java_debug =
          vim.fn.glob(mason_path .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
        if java_debug ~= "" then
          vim.list_extend(bundles, vim.split(java_debug, "\n"))
        end

        local home = os.getenv("HOME")

        local config = {
          cmd = {
            home .. "/.sdkman/candidates/java/21.0.2-tem/bin/java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx2g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. jdtls_path .. "lombok.jar",
            "-jar",
            launcher,
            "-configuration",
            jdtls_path .. "config_" .. os_config,
            "-data",
            workspace_dir,
          },

          root_dir = root_dir,
          init_options = { bundles = bundles },

          settings = {
            java = {
              eclipse = { downloadSources = true },
              configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                  {
                    name = "JavaSE-17",
                    path = home .. "/.sdkman/candidates/java/21.0.2-tem",
                  },
                },
              },
              compile = { annotationProcessing = { enabled = true } },
              maven = { downloadSources = true },
              gradle = { enabled = true, downloadSources = true },
              implementationsCodeLens = { enabled = true },
              referencesCodeLens = { enabled = true },
              references = { includeDecompiledSources = true },
              inlayHints = { parameterNames = { enabled = "all" } },
              format = { enabled = false },
            },
          },

          on_attach = function(_, bufnr)
            if #bundles > 0 then
              jdtls.setup_dap({ hotcodereplace = "auto" })
              require("jdtls.dap").setup_dap_main_class_configs()
            end
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              callback = function()
                pcall(vim.lsp.codelens.refresh)
              end,
            })
          end,
        }

        jdtls.start_or_attach(config)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = start_jdtls,
      })

      -- Trigger for the first buffer (already opened when plugin loads)
      if vim.bo.filetype == "java" then
        start_jdtls()
      end
    end,
  },
}

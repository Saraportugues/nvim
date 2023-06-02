local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })
local cache_vars = {}

-- `nvim-jdtls` will look for these files/folders
-- to determine the root directory of your project

local root_files = {
    ".git",
    "mvnw",
    "gradlew",
    "pom.xml",
    "build.gradle",
}

local features = {
    -- change this to `true` to enable codelens
    codelens = false,
    -- change this to `true` if you have `nvim-dap`,
    -- `java-test` and `java-debug-adapter` installed
    debugger = false,
}

local function get_jdtls_paths()
    ---
    -- we will use this function to get all the paths
    -- we need to start the LSP server.
    ---
    if cache_vars.paths then
        return cache_vars.paths
    end

    local path = {}

    path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

    local jdtls_install = require("mason-registry")
        .get_package("jdtls")
        :get_install_path()

    path.java_agent = jdtls_install .. "/lombok.jar"
    path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

    if vim.fn.has("mac") == 1 then
        path.platform_config = jdtls_install .. "/config_mac"
    elseif vim.fn.has("unix") == 1 then
        path.platform_config = jdtls_install .. "/config_linux"
    elseif vim.fn.has("win32") == 1 then
        path.platform_config = jdtls_install .. "/config_win"
    end

    return path
end

local function enable_debugger(buffer)
    -- do nothing
end

local function enable_codelens(buffer)
    -- do nothing
end

local function jdtls_on_attach(client, bufnr)
    if features.debugger then
        enable_debugger(bufnr)
    end

    if features.codelens then
        enable_codelens(bufnr)
    end

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.definition, opts) -- fd -> function definition
    vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>gh", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "<leader>v", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)      -- r -> rename
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts) -- a -> action
    vim.keymap.set("n", "<leader>u", vim.lsp.buf.references, opts)  -- u -> usages
    vim.keymap.set("n", "<leader>h", function()
        vim.diagnostic.open_float()
    end)

    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    vim.keymap.set("n", "<leader>f", function()
        require("jdtls").organize_imports()
        vim.lsp.buf.format { async = true }
    end, opts)
    vim.keymap.set("n", "<leader>jrv", function()
        require("jdtls").extract_variable()
    end, opts)
    vim.keymap.set("n", "<leader>jrc", function()
        require("jdtls").extract_constant()
    end, opts)

    -- would be nice to know how to refactor this into a similar form to the previous keybinds...
    vim.keymap.set("x", "<leader>jrv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
    vim.keymap.set("x", "<leader>jrc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
    vim.keymap.set("x", "<leader>jrm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

local function jdtls_setup(event)
    local jdtls = require("jdtls")

    local path = get_jdtls_paths()

    local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

    if cache_vars.capabilities == nil then
        jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        cache_vars.capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            ok_cmp and cmp_lsp.default_capabilities() or {}
        )
    end

    local cmd = {
        "java",

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. path.java_agent,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        "-jar",
        path.launcher_jar,

        "-configuration",
        path.platform_config,

        "-data",
        data_dir,
    }

    local lsp_settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = path.runtimes,
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            -- inlayHints = {
            --   parameterNames = {
            --     enabled = "all" -- literals, all, none
            --   }
            -- },
            format = {
                enabled = true,
                -- settings = {
                --   profile = "asdf"
                -- },
            }
        },
        signatureHelp = {
            enabled = true,
        },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        contentProvider = {
            preferred = "fernflower",
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            }
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    }

    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    jdtls.start_or_attach({
        cmd = cmd,
        settings = lsp_settings,
        on_attach = jdtls_on_attach,
        capabilities = cache_vars.capabilities,
        root_dir = jdtls.setup.find_root(root_files),
        flags = {
            allow_incremental_sync = true,
        },
        init_options = {
            bundles = path.bundles,
        },
    })
end

vim.api.nvim_create_autocmd("FileType", {
    group = java_cmds,
    pattern = { "java" },
    desc = "Setup jdtls",
    callback = jdtls_setup,
})

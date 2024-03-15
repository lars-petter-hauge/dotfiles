
local vim = vim

vim.api.nvim_create_augroup("AutoFormat", {})

-- pip install black
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.py",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !black --quiet %")
            vim.cmd("edit")
        end,
    }
)
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.rs",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !rustfmt %")
            vim.cmd("edit")
        end,
    }
)
-- npm install -g prettier
vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.ts*",
        group = "AutoFormat",
        callback = function()
            vim.cmd("silent !prettier % --write")
            vim.cmd("edit")
        end,
    }
)

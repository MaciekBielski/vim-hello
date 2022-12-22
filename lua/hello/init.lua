-- local matches = vim.lsp.util.text_document_completion_list_to_complete_items(result, context.base)
-- vim.api.nvim_call_function('ncm2#complete', {context, context.startccol, matches})

-- local bufnr = vim.api.nvim_get_current_buf()
-- local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

-- local function escape(chars)
--     local result = {}
--     for i = 1, #chars do
--         result[i] = vim.pesc(chars[i]):gsub('%%', '\\')
--     end
--     return result
-- end
local function log(msg, prefix)
    vim.notify(vim.inspect(msg))
end

local api = vim.api
local inner_buf, inner_opts, inner_win
local inner_bufnm = 'HelloFloat#'

local function set_banner(text)
    local width = api.nvim_win_get_width(0)
    log {inner_buf}
    local bufname = api.nvim_buf_get_name(inner_buf)
    local offset1 = math.floor(width/2) - math.floor(string.len(bufname)/2)
    local offset2 = math.floor(width/2) - math.floor(string.len(text)/2)

    api.nvim_buf_set_lines(inner_buf, 0, -1, false, {
        string.rep(' ', offset1) .. bufname,
        string.rep(' ', offset2) .. text,
        ''
    })
end


local function update_view()
    -- ENTER
    -- api.nvim_buf_set_option(inner_buf, 'modifiable', true)

    -- height of 2
    set_banner('HELLO!')

    local data = vim.fn.systemlist('echo "Current dir: $(pwd)"')
    -- Indent
    for k,v in pairs(data) do
        data[k] = '\t' .. data[k]
    end
    api.nvim_buf_set_lines(inner_buf, 3, -1, false, data)

    -- EXIT
    -- api.nvim_buf_set_option(inner_buf, 'modifiable', false)
end


local function del_float_window()
    log { 'BufUnload' }
    api.nvim_buf_delete(inner_buf, { force = true, unload = false})
    log { api.nvim_list_bufs() }
    -- api.nvim_win_close(inner_win, false)
end


local function make_float_window()

    -- local editor_width = api.nvim_get_option('columns')
    local editor_width = vim.o['columns']
    local editor_height = vim.o['lines']
    local inner_width = math.ceil(editor_width * 0.7)
    local inner_height = math.ceil(editor_height * 0.4)
    local start_x = math.ceil((editor_width - inner_width) / 2 - 1)
    local start_y = math.ceil((editor_height - inner_height) / 2 - 1)

    -- log {
    --     editor_width     = editor_width,
    --     editor_height    = editor_height,
    --     inner_width      = inner_width,
    --     inner_height     = inner_height,
    --     start_x          = start_x,
    --     start_y          = start_y,
    -- }

    inner_buf = api.nvim_create_buf(false, true)
    local buf_name = inner_bufnm .. inner_buf
    api.nvim_buf_set_name(inner_buf, buf_name)
    -- api.nvim_buf_set_option(inner_buf, 'buftype', 'nofile')
    -- shorter:
    vim.bo[inner_buf].buftype = nofile
    -- TODO: try also wipe
    vim.bo[inner_buf].bufhidden = hide -- hide, unload, delete, wipe

    inner_opts = {
        style = 'minimal',
        border = 'rounded',
        relative = 'editor',
        width = inner_width,
        height = inner_height,
        col = start_x,
        row = start_y,
        zindex = 10,
    }

    api.nvim_create_autocmd({"VimLeave"}, { pattern = {'*'},
                                           callback = function() del_float_window() end })

    log {'foobar'}
end


local function show_float_window()
    if inner_buf == nil or api.nvim_buf_is_loaded(inner_buf) == false then
        make_float_window()
    end
    inner_win = api.nvim_open_win(inner_buf, true, inner_opts)
end


local function run()
    show_float_window()
    -- update_view()
end

return {
    run = run,
    show_float_window = show_float_window,
    del_float_window = del_float_window,
--     -- export other functions for debug too
--     -- on_complete_lsp = on_complete_lsp,
}

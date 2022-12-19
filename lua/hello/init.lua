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
local inner_buff, inner_opts

local function set_banner(text)
    local width = api.nvim_win_get_width(0)
    log {inner_buf}
    local bufname = api.nvim_buf_get_name(inner_buff)
    local offset1 = math.floor(width/2) - math.floor(string.len(bufname)/2)
    local offset2 = math.floor(width/2) - math.floor(string.len(text)/2)

    api.nvim_buf_set_lines(inner_buff, 0, -1, false, {
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
    api.nvim_buf_set_lines(inner_buff, 3, -1, false, data)

    -- EXIT
    -- api.nvim_buf_set_option(inner_buf, 'modifiable', false)
end


local function open_float_window()

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

    inner_buff = api.nvim_create_buf(false, true)
    api.nvim_buf_set_name(inner_buff, 'HelloFloat#' .. inner_buff)
    -- api.nvim_buf_set_option(inner_buff, 'buftype', 'nofile')
    -- shorter:
    vim.bo[inner_buff].buftype = nofile
    -- TODO: try also wipe
    vim.bo[inner_buff].bufhidden = hide

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
    inner_win = api.nvim_open_win(inner_buff, true, inner_opts)
end


local function reopen_float_window()
    inner_win = api.nvim_open_win(inner_buff, true, inner_opts)
end


local function close_float_window()
    local buf_info = api.nvim_call_function('getbufinfo', {inner_buff})[1]
    buf_info.changed = 0
    log(buf_info)
    -- TODO: Finish from here
end

local function run()
    open_float_window()
    update_view()
end

return {
    run = run,
    open_float_window = open_float_window,
    reopen_float_window = reopen_float_window,
    close_float_window = close_float_window,
--     -- export other functions for debug too
--     -- on_complete_lsp = on_complete_lsp,
}

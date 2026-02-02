-- @class anhquantrl.util
-- @field fold anhquantrl.util.fold
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('anhquantrl.util.' .. k)
    return t[k]
  end,
})

return M

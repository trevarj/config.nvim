-- Icons used in more than one place
M = {
  error = " ",
  warning = " ",
  info = " ",
  hint = " ",
}

local by_severity = { M.error, M.warning, M.info, M.hint }
function M.from_severity(diagnostic)
  local s = diagnostic.severity
  return by_severity[s]
end

return M

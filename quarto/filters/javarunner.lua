-- Convert fenced Java blocks marked .javarunner / .javarunner-repl into
-- java-runner <script> elements for HTML output. Other formats keep CodeBlocks.
--
-- Emits a visible <pre> fallback so book code is readable before javarunner.js
-- replaces the <script> with a .jr-widget (see .jr-pending CSS).

local function has_class(el, name)
  for _, cls in ipairs(el.classes) do
    if cls == name then
      return true
    end
  end
  return false
end

local function escape_html(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

function CodeBlock(el)
  if not FORMAT:match("html") then
    return nil
  end

  local is_repl = has_class(el, "javarunner-repl")
  local is_runner = has_class(el, "javarunner") or is_repl
  if not is_runner then
    return nil
  end

  local script_type = is_repl and "text/x-java-repl" or "text/x-java"
  -- Prevent accidental early close if source ever contains </script>
  local code = el.text:gsub("</[Ss][Cc][Rr][Ii][Pp][Tt]>", "<\\/script>")
  local visible = escape_html(el.text)
  local html = string.format(
    '<div class="jr-pending">\n'
      .. '<pre class="jr-pending-code"><code>%s</code></pre>\n'
      .. '<script type="%s">\n%s\n</script>\n'
      .. "</div>",
    visible,
    script_type,
    code
  )
  return pandoc.RawBlock("html", html)
end

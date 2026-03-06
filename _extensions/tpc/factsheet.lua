function Div(el)
  -- Two-column layout
  if el.classes:includes("two-col") then
    if FORMAT:match("html") then
      el.attributes["style"] = "display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;"
      return el
    elseif FORMAT:match("latex") then
      return {
        pandoc.RawBlock("latex", "\\begin{multicols}{2}"),
        el,
        pandoc.RawBlock("latex", "\\end{multicols}")
      }
    end
  end

  -- Colored boxes
  for _, box in ipairs({"box-teal", "box-deepblue", "box-light"}) do
    if el.classes:includes(box) then
      if FORMAT:match("latex") then
        return {
          pandoc.RawBlock("latex", "\\begin{" .. box .. "}"),
          el,
          pandoc.RawBlock("latex", "\\end{" .. box .. "}")
        }
      end
    end
  end

  -- Sidebar
  if el.classes:includes("sidebar") then
    if FORMAT:match("latex") then
      return {
        pandoc.RawBlock("latex", "\\begin{sidebarbox}"),
        el,
        pandoc.RawBlock("latex", "\\end{sidebarbox}")
      }
    end
  end

  return el
end

-- Center images in LaTeX with spacing
function Image(img)
  if FORMAT:match("latex") then
    local width = img.attributes.width or "\\linewidth"
    if width:match("%%") then
      width = tonumber(width:match("(%d+)")) / 100 .. "\\linewidth"
    end
    return pandoc.RawInline("latex",
      "\n\\vspace{0.8em}\n{\\centering\\includegraphics[width=" .. width .. ",keepaspectratio]{" .. img.src .. "}\\par}\n\\vspace{0.5em}\n")
  end
end
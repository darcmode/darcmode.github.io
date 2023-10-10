-- add-links.lua

function Header(elem)
  local link = pandoc.Link(elem.content, "#" .. elem.identifier)
  elem.content = { link }
  return elem
end

return {
  {Header = Header}
}

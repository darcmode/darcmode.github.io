-- Define a function to process RawBlocks
function processRawBlock(elem)
  if elem.t == "RawBlock" and elem.format == "org" then
    local content = elem.text
    local filePath, syntax = content:match('#%+INCLUDE:%s*"([^"]+)"%s*src%s*([%w_-]+)%s*-n')
    local inputFile = PANDOC_STATE.input_files[1]
    local inputDir = inputFile:match("^(.*[\\/]).*[\\/]*$")

    if filePath and syntax then
      local file = io.open(inputDir .. filePath, "r")
      local fileContent = file:read("*a")
      file:close()

      if fileContent then
        return pandoc.CodeBlock(fileContent, { class = syntax .. " numberLines" })
      end
    end
  end
  return elem
end

-- Apply the filter
return {
  {
    RawBlock = processRawBlock
  }
}

local function map_extension(ext)
  if ext == ".org" then
    return "org"
  else
    return "gfm"
  end
end

local function extract_tags(doc)
  local tags = {}
  doc:walk {
    RawBlock = function(rawblock)
      rawtags = rawblock.text:match("#%+TAGS:%s*(.*)")
      if rawtags then
        for tag in rawtags:gmatch("(%S+)") do
          table.insert(tags, tag)
        end
      end
      return {}
    end
  }
  return tags
end

local function extract_title(inline)
  local title = ""
  inline:walk {
    Space = function(_)
      title = title .. "-"
    end,
    Str = function(str)
      title = title .. str.text
    end
  }
  return title
end

function Reader(input, meta)
  -- List of all docs
  local rootdoc = {}
  -- Process each input file
  for _, source in pairs(input) do
    -- Get the file extension
    local _, ext = pandoc.path.split_extension(source.name)
    -- Read the file using the right format
    local doc = pandoc.read(source, map_extension(ext))
    -- Add current document title to the root document
    local title = doc.meta["title"];
    table.insert(
      rootdoc,
      pandoc.Header(1, title, extract_title(title))
    );
    -- Create a document content wrapper for the current input file
    local doccontent = {}
    -- Extract tags from metadata
    local tags = extract_tags(doc)
    -- Add tags to the running document content
    if tags then
      table.insert(doccontent, pandoc.Para(tags))
    end
    -- Add all blocks from the original doc into the content wrapper
    for _, block in pairs(doc.blocks) do
      table.insert(doccontent, block)
    end
    table.insert(rootdoc, pandoc.Div(doccontent, "#" .. extract_title(title)));
  end
  rootdoc = pandoc.Pandoc(rootdoc);
  rootdoc.meta['title'] = meta['title'];
  return rootdoc;
end

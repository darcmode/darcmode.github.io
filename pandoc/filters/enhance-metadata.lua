local openai = require("openai")
local api_key = os.getenv("OPENAI_API_KEY")

function Pandoc(doc)
  if api_key then
    -- Extract content from the entire document
    local content = pandoc.utils.stringify(doc)

    -- Construct a user prompt to enhance metadata
    local user_prompt = "Enhance the metadata for a document with the following content:\n\n" .. content

    -- Construct a system prompt to guide the AI
    local system_prompt =
    "You are an AI assistant with expertise in SEO and publishing. Please enhance the document's metadata to improve SEO:\n"

    -- Combine both prompts
    local prompt = system_prompt .. user_prompt

    -- Initialize the ChatGPT client
    local client = openai.new(api_key)

    -- Make a request to ChatGPT to enhance the metadata
    local status, response = client:chat({
      { role = "system", content = prompt },
      { role = "user",   content = user_prompt }
    }, {
      model = "gpt-3.5-turbo",
      temperature = 0.7,
      max_tokens = 150
    })

    if status == 200 then
      -- Extract the enhanced metadata from the response
      local enhanced_metadata = response.choices[2].message.content

      -- Split the response into separate "title," "keywords," and "description" attributes
      local title, keywords, description = enhanced_metadata:match("Title:(.-)\nKeywords:(.-)\nDescription:(.-)\n")

      -- Create a new Pandoc Meta block with enhanced metadata
      local new_meta = pandoc.Meta({
        title = title,
        keywords = keywords,
        description = description
      })

      -- Replace the existing "title," "keywords," and "description" metadata
      doc.meta.title = new_meta.title
      doc.meta.keywords = new_meta.keywords
      doc.meta.description = new_meta.description
    else
      print("Error: Unable to enhance metadata.")
    end
  end

  return doc
end

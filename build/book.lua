-- book.lua — the book's build filter.
--
-- Everything is driven by markers in the Markdown, so nothing generated has to
-- be maintained by hand (a generated list cannot drift from its source):
--
--   [term]{.idx}                     an index entry: records the term with the
--                                    section it appears in, and emits a real
--                                    \index{} entry for the LaTeX build.
--   ::: definitive                   a labelled callout, collected into the
--        title: Optional heading     "Key ideas" list at {#key-ideas}.
--   ::: {#book-index} :::            replaced by the generated index.
--   ::: {#key-ideas} :::             replaced by the generated key-idea list.
--
-- Why this is not a one-line filter: ``doc:walk`` visits an element's children
-- BEFORE the element itself, so a [term]{.idx} span is seen before the heading
-- that encloses it — section tracking from inside a plain walk is always empty.
-- So the block level is walked top-down by hand, and each block's inlines are
-- walked with the section captured as an upvalue.
--
-- Debug: BOOK_DEBUG=1 prints what it collected to stderr.

local DEBUG = os.getenv("BOOK_DEBUG") == "1"

local index_entries = {}
local key_ideas = {}
local current_anchor = "top"
local current_section = "Introduction"

local function text_of(inlines)
  local parts = {}
  for _, il in ipairs(inlines) do
    if il.t == "Str" then
      table.insert(parts, il.text)
    elseif il.t == "Space" or il.t == "SoftBreak" or il.t == "LineBreak" then
      table.insert(parts, " ")
    elseif il.t == "Code" then
      table.insert(parts, il.text)
    elseif il.t == "Emph" or il.t == "Strong" or il.t == "Span" or il.t == "Quoted" then
      table.insert(parts, text_of(il.content))
    end
  end
  return (table.concat(parts):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end

-- makeindex treats these as syntax; escape them so a term is always a term.
local function latex_term(term)
  return (term:gsub("!", "\"!"):gsub("@", "\"@"):gsub("|", "\"|"))
end

local function heading_key(text)
  local s = text:lower()
  s = s:gsub("[^%w%s%-]", "")
  s = s:gsub("%s+", "-"):gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
  return s
end

-- [term]{.idx}
local function span_handler(el)
  if not el.classes:includes("idx") then
    return nil
  end
  local term = el.attributes.term or text_of(el.content)
  if term == "" then
    return nil
  end
  table.insert(index_entries, { term = term, anchor = current_anchor, section = current_section })
  if FORMAT:match("latex") then
    return {
      pandoc.RawInline("latex", "\\index{" .. latex_term(term) .. "}"),
      pandoc.Span(el.content, pandoc.Attr("", { "idx-term" })),
    }
  end
  return pandoc.Span(el.content, pandoc.Attr("", { "idx-term" }))
end

local function gen_index()
  if #index_entries == 0 then return {} end
  table.sort(index_entries, function(a, b)
    local ak, bk = a.term:lower(), b.term:lower()
    if ak == bk then return a.section < b.section end
    return ak < bk
  end)

  local by_term, order = {}, {}
  for _, e in ipairs(index_entries) do
    local key = e.term:lower()
    if not by_term[key] then
      by_term[key] = { term = e.term, refs = {}, seen = {} }
      table.insert(order, key)
    end
    if not by_term[key].seen[e.section] then
      by_term[key].seen[e.section] = true
      table.insert(by_term[key].refs, { label = e.section, anchor = e.anchor })
    end
  end

  local items = {}
  for _, key in ipairs(order) do
    local rec = by_term[key]
    local inlines = { pandoc.Str(rec.term), pandoc.Space() }
    for i, ref in ipairs(rec.refs) do
      if i > 1 then
        table.insert(inlines, pandoc.Str(","))
        table.insert(inlines, pandoc.Space())
      end
      table.insert(inlines, pandoc.Link({ pandoc.Str(ref.label) }, "#" .. ref.anchor))
    end
    table.insert(items, pandoc.Para(inlines))
  end
  return {
    pandoc.Header(1, { pandoc.Str("Index") }, pandoc.Attr("index")),
    pandoc.Div(items, pandoc.Attr("", { "generated-index" })),
  }
end

local function gen_key_ideas()
  if #key_ideas == 0 then return {} end
  local items = {}
  for _, idea in ipairs(key_ideas) do
    table.insert(items, pandoc.Plain({ pandoc.Link({ pandoc.Str(idea.title) }, "#" .. idea.anchor) }))
  end
  return {
    pandoc.Header(1, { pandoc.Str("Key ideas") }, pandoc.Attr("key-ideas")),
    pandoc.BulletList(items),
  }
end

local walk_block  -- forward declaration

local function walk_blocks(blocks)
  local out = pandoc.Blocks({})
  for _, b in ipairs(blocks) do
    local result = walk_block(b)
    if type(result) == "table" and result.t == nil then
      out:extend(result)          -- a generated *list* of blocks
    else
      table.insert(out, result)
    end
  end
  return out
end

walk_block = function(b)
  if b.t == "Header" then
    current_anchor = (b.identifier ~= "" and b.identifier) or heading_key(text_of(b.content))
    b.identifier = current_anchor
    -- Any level: the index entry's label should match the anchor it links to.
    current_section = text_of(b.content)
    return b
  end

  if b.t == "Div" then
    if b.identifier == "book-index" then
      return gen_index()
    end
    if b.identifier == "key-ideas" then
      return gen_key_ideas()
    end
    if b.classes:includes("definitive") then
      local title = b.attributes.title
      local anchor = (b.identifier ~= "" and b.identifier)
                     or heading_key(title or ("key-idea-" .. tostring(#key_ideas + 1)))
      b.identifier = anchor
      if title and title ~= "" then
        table.insert(key_ideas, { title = title, anchor = anchor })
      end

      local saved_anchor, saved_section = current_anchor, current_section
      current_anchor = anchor
      if title and title ~= "" then
        current_section = title
      end

      local label = { pandoc.Span({ pandoc.Str("DEFINITIVE") }, pandoc.Attr("", { "definitive-label" })) }
      if title and title ~= "" then
        table.insert(label, pandoc.Space())
        table.insert(label, pandoc.Str("— " .. title))
      end
      local body = { pandoc.Para(label) }
      for _, child in ipairs(walk_blocks(b.content)) do
        table.insert(body, child)
      end
      current_anchor, current_section = saved_anchor, saved_section
      return pandoc.Div(body, pandoc.Attr(anchor, { "definitive" }))
    end
    -- an ordinary div: recurse so nested headings still track
    b.content = walk_blocks(b.content)
    return b
  end

  -- any other block: replace markers inside it, with this block's section
  return b:walk({ Span = span_handler })
end

function Pandoc(doc)
  doc.blocks = walk_blocks(doc.blocks)
  if DEBUG then
    io.stderr:write("BOOK_DEBUG: index=" .. #index_entries .. " keyideas=" .. #key_ideas .. "\n")
    for _, e in ipairs(index_entries) do
      io.stderr:write("  " .. e.term .. "  [" .. e.section .. "] -> #" .. e.anchor .. "\n")
    end
  end
  return doc
end

return { { Pandoc = Pandoc } }

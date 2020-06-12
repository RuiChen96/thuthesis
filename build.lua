#!/usr/bin/env texlua

module = "thuthesis"

supportdir = "./testfiles/support-main"
checksuppfiles = {"fontset.tex"}

demofiles = {"latexmkrc", "Makefile"}
docfiles = {
  "CHANGELOG.md",
  "thusetup.tex", "math_commands.tex",
  "data", "figures", "ref",
}
installfiles = {"*.cls", "*.bst", "tsinghua-name-bachelor.pdf"}
sourcefiles = {"*.dtx", "*.ins", "*.bst", "tsinghua-name-bachelor.pdf"}
tagfiles = {"*.dtx", "CHANGELOG.md", "package.json"}
textfiles = {"*.md","LICENSE"}
typesetdemofiles = {"thuthesis-example.tex", "spine.tex"}

checkengines = {"xetex"}
stdengine = "xetex"

checkconfigs = {
  "build",
  "testfiles/config-cover",
  "testfiles/config-nomencl",
  "testfiles/config-bib",
}

typesetexe = "xelatex"
unpackexe = "xetex"

checkopts = "-file-line-error -halt-on-error -interaction=nonstopmode"
typesetopts = "-shell-escape -file-line-error -halt-on-error -interaction=nonstopmode"

packtdszip = true

tdslocations = {
  "bibtex/bst/thuthesis/*.bst",
}

lvtext = ".tex"

function docinit_hook()
  for _, file in pairs({"dtx-style.sty"}) do
    cp(file, unpackdir, typesetdir)
  end
  return 0
end

function update_tag(file, content, tagname, tagdate)
  local url = "https://github.com/tuna/thuthesis"
  local date = string.gsub(tagdate, "%-", "/")
  if string.match(file, "%.dtx$") then
    if string.match(content, "%d%d%d%d/%d%d/%d%d [0-9.]+") then
      content = string.gsub(content, "%d%d%d%d/%d%d/%d%d [0-9.]+",
        date .. " " .. tagname)
    end
    if string.match(content, "\\def\\version{[0-9.]+}") then
      content = string.gsub(content, "\\def\\version{[0-9.]+}",
        "\\def\\version{" .. tagname .. "}")
    end

  elseif string.match(file, "CHANGELOG.md") then
    local previous = string.match(content, "/compare/(.*)%.%.%.HEAD")
    local gittag = 'v' .. tagname

    if gittag == previous then return content end
    content = string.gsub(content,
      "## %[Unreleased%]",
      "## [Unreleased]\n\n## [" .. gittag .."] - " .. tagdate)
    content = string.gsub(content,
      previous .. "%.%.%.HEAD",
      gittag .. "...HEAD\n" ..
      string.format("%-14s", "[" .. gittag .. "]:") .. url .. "/compare/"
        .. previous .. "..." .. gittag)

  elseif string.match(file, "package.json") then
    content = string.gsub(content,
      "\"version\": \"[0-9.]+\"",
      "\"version\": \"" .. tagname .. "\"")
  end

  return content
end

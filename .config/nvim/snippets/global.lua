-- Snippets personalizados globais
return {
  -- Bloco if/end
  {
    prefix = "ifun",
    body = { "if ${1:condition} then", "\t$0", "end" },
    desc = "Bloco if/end",
  },

  -- Bloco for
  {
    prefix = "forloop",
    body = { "for ${1:i} = 1, ${2:n} do", "\t$0", "end" },
    desc = "For loop com range",
  },

  -- Require module
  {
    prefix = "req",
    body = { "local ${1:name} = require('${2:name}')" },
    desc = "Require module",
  },

  -- Print com tabstops
  {
    prefix = "print",
    body = { "print('${1:message}')" },
    desc = "Print statement",
  },
}

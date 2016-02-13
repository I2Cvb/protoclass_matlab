
function ExprStr = noSpaces(ExprStr)
    ExprStr = regexprep(ExprStr, ' ', '_');
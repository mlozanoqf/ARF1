redirect <- '<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="refresh" content="0; url=docs/index.html">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Course syllabus. Fall 2026. Under review.</title>
  <link rel="canonical" href="docs/index.html">
</head>
<body>
  <p>Redirecting to <a href="docs/index.html">Course syllabus. Fall 2026. Under review.</a></p>
</body>
</html>
'

writeLines(redirect, "index.html", useBytes = TRUE)
writeLines("", ".nojekyll", useBytes = TRUE)

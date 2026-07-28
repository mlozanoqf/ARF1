$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $projectRoot "_quarto.yml"
$outputDirectory = Join-Path $projectRoot "includes\generated"
$outputPath = Join-Path $outputDirectory "book-metadata.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$config = [System.IO.File]::ReadAllText($configPath, $utf8NoBom)
$chapterFiles = [regex]::Matches($config, "[A-Za-z0-9_.-]+\.qmd") |
  ForEach-Object { $_.Value } |
  Select-Object -Unique

$supportingFiles = @(
  "_quarto.yml",
  "9mybibfile.bib",
  "syllabus-styles.css",
  "includes/analytics.html",
  "includes/back-to-top.html",
  "includes/progress-bar.html",
  "includes/local-navigation.html",
  "includes/page-sections.html",
  "includes/sidebar-accordion.html",
  "includes/contact-links.html",
  "scripts/finalize-render.ps1"
)

$sourceFiles = (@($chapterFiles) + $supportingFiles) |
  Select-Object -Unique |
  Where-Object { Test-Path (Join-Path $projectRoot $_) }

if (-not $sourceFiles) {
  throw "No Quarto source files were found in _quarto.yml."
}

$sourceParts = foreach ($sourceFile in $sourceFiles) {
  $sourcePath = Join-Path $projectRoot $sourceFile
  $sourceText = [System.IO.File]::ReadAllText($sourcePath, $utf8NoBom)
  "FILE: $sourceFile`n$sourceText"
}

$bookSource = $sourceParts -join "`n`n"
$temporaryFile = [System.IO.Path]::GetTempFileName()

try {
  [System.IO.File]::WriteAllText($temporaryFile, $bookSource, $utf8NoBom)
  $safeDirectory = $projectRoot.Replace("\", "/")
  $editionHash = (& git -c "safe.directory=$safeDirectory" hash-object --no-filters $temporaryFile 2>$null).Trim()
} catch {
  $editionHash = ""
} finally {
  Remove-Item -LiteralPath $temporaryFile -Force -ErrorAction SilentlyContinue
}

if ($editionHash -notmatch "^[0-9a-f]{40,64}$") {
  $sha256 = [System.Security.Cryptography.SHA256]::Create()
  try {
    $hashBytes = $sha256.ComputeHash($utf8NoBom.GetBytes($bookSource))
    $editionHash = -join ($hashBytes | ForEach-Object { $_.ToString("x2") })
  } finally {
    $sha256.Dispose()
  }
}

$editionShort = $editionHash.Substring(0, 7)
$culture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
$publishedLabel = (Get-Date).ToString("MMMM d, yyyy, h:mm:ss tt", $culture)
$publishedLabel = $publishedLabel.Replace(" AM", " am").Replace(" PM", " pm") + "."

$metadataHtml = @"
<script>
(function () {
  var editionPrefix = "Book edition: ";
  var editionShort = "$editionShort";
  var editionHash = "$editionHash";
  var publishedLabel = "$publishedLabel";

  function applyBookMetadata() {
    var titleBlock = document.querySelector("#title-block-header .quarto-title");
    var subtitle = document.querySelector("#title-block-header .subtitle");
    var existingEdition = document.querySelector("#title-block-header .book-edition-line");

    if (titleBlock && !existingEdition) {
      var editionLine = document.createElement("p");
      editionLine.className = "book-edition-line";
      editionLine.appendChild(document.createTextNode(editionPrefix));

      var editionCode = document.createElement("code");
      editionCode.className = "book-edition-code";
      editionCode.textContent = editionShort;
      editionLine.appendChild(editionCode);
      editionLine.title = editionPrefix + editionShort;

      if (subtitle && subtitle.parentNode) {
        subtitle.insertAdjacentElement("afterend", editionLine);
      } else {
        titleBlock.appendChild(editionLine);
      }
    }

    document.documentElement.setAttribute("data-book-edition", editionHash);

    document.querySelectorAll("#title-block-header .quarto-title-meta-heading").forEach(function (heading) {
      var text = heading.textContent.trim();
      if (text !== "Date" && text !== "Published") {
        return;
      }

      heading.textContent = "Published";
      var item = heading.parentElement;
      var date = item ? item.querySelector(".quarto-title-meta-contents p") : null;
      if (date) {
        date.textContent = publishedLabel;
      }
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", applyBookMetadata);
  } else {
    applyBookMetadata();
  }
})();
</script>
"@

New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
[System.IO.File]::WriteAllText($outputPath, $metadataHtml, $utf8NoBom)

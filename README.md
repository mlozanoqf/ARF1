# ARF1 syllabus

This repository contains the Quarto book version of the course syllabus for
Administracion de riesgos financieros ARF.

## Active workflow

- Edit the active `.qmd` source files in the project root.
- Render locally with Quarto:

```powershell
quarto render
```

- The rendered website is written to `docs/`.
- GitHub Pages publishes from the `main` branch using the `docs/` folder.
- Commit both source changes and the rendered `docs/` output when publishing.

## Active structure

The active book structure is defined in `_quarto.yml`.

Main source chapters:

- `index.qmd`
- `welcome.qmd`
- `course-overview.qmd`
- `tools-data-science.qmd`
- `course-activities.qmd`
- `evaluation.qmd`
- `rubrics.qmd`
- `course-policies.qmd`
- `checklist.qmd`
- `schedule.qmd`
- `learning-resources.qmd`
- `internet-resources.qmd`
- `references.qmd`

Historical files and legacy notes are kept in `archive/`.

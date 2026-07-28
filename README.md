# ARF1 syllabus

This repository contains the Quarto book version of the course syllabus for
Administracion de riesgos financieros ARF.

## Publishing workflow

- Edit the active `.qmd` source files in the project root.
- Preview or verify the complete book locally with Quarto:

```powershell
quarto render
```

- The rendered website is written to `docs/`.
- A push to `main` runs `.github/workflows/publish.yml`.
- GitHub Actions installs Quarto, renders the complete book, checks the output,
  and deploys `docs/` to GitHub Pages.
- The automated render does not require R, R packages, or Chocolatey.

### Migration note

The existing rendered `docs/` folder remains tracked until the first successful
GitHub Actions deployment. After that deployment is verified, `docs/` can be
removed from version control and added to `.gitignore`; it will remain the local
render destination and the temporary deployment artifact created by the action.

Use this transition order:

1. Commit and push the workflow, source files, and current `docs/` output.
2. In the repository's GitHub Pages settings, change **Source** from
   **Deploy from a branch** to **GitHub Actions**.
3. Run **Publish Quarto syllabus** manually, or push another change to `main`.
4. Verify the published site and the workflow run.
5. Remove `docs/` from version control and add `/docs/` to `.gitignore`.

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

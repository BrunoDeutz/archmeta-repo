# archmeta-repo

An enterprise-architecture repository for ArchMeta: the architecture is
written as text files, kept in git, read by the ArchMeta Kernel, edited in the Viewer and published as a static site.

## Layout

| Folder | What it holds |
|---|---|
| `archmeta/` | The tool's side: configuration, metamodels, data points, cascades, filters, layer sets |
| `model/` | The content: elements and relationships, views, processes, sequences, descriptions, projects, the site outline |
| `website/` | The generated site (not committed) |

## Start

Run `./archmeta.sh` (macOS / Linux), `archmeta.command` (macOS, double-click) or `archmeta.ps1` (Windows), then open
the Viewer.

## Working with an AI assistant

`AGENTS.md` says where each kind of file goes and what to read before writing one.

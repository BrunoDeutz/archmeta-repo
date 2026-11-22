# Guide for AI assistants

This is an **ArchMeta repository**: an enterprise-architecture model written as text and read by the ArchMeta Kernel.
It is not source code.

## Where things are

- `archmeta/` — the tool's side: `archmeta.yaml`, `metamodels/`, `data-points/`, `cascades/`, `filters/`, `layers/`,
  and what the Kernel writes (`ai-vocabulary.md`, `diagnostics/`, `journal/`).
- `model/` — the content: `elements/` (`.arch`, `.data`), `views/`, `processes/` (`.bpmn`), `sequences/`,
  `descriptions/` (`.md`), `projects/`, `site/site.toc`.
- `website/` — the generated site. Never edit it.

## Before writing a model file

1. Read `archmeta/ai-vocabulary.md`: the element types, relationship types and data points the metamodels allow.
   A type that is not in it is diagnosed as unknown.
2. Put new `.arch` files under `model/elements/`. Identifiers are lowercase words joined by hyphens; the dotted path
   carries identity, the file a statement sits in does not.
3. After a change, reload the Kernel and read `archmeta/diagnostics/archmeta-report.md`: the load never fails, it
   reports. Fix what it lists.

## What not to touch

`.metamodel`, `.bpmn` and `.md` files are authored by hand and kept byte for byte. `.view` files are written by the
Viewer; do not hand-edit positions.

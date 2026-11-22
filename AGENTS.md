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

## What the repository offers

- **Five metamodels** in `archmeta/metamodels/`: `archimate` (business, application, technology, strategy), `c4`,
  `infra` (deployment icons and frames), `data` and `core`. A type is written with its prefix: `archimate:businessprocess`.
- **Data points** in `archmeta/data-points/`, one file per topic: lifecycle, portfolio (criticality, fit, TIME),
  resilience (RTO, RTA, RPO, RPA, availability), security, sourcing, finance, organisation, planning. A list value is
  written exactly as declared, number included: `RTO "030 Minutes"`.
- **Three layer sets** in `archmeta/layers/`: `availability-down` (business to infrastructure), `availability-up`
  (infrastructure to business) and `navigate-down` (for reports).
- **Cascades** in `archmeta/cascades/`: a requirement set on the business travels down, a value achieved by the
  infrastructure travels up. The result lands under `<data point>-from`. Never write a `-from` value by hand.
- **Filters** in `archmeta/filters/`: gaps (recovery, data loss, availability), end of life and end of support,
  criticality, TIME, fit, sensitive data, cost, and what is not filled in.

A value only travels if the elements are linked by relationships and their types are in the layer set. Set a
requirement (RTO, RPO, Availability-Requirement, Business-Criticality) where the business asks for it and an achieved
value (RTA, RPA, Availability-Achieved, end-of-life, end-of-support) where the infrastructure delivers it.

## What not to touch

`.metamodel`, `.bpmn` and `.md` files are authored by hand and kept byte for byte. `.view` files are written by the
Viewer; do not hand-edit positions.

import Lake
open Lake DSL

package «generative-field» where
  -- no external dependencies: the formalization uses core Lean only,
  -- so the proof layer stays fast and auditable.

@[default_target]
lean_lib «GenerativeField» where
  -- default glob: GenerativeField.lean root, which imports Basic.

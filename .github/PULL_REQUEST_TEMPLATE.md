<!-- Keep the description tight. Link the issue with "Closes #N" when applicable. -->

## Summary

<!-- What does this change do and why? -->

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Refactor / cleanup
- [ ] Documentation
- [ ] Build / CI

## Checklist (project rules — see AGENTS.md / CLAUDE.md)

- [ ] Builds locally: `msbuild AITOOL.sln -restore -p:Configuration=Debug`
- [ ] No `.Result` / `.Wait()` on Tasks; `ConfigureAwait(false)` in library/service methods
- [ ] All SQL is parameterized; no writes to ERP core tables (use the BSO object model via `ErpCreationService`)
- [ ] Logging goes through `TelemetryService` (no `Console` / `Debug.WriteLine` / raw `SentrySdk`)
- [ ] `IDisposable` honored; event handlers unsubscribed; DevExpress `RepositoryItem`s reused & disposed
- [ ] New `.cs` / `.csproj` files saved as UTF-8 **with BOM**
- [ ] No secrets committed (keys, connection strings, `.snk`/`.pfx`)
- [ ] Conventional Commit message(s)

## Notes for reviewers

<!-- Anything that needs extra attention, screenshots, or follow-ups. -->

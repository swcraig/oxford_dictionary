# Contributing to oxford_dictionary

## Adding a New API Endpoint

1. Create `lib/oxford_dictionary/endpoints/new_endpoint.rb` inheriting from `Endpoint`
2. Implement endpoint-specific methods following existing patterns (e.g., `Entries`)
3. Add lazy-initialized accessor in `Client` class
4. Create tests in `spec/endpoints/new_endpoint_spec.rb`
5. Update README.md with usage examples
6. Update CLAUDE.md if architecture changed

## Recording New VCR Cassettes

If you need to record new cassettes against the production API:
1. Set `APP_ID` and `APP_KEY` environment variables with valid credentials
2. Temporarily comment out VCR config to allow real requests, or use `VCR.turn_off!`
3. Run the test
4. VCR automatically scrubs credentials (`APP_ID` and `APP_KEY` replaced with placeholders)

## Publishing a Release

1. Update version in `lib/oxford_dictionary/version.rb`
2. Update `CHANGELOG.md` with release notes
3. Commit: `git commit -m "Bump version to X.Y.Z"`
4. Tag: `git tag vX.Y.Z && git push --tags`
5. Build and push: `gem build && gem push oxford_dictionary-X.Y.Z.gem`

## Modifying Core Behavior

**Response transformation**: Edit `Deserialize.deserialize()` to change how API responses are converted.

**Authentication/headers**: Modify `Request` class initialization and `#get` method. Ensure backwards compatibility.

**Keep CLAUDE.md up to date** when making changes to:
- Dependencies (gemspec)
- Build/test commands (Rakefile)
- Code structure or public API
- CI/CD configuration
- Ruby version requirements

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.
Hello Computer and such!

## WHY

This is a published Ruby Gem (`oxford_dictionary` on RubyGems) that wraps the [Oxford Dictionary API](https://developer.oxforddictionaries.com/documentation). Changes should maintain backward compatibility and consider the gem's public API surface.

## WHAT

**Tech Stack**: Pure Ruby, no runtime dependencies. Uses Net::HTTP, URI, JSON (stdlib). RSpec + VCR for testing.

**Core Architecture**: 
- `Client` is the public entry point; delegates to endpoint modules
- Each endpoint (Entries, Lemmas, Translations, etc.) inherits from `Endpoint` base class
- `Request` handles HTTP; `Deserialize` converts JSON to OpenStruct
- All responses are recursive OpenStruct objects

**Key Files**:
- `lib/oxford_dictionary/client.rb` — Public API
- `lib/oxford_dictionary/endpoints/` — API endpoint implementations
- `spec/` — Unit tests with VCR cassettes (production API)
- `spec/integration/` — Live API integration tests (requires credentials)

## HOW

**Setup**:
```bash
bundle install
```

**Test & Lint**:
```bash
bundle exec rake          # Unit tests + linting
bundle exec rspec         # Tests only
bundle exec rubocop       # Lint only
```

**Integration Tests** (requires Oxford Dictionary credentials):
```bash
export APP_ID=<your-id> APP_KEY=<your-key>
bundle exec rake integration
```

**Interactive Console**:
```bash
bin/console
```

## Notes

- Unit tests use VCR cassettes (offline, recorded from production API)
- Integration tests hit the live sandbox API with real credentials
- API URL configurable via `OXFORD_DICT_API_URL` env var (defaults to sandbox)
- RuboCop handles code style (see `.rubocop.yml`)

See `CONTRIBUTING.md` for publishing and advanced development tasks.

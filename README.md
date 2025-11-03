# [Your Agency] Software Standards

This document describes standards and conventions for software development of [Your Agency] technology.

## Software Standards

This guide has strong opinions on what [Your Agency] expects to see in software development patterns.

See the [18f Engineering Guide](https://guides.18f.org/engineering/) for more tools and process ideas.

### Open source

[Your Agency] software development defaults to open. This means that we use  
open source software, we release the software we create as open source,  
and development of the source is performed in a publically visible manner.

According to the Colorado Digital Service’s [Modern Software Delivery Maturity Index](https://github.com/coloradodigitalservice/modern-software-delivery-maturity-index), one of the signs of a mature modular contracting pattern is “Defaults to Open Sourcing as much code as possible.”

See the [18F open source policy](https://github.com/18F/open-source-policy/blob/master/policy.md) for further rationale and background.

See the [LICENSE](#licensemd) section for example.

### Twelve Factor patterns

[Your Agency] software architecture should follow the [Twelve-Factor App](https://www.12factor.net/) pattern.  
Vendors who develop software for [Your Agency] should be prepared to document how their design choices adhere to the Twelve Factors.

### Choosing open source languages and code

[Your Agency] technology systems follow the Software-as-a-Service (SaaS) pattern: applications are delivered and accessed over the web.
Therefore we expect [Your Agency] systems to be built using well known, best-of-breed languages, frameworks and libraries already in widespread use for web application development.

See the [Choosing dependencies](./doc/choosing-dependencies.md) guide.

### Source control

[Your Agency] uses Git and GitHub.

#### Code Owner Documentation

Teams MUST identify named reviewers per domain (Code Owners) for each top or domain level directory and maintain that list in the repository.

#### README.md

Every Git repository should contain a README in Markdown format that describes the purpose of the code in the repository  
and some instructions on development, layout and deployment. This file is an example. It's fine for the README to link to other, more detailed documentation,  
typically using the corresponding Github wiki or a top-level `doc/` directory within the repository.

Typically, a README (or linked documentation) shwould contain: language(s), framework(s), any version information about the languages and frameworks, a description of what the application does (if application code), a description of how the repository is organized (if it contains more than one code set and/or folders), and how to use if its shareable.

#### .gitignore

Every repository MUST include a `.gitignore` file to exclude generated artifacts, dependencies, build outputs, credentials, and other non-source files from version control.

`,gitingore` entries SHOULD follow the conventions fo the primary language or framework.

Teams MUST review `.gitignore` whenever importing or restructuring code to ensure that intermediate, temporary, or executable files are not tracked.

Sensitive configuration files (for example, those containing local credentials or environment variables) MUST be listed in `.gitignore` and handled through environment variables or approved secrets management processes instead.

#### LICENSE.md

All [Your Agency] software should be released with a copy of this software license (also available in this repository  
as [LICENSE.md](./LICENSE.md)).

#### Makefile

Because [Your Agency] systems can be heterogenous in terms of language and framework, we require a  
`Makefile` exists in every repository. While each language/framework may have its own  
conventions for managing dependencies and tests and supporting processes, we find a common set of make targets to ease developer cognitive overhead when moving between repositories and projects. Consider the Makefile to be like an executable README file: it both documents common tasks and processes, and allows developers to run those tasks without necessarily needing to understand all the gory details to start.

An example Makefile is included in this repository, with comments. This section of the README focuses on rationales and more in-depth discussion of why each target exists.

Note that your Makefile may have (many) more targets than those documented here, but it should have at least these targets, named this way, that perform the functions described. Some of these targets may be called during the CI/CD process, so naming is important. See the section on [Continuous Integration and Delivery].

##### make

This should print out the help statement for the Makefile. It’s equivalent to running `make help`.
Each make target should have a one-line description; those descriptions are printed next to each target for quick reference.

##### make deps

Install all the dependencies necessary to run the application. This target may be as simple as:

```
deps:  ### Install dependencies
	# for Python
	pip install -r requirements.txt
	# for JavaScript or TypeScript
	npm install
	# for Ruby
	bundle install
```

In a single repository there may be multiple languages and dependencies represented. A simple `make deps` should install everything.

##### make setup

This target should bootstrap the application so it is ready to run: initializing databases, adding seed data, harnessing any services required. For example, if the deployment target is a Docker image, this target might build the Docker image. (The Dockerfile itself may call `make deps` internally.)

Whatever your application requires in order to run `make test` should be handled by the `make setup` target.

##### make lint

All code should adhere to explicitly defined linting and formatting rules. Examples include black and flake8 for Python, rubocop for Ruby, eslint and prettier for JavaScript.

The particular tool(s) and specific rules for each language are not as important as the fact that they are enforced programmatically with the `make lint` target. Linting rules should adhere as closely to the standard out-of-the-box rule set for the tool as possible, and exceptions should be documented. The linting configuration files should be committed to the Git repository. We don’t want to waste developer time with competing ideas about the proper use of whitespace, semicolons, braces and the like. If the development team decides to deviate from a standard rule, document and enforce it via the configuration file and move on to more meaningful work. We understand how important the ergonomics of writing code are to developers, so `make lint` is intended to reduce distractions.

The `make lint` target should modify (fix) files in place so that a git diff against a fresh checkout will quickly indicate if any files were committed without being properly formatted. The [pre-commit](https://pre-commit.com/) tool can be helpful for automating the linting checks prior to committing to a branch.

The `make lint` check will be part of every standard CI check and a pull request should not be allowed to merge if the `make lint` target fails to complete without making any changes.

##### make test

The `make test` target should execute the full test suite. The test suite may include unit, integration and feature tests, with mocking of external services as needed. If the test suite is large, portions of the suite may be targeted with additional make targets (e.g. `make unit-test` or `make int-test`) for developer convenience but `make test` should run the entire suite.

The `make test` target should fail if any test fails, or if the test coverage falls below a programmatically enforced minimum. We expect test coverage for all code to be as close to 100% as possible. Code test coverage should be enforced with language-specific tools, for example [coverage](https://coverage.readthedocs.io/) for Python, [SimpleCov](https://github.com/simplecov-ruby/simplecov) for Ruby, [Jest](https://jestjs.io/) (among many others) for JavaScript. Browser-based test coverage for feature or application tests might use something like [nyc](https://github.com/istanbuljs/nyc). You should pick a coverage tool the same way you choose any other dependency.

The make test target will be executed as part of the standard CI checks. No pull request should be merged without all tests passing.

## SDLC & Delivery Standards

This section describes standards and conventions for software development lifecycle and delivery standards of [Your Agency] technology. The goal is to enforce a system that is (relatively) easy to understand and maintain without being too prescriptive.

Exceptions to guidelines MAY be granted, given a formal request. Written exceptions MUST be referenced in inline commentary when possible.

## Pull Request & Peer Review Guidelines and Requirements

### Pull Requests

Feature branches SHOULD present meaningful commits (use `–fixup`/`–autosquash`). A single squash commit is allowed, but not required, when the change reads best as one unit.

Pull Requests MUST follow the provided template. In instances where the template contains irrelevant sections, the developer MUST comment N/A or comparable; no response indicates an incomplete Pull Request.

MUST link to an Architecural Decision Record (ADR) when the Pull Request:

- Introduces breaking API changes, such as removing/renaming fields, behavior changes, or auth/permission shifts.
- Introduces new public surface areas, such as a new external endpoint, new event type/stream or new DB table.
- Changes API contracts across teams or vendors, such as when a change forces other teams to adapt their code accordingly.
- Introduces DB schema changes that affect persistence, integrity, or performance (new/changed tables, columns, indexes, constraints).
- Elevates data classification, such as introducing regulated data or changes how regulated data is handled.

MUST include updates to applicable documentation as part of the change. Documentation updates MUST be included in the same Pull Request.

Examples of required updates include (but are not limited to):

- APIs: update versioned API specifications, changelogs, and deprecation notes
- Abbreviations/Naming: update `/docs/[glossary.md](http://glossary.md)` when introducing new abbreviations
- Ownership: Update Code Owners lists or team ownership documentation when roles shift.
- System design: Update ADRs/RFS, architecture diagrams, or integration catalogs when boundaries change
- Data classification: Update data classification as part of any schema change Pull Requests

See Google’s [The CL author’s guide to getting through code review  
](https://google.github.io/eng-practices/review/developer/)  
for further information on how to write a good Pull Request.

#### Pull Request Template

Your repository should contain a `pull_request_template.md` file. See the example [pull request template](./pull_request_template.md) in this repository.

### Peer Reviews

Reviews MUST follow the provided review template. In instances where the template contains irrelevant sections, the reviewer MUST comment N/A or comparable; no response indicates an incomplete Review.

See Google’s [How to do a code review  
](https://google.github.io/eng-practices/review/developer/)  
for further information on how to perform a quality code review.

### Approvals

GitHub repository permissions MUST enforce:

- Every change MUST be reviewed and approved by at least one qualified reviewer who is not the author prior to merge.
- Authors MUST NOT approve their own changes.

Teams MUST identify named reviewers per domain (Code Owners) and maintain that list in the repository.

High-risk changes (security-sensitive, data model, public API, infra-related) MUST have _two_ reviewers, including a designated _Code Owner_.

## Branching and Merging

Default model is trunk-based with short-lived feature branches; ideally lasting no longer than a week.

Feature branches should be scoped to as few developers as possible; in most scenarios, no more than two developers should be pushing to a feature branch.

Feature branches MUST be merged via Pull/Pull Requests; fast-forwards to `main` or comparable trunk are prohibited.

`main` or comparable trunk is always deployable.

Branches should be monitored and stale branches expired.

Prior to merge, MR MUST demonstrate via CI: status checks passing, linear history, and reviewer approvals.

Branch and merge protections for core branches MUST:

- Enforce signed commits
- Prevent force-pushes and deletion

## Feature Flags

- Feature flags SHOULD be used for gradual release

## Commit, Push, and Merge Practices

- Distinct, named machine users, such as dependabot, MAY open Pull Requests for version bumps and security patches. Other system, shared, and admin accounts MUST NOT commit code. Repository RBAC MUST enforce this by limiting commit/push privileges to authorized individual or serviceidentities only.
- Main or comparable branch: direct commits to main or comparable branches are prohibited
  - All changes MUST be introduced via Pull/Pull Request
  - This rule MUST be enforced through repository branch protection settings
- Personal feature branches: Developers MAY push partial/WIP commits to their own feature branches at any time. Use Draft MRs until the changes is review-ready to reduce noise
- Shared branches: Avoid pushing half-done work to shared feature branches unless the team on that branch has explicitly agreed to it.
- Commits SHOULD be small and logically grouped; push frequently to avoid local loss
- When merging into `main` or comparable trunk, the default strategy MUST be a single commit with a meaningful commit log message. The goal is a tidy commit history on the `main` branch with each commit linking back to a single pull request. By "meaningful" we mean that the commit message should reflect the same level of detail found in the pull request template.

## Naming and Readability Standards (language-agnostic core)

### Principles

- Clarity over brevity. Names should communicate purpose without requiring inspection of the underlying definition.
- Consistency over cleverness. Prefer idiomatic style for the language.
- Searchability. Avoid opaque codes.

### Rules

- Each repository name MUST encode key ownership and context information in a predictable order, starting with at least the division and name, and optionally adding other elements like agency, environment, or type.
  - Example: CDHS-Mulesoft-JAI-Prc-Api
- Public classes, functions, and reused variables MUST be human-readable English words (eg, `calculateEligibility`, `ApplicantAccount`). Ad hoc truncations such as `acct`, `addr`, or `nm` SHOULD NOT be used.
- A glossary of common abbreviations MUST be kept in the repository. To use a new abbreviation, you MUST add it to the glossary.
- Abbreviations should be kept to common tech or civil shortcuts (`SSN`, `DOB`, `HTML`, etc) or be system, program, or state specific (`ELIG` for an eligibility system).
- There is a strong preference for spelling things out instead of adding new abbreviations to the glossary (`caseWorker` rather than `CSWRKR`).
- Function/method names should start with an action verb (load, save, validate, etc). This is not a blocker if a language’s idiom differs or existing code suggests a different structure, however, clear naming _with a clear verb_ is important for all functions.
- Classes/types MUST be nouns (`Application`, `Account`, `EligibilityRuleSet`).
- Boolean Clarity. Booleans MUST read as predicates (`isActive`, `hasDependents`).
- Constants MUST follow language idiom (often `UPPER_SNAKE_CASE`); environment variables MUST be `UPPER_SNAKE_CASE` and documented in `.env.example`.

### Conventions (non-blocking, but recommended)

- Avoid negated booleans (`!isNotValid`)--prefer the positive form (`isValid`).
- Avoid generic names (`data`, `result`, `save`) outside of very short scopes. Prefer naming that implies content (`benefitsApplicationData`, `saveHouseholdInput`)
- Prefer specific suffixes: `...Service`, `...Adapter`, etc

## Code Hygiene Standards

### Dead/Obsolete Code

MUST NOT commit commented-out code, unused files, generated artifacts, or “backup” copies (eg, `copy_of_`).

MUST remove code paths known to be unreachable or deprecated. If removal is deferred due to a release window, MUST add a deprecation marker with a tracked ticket ID and removal date.

MUST delete stale feature flags and related code within [DEFINE HOW MANY LJA] release cycle after full rollout.

### Duplication

SHOULD eliminate functionally duplicate logic by extracting a shared, testable component when:

- The duplication appears 3+ times, or
- The duplicated block exceeds ~20-30 LOC, or
- Bugs or changes would require edits in more than one place.

Local, trivial duplication (eg, 1-2 lines) MAY be tolerated.

If duplication is intentionally retained (performance, bounded context, migration), the Pull Request MUST include a brief justification and a ticket to consolidate later if appropriate.

Deliberately duplicated code MUST contain inline comments describing:

- Location of other duplication(s)
- Reason(s) for not consolidating into a shared component

### File/Function Size & Complexity Guardrails

Source files SHOULD NOT exceed ~500-800 LOC without a clear reason.

Functions/methods SHOULD NOT exceed ~40-60 LOC or a cyclomatic complexity of 10-15.

Exceeding these thresholds MAY be acceptable for adapters, data maps, or machine-generated code, but the Pull Request MUST state why and, if needed, create a ticket to refactor. Code should also include a comment explaining deviance from standards, when possible.

### Temporary/Experimental Code

Spikes or experiments MUST live under a clearly named directory (eg, `/spikes`, `/experiments`).

Such code MAY be merged to `main` for collaboration or testing in lower environments, but:

- It MUST NOT be included in production builds or deployed to production environments
- CI/CD MUST exclude spike or experiment directory paths from production build artifacts and deployments
- Production code MUST NOT reference spike or experimental code.

Experiments MUST either graduate to production standards or be removed within 30 days, tracked by a ticket.

### Logging, TODOs, and Comments

TODO/FIXME comments MUST include an owner and ticket ID.

Debug logging added for diagnostics MUST be removed or set to appropriate levels before release.

## Repository and Directory Structure

Developers MUST be able to browse a directory in standard Git hosting UIs (eg, GitHub) without hitting file count limits.

Directories MUST be organized so that no single directory contains more than 200 non-generated source files

Generated code MAY exceed this limit, but MUST be placed in a clearly marked `/generated` directory

## Database

### Single point of access

Application components MUST NOT connect directly to the database. Instead, all database access MUST be mediated through a refined data access layer (eg, DAO, service, or repository).

CI SHOULD scan for disallowed DB connection strings outside the data layer.

Schema migrations MUST be versioned and replayable.

### Query Construction

All queries MUST use parameterized statements, query builders, or ORMs.

All user-supplied values MUST be parameterized (never concatenated).

Direct/raw SQL in application feature code is prohibited.

Raw SQL MAY be used in migration or maintenance scripts when:

- The operation cannot be expressed cleanly through the data access layer or ORM, and
- The script is executed only in a controlled deployment or maintenance workflow, and
- The SQL is peer-reviewed and approved by the DBA/architecture team

### Dynamic Queries

Where dynamic query construction is required (eg, `ORDER BY`), explicit whitelisting of allowed fields and operators MUST be used; blacklist-only approaches are prohibited.

## Date/Time Handling

### Date/Time Utilities

All date/time logic MUST use either:

- the platform’s standard library, or
- A project-approved datetime utility modules/shared component

Custom parsing, formatting, or conversion code MUST NOT appear in feature code. If the standard library is insufficient, add or extend the shared library.

### Canonical storage

All persisted timestamps in databases and event logs MUST be stored in UTC.

### Transmission

Services SHOULD transmit timestamps in UTC (ISO-8601) unless a consuming system explicitly requires a different representation. Example: 2022-10-03T10:30:00Z

If a non-UTC representation is sent, the payload MUST clearly indicate the timezone.

### Presentation

Timezone-specific formatting is allowed only at the presentation edge (UI, reporting, customer communications).

## Component Boundaries

Follow the [18F guide on APIs](https://guides.18f.org/engineering/our-approach/apis/) and prefer API-first software designs.

### APIs over implicit coupling

Services MUST communicate through explicit, versioned APIs (REST, gRPC, event streams, etc).

Direct access to another service’s database, filesystems, or in-memory state is prohibited.

### Clarity of contracts

APIs MUST have published schemas (OpenAPI, JSON Schema, etc) so boundaries are testable and enforceable.

APIs SHOULD be backward compatible when possible; breaking changes MUST follow a documented versioning strategy.

### Transparency

Data flows between components MUST be visible in documentation (system diagrams, integration catalogs).

### Middleware Usage

APIs and event streams SHOULD be the default approach to system-to-system integration.

Middleware or integration-platform tools MAY be introduced only by exception and MUST receive ARB approval prior to implementation. Middleware/orchestration tools such as MuleSoft or Talend MAY be used.

Approved middleware MUST:

- Middleware MUST IiInvoke documented API endpoints; it cannot bypass contracts via hidden side channels.
- Have its flows documented outside the tool in system diagrams or integration catalogs
- Store configurations in version control
- Avoid embedding business logic that cannot be independently tested or observed

Middleware flows MUST be documented (eg, system diagrams, integration catalogs) so that data paths and transformations are visible and testable outside the middleware tool.

## Data Classification Schemes

MUST document how each system data asset (databases, tables, columns, logs, etc) is classified, and this mapping MUST be version-controlled with the repository alongside system documentation.

## Configuration

### URLS and paths

Environment-specific values (URLS, endpoints, credentials, paths) MUST be abstracted into configuration files or environment variables.

Hard-coded URLs, proxy paths, and credentials in source code are prohibited.

CI SHOULD scan for hard-coded URLs and secrets.

## Security and Compliance

MUST comply with OIT security baseline, NIST 800-53 controls, IRS Pub 1075, and all other applicable security guidelines, including:

### Authentication and Credentials

#### End-User Authentication

All end-user authentication MUST be managed through [Your Agency]'s approved identity solution.

Integrations with the identity solution MUST:

- Use standardized protocols
- Enforce MFA and password complexity policies defined by [Your Agency]
- Respect session lifetimes and token scopes issued by the IdP

All user passwords MUST be stored using a strong NIST-approved adaptive hash (e.g. PBKDF2 or scrypt).

Every password MUST be salted with a unique, per-user random salt of at least 128 bits.

Identical passwords MUST NOT result in identical stored hashes.

Password complexity and rotation MUST comply with the [Your Agency] security policy.

#### System and Service Credentials

Secrets, API keys, and certificates MUST NOT be committed to source control; they MUST be managed via an approved secrets manager.

Admin accounts MUST be covered by MFA.

Secrets used in CI/CD pipelines MUST be injected from the secrets manager; plain-text secrets in pipeline configs are prohibited.

Credentials MUST NOT be shared between environments; dev/test/stage/prod/etc MUST be isolated.

### Code and Dependencies

CI/CD MUST include automated static analysis (SAST) and dependency vulnerability scans.

Builds MUST fail on Critical/High findings unless a time-boxed waiver is approved by security.

Third-party dependencies MUST be pinned and SBOMs published per release.

### Data Handling

All primary databases, replicas, logs, snapshots, and backups MUST be protected by storage-level encryption (eg, TDE or cloud-managed at-rest encryption).

Until a formal classification scheme is fully adopted, the system MUST, at a minimum, encrypt SSNs, full account/routing numbers, full payment card numbers, and government benefit Identifiers at the cell or column level, with decryption events logged and auditable.

Other regulated data may rely on strong role-based access controls where column or cell-level encryption is not technically or operationally feasible.

Sensitive data in transit MUST use TLS 1.2+ (prefer 1.3).

No PII/FTI may be logged in plaintext.

### Audit and Evidence

All releases MUST include: SAST report, dependency vuln report, SBOM, and license compliance check.

Evidence MUST be published to the shared evidence repository.

### Secure Algorithms

Only algorithms approved by NIST ([https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines)) MAY be used.

Deprecated algorithms (MD5, SHA-1, home-grown ciphers, etc) MUST NOT be used in any new code.

Use of non-approved algorithms requires a documented waiver and CISO approval.

Encryption keys MUST be stored in an approved Key Management System.

## Testing

All new code MUSt include automated tests at the appropriate level (unit, integration, e2e).

Pull Requests MUST demonstrate passing tests in CI/CD.

Test coverage thresholds (line/branch) will be defined per repo and enforced in CI.

## Observability

All services MUST emit structured logs, metrics, and traces to the central observability platform

Services MUST expose health/readiness endpoints for monitoring.

Critical business and security events MUST generate alerts routed to the appropriate on-call rotation.

Observability data MUST be retained in accordance with [Your Agency] policy.

Observability artifacts MAY be referenced in Audit and Evidence collections.

## Accessibility

All UI elements must conform to WCAG 2.1 AA at minimum

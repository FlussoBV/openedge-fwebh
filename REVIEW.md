# `fwebh` code review — findings

**Reviewed commit:** `6395f17` (branch `main`, 2025-03-11)
**Scope:** whole repository — `src/`, `doc/`, `build.xml`, `scripts/`, `.github/workflows/`, configuration.
**Purpose:** each finding below is written to be copy-pasted into a GitHub issue. Nothing here has been changed in the code.

The library is evaluated against its own stated goals in `README.md`: a standard WebHandler implementation that lets a developer focus on business logic, and that is *"as agnostic as possible when it comes to the requirements to the consumer"*.

> **Note on severities.** Severities were normalised while writing this up and may differ slightly from the order in which findings were first raised. They reflect impact on a consumer running `fwebh` in production, not effort to fix.

> **Note on verification.** Findings are derived from reading the code, not from executing it. `F-01` in particular is a reasoned code-path analysis; the maintainers may wish to confirm it with a test before acting. Items that depend on design intent rather than fact are flagged **Needs confirmation**.

> **Note on locations.** Line numbers are given as an aid only and will drift as the code changes. Every quoted snippet includes its enclosing `method` or `constructor` statement, which is the reliable way to locate it.

---

## Index

| ID | Title | Severity | Area |
|----|-------|----------|------|
| [F-01](#f-01-accept-header-is-not-parsed--real-http-clients-receive-406) | `Accept` header is not parsed — real HTTP clients receive 406 | Critical | Content negotiation |
| [F-02](#f-02-factoryprocessdefinitions-leaks-state-between-definitions) | `Factory:ProcessDefinitions` leaks state between definitions | Critical | Core / factory |
| [F-03](#f-03-view-as-alert-box-and-swallowed-errors-in-the-serializers) | `view-as alert-box` and swallowed errors in the serializers | Critical | Serialize |
| [F-04](#f-04-notfoundexception-discards-its-message) | `NotFoundException` discards its message | High | Error handling |
| [F-05](#f-05-500-responses-leak-internal-class-names-and-runtime-messages) | 500 responses leak internal class names and runtime messages | High | Error handling |
| [F-06](#f-06-configuration-load-cost-and-the-absence-of-a-reload-path) | Configuration load cost and the absence of a reload path | Minor | Performance |
| [F-07](#f-07-singleton-scope-is-implicit-and-differs-between-debug-and-production) | `singleton` scope is implicit and differs between debug and production | Medium | Core / factory |
| [F-08](#f-08-patch-is-half-implemented-and-nested-resources-with-an-id-are-unroutable) | PATCH is half-implemented; nested resources with an id are unroutable | High | Routing |
| [F-09](#f-09-test-and-example-code-is-shipped-in-the-released-library) | Test and example code is shipped in the released library | High | Packaging |
| [F-10](#f-10-configservicesjson-maps-a-service-to-an-interface) | `config/services.json` maps a service to an interface | High | Configuration |
| [F-11](#f-11-the-authenticated-identity-never-reaches-the-service) | The authenticated identity never reaches the service | High | Agnosticism |
| [F-12](#f-12-no-unit-tests-on-the-http-boundary) | No unit tests on the HTTP boundary | High | Testing |
| [F-13](#f-13-deserializer-case-sensitivity-leaks-into-the-public-api) | Deserializer case-sensitivity leaks into the public API | Medium | Serialize |
| [F-14](#f-14-no-logging-abstraction) | No logging abstraction | Medium | Agnosticism |
| [F-15](#f-15-temp-tables-are-not-emptied-before-deserialization) | Temp-tables are not emptied before deserialization | Medium | Serialize |
| [F-16](#f-16-urlhelperdecode-is-incomplete-and-unused) | `UrlHelper:Decode` is incomplete and unused | Medium | Net |
| [F-17](#f-17-propathhelper-mutates-global-propath-unsafely) | `ProPathHelper` mutates global `propath` unsafely | Medium | Core |
| [F-18](#f-18-typos-in-the-shared-definition-include) | Typos in the shared definition include | Medium | Core |
| [F-19](#f-19-serializer-tests-cover-only-happy-paths) | Serializer tests cover only happy paths | Medium | Testing |
| [F-20](#f-20-no-consumption--installation-documentation) | No consumption / installation documentation | Medium | Documentation |
| [F-21](#f-21-readme-security-wording-and-missing-non-goals) | README security wording and missing non-goals | Medium | Documentation |
| [F-22](#f-22-handledelete-does-not-initialise-response-consistently) | `HandleDelete` does not initialise `response` consistently | Minor | WebHandler |
| [F-23](#f-23-four-near-identical-handle-methods) | Four near-identical `Handle*` methods | Minor | WebHandler |
| [F-24](#f-24-gethttperrorcode-breaks-for-subclassed-exceptions) | `getHttpErrorCode` breaks for subclassed exceptions | Minor | Error handling |
| [F-25](#f-25-placeholder-code-in-a-shipped-example) | Placeholder code in a shipped example | Minor | Examples |
| [F-26](#f-26-version-is-hardcoded-and-tags-are-not-validated) | Version is hardcoded and tags are not validated | Minor | Release |
| [F-27](#f-27-devcontainer-and-ci-target-different-openedge-versions) | Devcontainer and CI target different OpenEdge versions | Minor | Build |
| [F-28](#f-28-propath-violates-the-projects-own-linux-guidance) | `.propath` violates the project's own Linux guidance | Minor | Build |
| [F-29](#f-29-no-linting-or-static-analysis) | No linting or static analysis | Minor | CI |
| [F-30](#f-30-dead-code-httpverbs-and-defaultimplementation) | Dead code: `HttpVerbs` and `@DefaultImplementation` | Minor | Cleanup |

[Withdrawn findings](#withdrawn-findings) · [What the project does right](#what-the-project-does-right) · [Suggested sequencing](#suggested-sequencing)

---

## F-01 `Accept` header is not parsed — real HTTP clients receive 406

**Severity:** Critical  **Area:** Content negotiation

**Files**
- `src/fwebh/pas/data/RequestDataProcessor.cls:40`
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:269-285`
- `src/fwebh/pas/data/EntityWriterFactory.cls:29-47`
- `src/entitywriter.json`

**Problem**

The `Accept` header is captured verbatim and used directly as a single MIME type:

```
// RequestDataProcessor.cls
method public IRequestData ProcessRequestInfo(request as IWebRequest):
  ...
  data:Accept = getContextValue(request, "HTTP_ACCEPT").
  ...
end method.  // ProcessRequest

// ResourceWebHandler.cls
method private char handleContentType(service as Progress.Lang.Object, requestData as IRequestData, responseData as IResponseData):
  ...
  else if requestData:Accept > "" and requestData:Accept <> "*/*" then
    contentType = requestData:Accept.
  ...
end method.  // handleContentType
```

There is no comma splitting, no `q=` weighting and no ordered preference walk. `EntityWriterFactory:GetEntityWriter` then does an exact lookup, falling back to a single `type/*` guess:

```
// EntityWriterFactory.cls
method public IEntityWriter GetEntityWriter(mimeType as character):
  ...
  if (factory:Has(mimeType)) then
    entityWriter = cast(factory:GetInstance(mimeType), IEntityWriter).
  else do:
    tmp = entry(1, mimeType, "/") + "/*".
    entityWriter = cast(factory:GetInstance(tmp), IEntityWriter).
  end.
  ...
  catch err as Progress.Lang.Error :
    undo, throw new NotAcceptableException(mimeType).
  end catch.
end method.  // GetEntityWriter
```

Traced with a browser's `Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8`:

1. `factory:Has(<whole header string>)` → false.
2. `entry(1, <whole header string>, "/")` → `"text"`, so the fallback key is `"text/*"`.
3. `"text/*"` is not in `entitywriter.json` (which has `text/xml`, `text/plain`, `image/*`, `application/*`, `default`).
4. `GetInstance` throws, the `catch` converts it to `NotAcceptableException` → **406**.

The polite case fails too. `Accept: application/json, text/plain` → `entry(1,...)` is `"application"` → `"application/*"` → `BinaryEntityWriter` → which throws `NotAcceptableException` because the data type is `JSON`, not `MEMPTR`.

Only `Accept: */*` (curl's default) and an exact single-value `Accept` work, which is why the integration tests pass.

Two further defects in the same path:
- When negotiation *does* succeed, `response:ContentType` is set to the raw `Accept` string, which is not a valid `Content-Type` header value.
- The `"default"` key in `entitywriter.json` is never consulted — `GetEntityWriter` has no default branch. It is dead configuration.

**Why it matters**

Any consumer calling the API from a browser, or from an HTTP client that sends a realistic `Accept` header, gets a 406. This is the single defect most likely to make an evaluator abandon the library.

**Suggested fix**

1. Parse `Accept` into a list of `(mediaType, q)` pairs, sorted by `q` descending then by specificity.
2. For each candidate in order, resolve against the writer registry: exact match → `type/*` → `*/*` → the `default` entry.
3. Set `responseData:ContentType` to the **resolved concrete** type, never the raw header.
4. Only throw `NotAcceptableException` when every candidate fails.
5. Consider moving `Accept` parsing into its own class (e.g. `fwebh.net.AcceptHeader`) so it is unit-testable without a live request.

**Acceptance criteria**
- [ ] `Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8` returns JSON with `Content-Type: application/json`, not 406.
- [ ] `Accept: application/json, text/plain` returns JSON.
- [ ] `Accept: text/plain;q=0.9, application/json;q=0.8` prefers `text/plain`.
- [ ] `Accept: application/pdf` against a JSON-only service still returns 406.
- [ ] The `default` entry in `entitywriter.json` is used as the final fallback.
- [ ] Unit tests exist for the parser covering all of the above.

---

## F-02 `Factory:ProcessDefinitions` leaks state between definitions

**Severity:** Critical  **Area:** Core / factory

**Files**
- `src/fwebh/core/Factory.cls:101-142`

**Problem**

`classname`, `singleton` and `config` are declared once, outside the loop, and are not reset per iteration:

```
method private void ProcessDefinitions(jsonDefintions as JsonObject):

  var int i, propertyType.
  var char[] names.
  var JsonObject defintionObject.
  var JsonObject config.

  var char identifier, classname.
  var logical singleton.

  names = jsonDefintions:GetNames().
  do i = 1 to extent(names):
    identifier = names[i].
    propertyType = jsonDefintions:GetType(identifier).
    case (propertyType):
      when ...String then do: classname = ...  singleton = false. end.
      when ...Object then do:
        classname = defintionObject:GetCharacter("class").
        singleton = ...
        if defintionObject:Has("config") then
          config = defintionObject:GetJsonObject("config").   // never cleared
      end.
      otherwise do:
        // nothing                                             // classname keeps previous value
      end.
    end case.
    AddDefinition(identifier, classname, singleton, config).
  end.

end method.  // ProcessDefinitions
```

Two concrete bugs:

1. **`config` bleeds forward.** A definition with no `config` block inherits the previous definition's `config` object, which is then injected via `IConfigurable:Configure` at instantiation time (`Factory.cls:168-169`). The wrong class receives another class's configuration.
2. **`classname` bleeds forward on a malformed entry.** The `otherwise` branch is a silent no-op, so an entry whose value is a number, array or boolean is registered against the *previous* iteration's `classname`. Requesting that identifier silently returns an instance of the wrong class.

**Why it matters**

Both failures are silent and order-dependent. They produce misconfiguration that is extremely hard to trace back to its cause, and the blast radius grows with the size of the consumer's `services.json`.

**Suggested fix**

- Move `classname`, `singleton`, `config` and `defintionObject` inside the loop, or `assign classname = "", singleton = false, config = ?` at the top of each iteration.
- Replace the `otherwise` no-op with an `undo, throw new InvalidDataException(...)` naming the offending identifier and its JSON type.

**Acceptance criteria**
- [ ] A definitions file where entry 1 has `config` and entry 2 does not results in entry 2 receiving no config.
- [ ] A definitions file containing an entry whose value is not a string or object throws a named error rather than registering a bogus definition.
- [ ] Unit tests cover both cases.

---

## F-03 `view-as alert-box` and swallowed errors in the serializers

**Severity:** Critical  **Area:** Serialize

**Files**
- `src/fwebh/serialize/SimpleJsonSerializer.cls:129`
- `src/fwebh/serialize/SimpleJsonDeserializer.cls:83`
- `src/fwebh/serialize/SimpleJsonDeserializer.cls:189`
- `src/fwebh/serialize/SimpleJsonDeserializer.cls:298`

**Problem**

Four sites in library code report errors with `view-as alert-box`:

```
// SimpleJsonSerializer.cls
method public JsonObject Serialize(objectToSerialize as Progress.Lang.Object, includeClassName as logical):
  ...
    catch err1 as Progress.Lang.Error :
      message substitute("error serializing '&1': &2", prop:Name, err1:GetMessage(1)) view-as alert-box.
    end catch.
  ...
end method.  // Serialize
```

The other three are in `SimpleJsonDeserializer.cls`, in `Deserialize(jsonIn as JsonObject, className as character)`, `Deserialize(jsonIn as JsonObject, targetObj as Progress.Lang.Object)` and `deserializeList(targetObject as IListInfo, prop as Property, array as JsonArray)`.

In a PAS agent this is at best log noise and at worst a blocked session. Independently of the alert-box, **all four sites swallow the error and continue the loop**, so a partially serialized or partially deserialized object is returned to the caller with no indication that data was lost.

`Deserialize(jsonIn as JsonObject, targetObj as Progress.Lang.Object)` compounds this: it returns `?` on invalid input rather than throwing (`SimpleJsonDeserializer.cls:133-136`), and later uses `no-error` twice with no failure path, silently leaving the property unset if both attempts fail (`:153-155`).

**Why it matters**

Silent partial data loss in a serialization layer is the worst class of bug for a middleware library: the consumer's business logic receives a plausible-looking object with missing fields, and the failure surfaces far from its cause.

**Suggested fix**

- Remove every `view-as alert-box` from `src/fwebh/**`.
- Decide an explicit policy per site: either propagate (`undo, throw`) or log-and-continue via the injected logger from **F-14**. For a serializer, propagate is almost certainly correct.
- Replace the `?`-return at the top of `Deserialize(jsonIn, targetObj)` with a thrown `InvalidDataException`.
- Give the double-`no-error` block in the same method a real failure branch.

**Acceptance criteria**
- [ ] `grep -r "view-as alert-box" src/fwebh` returns nothing.
- [ ] Deserializing JSON whose value type does not match the target property raises an error naming the property.
- [ ] Deserializing a `?` / invalid JSON construct raises `InvalidDataException` rather than returning `?`.

---

## F-04 `NotFoundException` discards its message

**Severity:** High  **Area:** Error handling

**Files**
- `src/fwebh/lang/error/NotFoundException.cls:19-21`

**Problem**

```
constructor public NotFoundException(errorMessage as character):
  super("Not found", -1).
end.
```

The `errorMessage` parameter is accepted and thrown away. Every other class in `fwebh.lang.error` uses `substitute(...)` with the supplied message.

Callers therefore lose their diagnostics entirely:
- `Factory.cls:155` — `"no definition found for '&1'"`
- `ServiceFactory.cls:101` — `"service: &1, class not found: &2"`

**Why it matters**

The message is lost from the log as well as from the response, so the most common misconfiguration in the library (a service name that does not resolve) produces the least informative possible error.

**Suggested fix**

Match the sibling classes: `super(substitute("NotFoundException: &1", errorMessage), -1).`

Separately, decide whether these messages should reach the HTTP client at all — see **F-05**. The log must always retain the detail.

**Acceptance criteria**
- [ ] `new NotFoundException("no definition found for 'foo'"):GetMessage(1)` contains `foo`.
- [ ] Requesting an unregistered resource logs the resource name.

---

## F-05 500 responses leak internal class names and runtime messages

**Severity:** High  **Area:** Error handling

**Files**
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:201-230`

**Problem**

```
method private IHttpResponse handleErrors(err as Progress.Lang.Error):
  ...
  if not err:GetClass():TypeName begins "fwebh.lang.error." then
    errorMessage = err:GetClass():TypeName + ": " + err:GetMessage(1).

  response = new WebResponse().
  response:Entity = new String(errorMessage).
  response:StatusCode = errorCode.
  ...
end method.  // handleErrors
```

Any error that is not one of the library's own types is returned to the client with its ABL class name and raw runtime message — which routinely includes table names, file paths, propath fragments and `dynamic-new` failures.

**Why it matters**

This is not something the PAS Spring security layer can mitigate: the body is constructed by `fwebh` after the request has been authorised. It is the library's responsibility.

**Suggested fix**

- For any error mapping to 500, return a generic body (e.g. `{"error":"internal server error","correlationId":"..."}`) and nothing else.
- Generate a correlation id per request, include it in both the response and the log entry, so support can join the two.
- Keep the full message and call stack in the log only (via **F-14**).
- Optionally make verbose error bodies opt-in through configuration for development environments, defaulting to off.

**Acceptance criteria**
- [ ] A service throwing `Progress.Lang.AppError("connection to db 'sports' failed")` returns a body containing neither `sports` nor `Progress.Lang.AppError`.
- [ ] The same request writes the full message and call stack to the log, tagged with the correlation id returned to the client.
- [ ] `fwebh.lang.error.*` exceptions continue to return their own messages (they are written for consumption).

---

## F-06 Configuration load cost and the absence of a reload path

**Severity:** Minor  **Area:** Performance

> **Corrected after maintainer feedback.** An earlier draft of this finding claimed the configuration was re-read from disk on *every* request, and rated it High. That was wrong. PAS holds the WebHandler instance statically in its own internals and reuses it; only one instance exists per ABL session in a production configuration. Per-request instantiation happens only when the `srvrDebug` property is set to `1`. The finding is retained in reduced form.

**Files**
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:40-43`
- `src/fwebh/pas/service/ServiceFactory.cls:34-38, 78-117`
- `src/fwebh/pas/data/EntityWriterFactory.cls:24-27, 49-68`

**Problem**

The constructor performs all definition loading:

```
constructor public ResourceWebHandler():
  serviceFactory = new ServiceFactory().
  writerFactory = new EntityWriterFactory().
end.
```

Each construction performs:
- `search()` + `ObjectModelParser:ParseFile` of `services.json`
- one `SimpleJsonDeserializer:Deserialize` per registered service
- `file-info` probe + parse of `entitywriter.json`
- **two `search()` calls per registered service** via `classExists` (`ServiceFactory.cls:108-117`)

In production this runs once per session, which is acceptable. Two smaller issues remain:

1. **Debug configurations pay it per request.** With `srvrDebug=1` PAS constructs a new handler per request, so with 30 services that is roughly 60 filesystem probes plus two JSON parses per call. Developers see a performance profile that does not match production, and any state held on the handler behaves differently — see **F-07**.
2. **There is no reload path and no documentation of the lifetime.** Because the instance is static, editing `services.json` has no effect until the agent is recycled. Nothing in `doc/` says so.

**Why it matters**

Low production impact. The value is in making the lifetime explicit so consumers know a config change needs an agent recycle, and so the dev/prod divergence is a documented property rather than a surprise.

**Suggested fix**

- Move definition loading into session-static state so the cost and the lifetime are the same regardless of `srvrDebug`. `Factory:Instance` (`Factory.cls:48`) already exists for this purpose but is unused by `ServiceFactory` — see **F-07**.
- Perform the `classExists` validation once per session at load.
- Provide an explicit `ReloadDefinitions()` entry point for development, and document that definitions are read once per ABL session.

**Acceptance criteria**
- [ ] `services.json` and `entitywriter.json` are parsed at most once per ABL session, with `srvrDebug` on or off.
- [ ] `classExists` runs once per service per session.
- [ ] `doc/services-config.md` states that a definition change requires an agent recycle, and a documented mechanism exists to force a reload.

---

## F-07 `singleton` scope is implicit and differs between debug and production

**Severity:** Medium  **Area:** Core / factory  **Needs confirmation**

**Files**
- `src/fwebh/pas/service/ServiceFactory.cls:34-38`
- `src/fwebh/core/Factory.cls:48, 55-57`
- `doc/services-config.md:18`

**Problem**

`ServiceFactory` constructs a fresh `Factory` rather than using the static `Factory:Instance`:

```
constructor public ServiceFactory():
  factory = new Factory().
  ...
```

The lifetime of a `"singleton": true` service is therefore the lifetime of the enclosing `ServiceFactory`, which is the lifetime of the `ResourceWebHandler` instance — and that is decided by PAS, not by `fwebh`:

- **Production** (`srvrDebug` unset): the handler is held statically by PAS, so the factory and its singletons live for the whole ABL session. State does leak across requests, exactly as `doc/services-config.md:18` warns.
- **Debug** (`srvrDebug=1`): the handler is constructed per request, so a "singleton" is scoped to a single request and the warning does not apply.

> *"Although singletons are possible, it is not recommended since this may leave state."* — `doc/services-config.md:18`

**Why it matters**

`singleton` is part of the public configuration contract, but its actual scope is an emergent property of a PAS setting rather than something `fwebh` states or controls. A stateful singleton will pass every test on a debug configuration and leak state in production. The static `Factory:Instance` — which would make the scope explicit and independent of `srvrDebug` — exists but is unused.

**Suggested fix**

Decide the intended lifetime scope explicitly — request, session/agent, or both — and:
- If **request** is intended: rename the key (e.g. `"reusePerRequest"`) and hold the `Factory` in per-request state explicitly, so the scope does not depend on `srvrDebug`.
- If **session** is intended: use `Factory:Instance`, and document clearly that singleton services must be stateless and safe with respect to PAS agent/session pooling.
- Ideally support both via an explicit `"scope": "request" | "session"` value, defaulting to `request`.

Whichever is chosen, the resulting lifetime must be identical with `srvrDebug` on and off.

**Open question for the maintainers:** is the `new Factory()` in `ServiceFactory` a deliberate choice, or an oversight that happens to inherit the PAS handler lifetime? The correct fix depends on the answer, and this finding should not be actioned before it is settled.

**Acceptance criteria**
- [ ] The intended scope is documented in `doc/services-config.md`, including its relationship to the PAS handler lifetime.
- [ ] Singleton lifetime is the same with `srvrDebug=1` and with it unset.
- [ ] A test demonstrates the documented lifetime.

---

## F-08 PATCH is half-implemented; nested resources with an id are unroutable

**Severity:** High  **Area:** Routing

**Files**
- `src/fwebh/pas/service/IPatchDataService.cls`
- `src/fwebh/pas/service/ServiceFactory.cls:45-48`
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls`
- `src/fwebh/net/HttpVerbs.cls`
- `src/fwebh/pas/webhandlers/ROOT.handlers:5-9`

**Problem**

Two routing gaps:

1. **PATCH.** `IPatchDataService` exists and `ServiceFactory:GetPatchDataService` exists, but `ResourceWebHandler` has no `HandlePatch` override. PATCH therefore falls through to `WebHandlerCommon:HandleNotImplemented` and returns 501. A consumer can implement `IPatchDataService`, register it, and never be called.

2. **Nested resource with an id.** `ROOT.handlers` declares:
   ```
   /v{version}/{parentResource}/{parentId}/{resource}
   /v{version}/{resource}/{id}
   /v{version}/{resource}
   /v{version}
   ```
   There is no `/v{version}/{parentResource}/{parentId}/{resource}/{id}`, so `PUT /v1/orders/42/lines/7` cannot be routed even though `ResourceDescriptor` models `ParentName`, `ParentId` and `Id` for exactly that shape.

**Why it matters**

Both are advertised capabilities that silently do not work. `ResourceDescriptor` and `IPatchDataService` are the public contract; a consumer reasonably assumes they are wired up.

**Suggested fix**

- Add `HandlePatch` to `ResourceWebHandler`, mirroring the other verbs (ideally as part of **F-23**).
- Add the five-segment template to `ROOT.handlers`.
- Either use `HttpVerbs` (**F-30**) in the dispatch logic, or delete it.

**Acceptance criteria**
- [ ] A service implementing `IPatchDataService` receives `PATCH` requests.
- [ ] `PATCH` against a service that does not implement `IPatchDataService` returns 405, not 501.
- [ ] `GET /v1/orders/42/lines/7` populates `ParentName=orders`, `ParentId=42`, `Name=lines`, `Id=7`.
- [ ] Integration tests cover both.

---

## F-09 Test and example code is shipped in the released library

**Severity:** High  **Area:** Packaging

**Files**
- `build.xml:60-69` (compile fileset), `build.xml:91-97` (PL packaging)
- `.github/workflows/build.yaml` — *Copy extra files* step
- `.github/workflows/release.yaml` — *Bundle release artifacts* step
- `src/services.json`
- `src/fwebh/pas/service/system/CiTestService.cls`
- `src/test/**`

**Problem**

The compile fileset includes everything under `src` except `.builder`, `devtools`, `sandbox` and `test-*.p`. The PL packaging excludes only `**/*_UT.r`. Consequently `fwebh.pl` contains:

- `test.serialize.*` fixtures (`Address`, `PersonList`, `ListTest`, …)
- `fwebh.pas.service.example.*` (`PdfService`, `TempTableService`)
- `fwebh.pas.service.system.*` (`EchoService`, `EchoPostData`, `SystemInfoService`, `CiTestService`)

`CiTestService` exists solely to throw arbitrary HTTP errors on demand (`CiTestService.cls:42-54`).

The release zip additionally ships the CI `services.json`, which registers all of them:

```
{
  "echo": {...}, "pdf": {...}, "sysinfo": {...}, "temptable": {...}, "test": {...}
}
```

**Why it matters**

This is primarily distribution hygiene rather than a security hole — PAS Spring rules covering the API URI space will cover these endpoints too. But a consumer taking the path of least resistance and deploying the shipped `services.json` and `ROOT.handlers` ends up with live `/v1/test?error=500`, `/v1/echo` and `/v1/sysinfo` endpoints, and a production library carrying test fixtures it will never use.

**Suggested fix**

- Move `src/test/**` and the example/system services to a source tree excluded from the compile fileset used for packaging (or add explicit `<exclude>` patterns to the `PCTLibrary` fileset).
- Ship `services.json.example` rather than a populated `services.json`, or ship an empty `{}`.
- If the example services are valuable as documentation, publish them as a separate `fwebh-examples.pl` artifact that is not part of the main library.
- Keep `CiTestService` in the repository for integration tests, but never in a release artifact.

**Open question for the maintainers:** are the example services intended to be consumable by adopters as working references, or purely internal test scaffolding? If the former, a separate artifact is the right answer; if the latter, exclude them outright.

**Acceptance criteria**
- [ ] `prolib fwebh.pl -list` contains no `test.*`, no `*.example.*` and no `CiTestService`.
- [ ] The release zip does not contain a `services.json` that registers the demo endpoints.

---

## F-10 `config/services.json` maps a service to an interface

**Severity:** High  **Area:** Configuration

**Files**
- `config/services.json`

**Problem**

```
{
  "system-info": "fwebh.pas.service.IGetDataService"
}
```

This maps a service name to an **interface**. `dynamic-new("fwebh.pas.service.IGetDataService")` cannot succeed, so the entry could never work. The file is tracked in git, referenced by nothing in `build.xml` or the workflows, and contradicts `src/services.json`.

**Why it matters**

`doc/services-config.md:8` explicitly suggests *"make a separate directory called `config` and put that first in your propath"*. A consumer following that advice will find this file first, and it is both broken and in a different format (bare string rather than `{"classname": ...}`) from every other example.

**Suggested fix**

Delete the file, or replace it with a correct, clearly-labelled example that matches the documented format and the format `ServiceDescription` expects.

**Acceptance criteria**
- [ ] `config/services.json` is either removed or contains a valid, loadable configuration.
- [ ] Its format matches `doc/services-config.md`.

---

## F-11 The authenticated identity never reaches the service

**Severity:** High  **Area:** Agnosticism

**Files**
- `src/fwebh/pas/data/RequestDataProcessor.cls:29-50`
- `src/fwebh/pas/data/IRequestData.cls`
- `src/fwebh/pas/webhandlers/context-examples.md:50, 60, 102`

**Problem**

Authentication and authorization are correctly delegated to the PAS Spring layer (see [Withdrawn findings](#withdrawn-findings)). Spring then populates the request context with the authenticated identity — the project's own `context-examples.md` documents the hooks:

```
"AUTH_TYPE": "",                          // line 50
"REMOTE_USER": "",                        // line 60
"clientPrincipal": {}                     // line 102 (currentRequestInfo)
```

`RequestDataProcessor` reads `REQUEST_METHOD`, `CONTENT_TYPE` and `HTTP_ACCEPT` and stops. Nothing anywhere in `src/fwebh` references `REMOTE_USER`, `AUTH_TYPE` or the client-principal.

**Why it matters**

This is an agnosticism gap, not a security gap. A service needing *"who is calling?"* — for tenant scoping, row-level filtering, or an audit trail — must reach around `fwebh` into `session:current-request-info:ClientPrincipal` directly. That:

- breaks the abstraction the library exists to provide;
- makes the service untestable without a live PAS request, defeating the clean `IRequestData` → service contract;
- pushes every consumer to reimplement the same context plumbing.

**Suggested fix**

- Add read-only `UserName` (from `REMOTE_USER`) and `AuthType` (from `AUTH_TYPE`) properties to `IRequestData` / `RequestData`, populated in `RequestDataProcessor`.
- Consider exposing the client-principal itself, or a small read-only wrapper over it, for consumers that need roles or custom properties.
- Document clearly that these are *informational* — enforcement stays in Spring.

**Acceptance criteria**
- [ ] `IRequestData` exposes the authenticated user name and auth type.
- [ ] A service can be unit-tested against a mock `IRequestData` carrying a user name.
- [ ] `doc/services-development.md` explains that these values are populated by PAS security and are not enforced by `fwebh`.

---

## F-12 No unit tests on the HTTP boundary

**Severity:** High  **Area:** Testing

**Files**
- `src/fwebh/pas/data/RequestDataProcessor.cls` — no `_UT`
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls` — no `_UT`
- `src/fwebh/pas/webhandlers/WebHandlerCommon.cls` — no `_UT`

**Problem**

There are 10 `_UT` classes against roughly 50 source classes. The entire HTTP boundary — request parsing, content negotiation, error mapping, response construction — has no unit tests. Coverage exists for the entity writers, the factories and the serializers, but not for the code that orchestrates them.

**Why it matters**

**F-01** would have been caught immediately by a single test. `handleContentType`, `getHttpErrorCode` and `normalizeHeaderName` are effectively pure functions and are trivially testable; they are also the highest-churn, highest-risk code in the library.

**Suggested fix**

- Extract `Accept` parsing / content-type resolution into a testable class (see **F-01**) and test it directly.
- Test `getHttpErrorCode` for every `fwebh.lang.error` type plus an unmapped type.
- Test `normalizeHeaderName` (`RequestDataProcessor.cls:177-207`) for `CONTENT_TYPE`, `HTTP_X_FORWARDED_FOR`, single-character and empty input.
- Introduce a mock `IWebRequest` so `ProcessRequestInfo` can be tested end-to-end without PAS.

**Acceptance criteria**
- [ ] `RequestDataProcessor` has a `_UT` covering header normalisation, path parameters and body dispatch for each `Progress.Lang.Object` entity type.
- [ ] Content-type resolution has a `_UT` covering the cases listed in **F-01**.
- [ ] Error-code mapping has a `_UT` covering all mapped types and the `otherwise` branch.

---

## F-13 Deserializer case-sensitivity leaks into the public API

**Severity:** Medium  **Area:** Serialize

**Files**
- `src/fwebh/serialize/SimpleJsonDeserializer.cls:153-155, 183`
- `src/fwebh/pas/service/ServiceDescription.cls`
- `coding-standards.md:13`

**Problem**

`SimpleJsonDeserializer` matches JSON keys to ABL property names case-sensitively, with an `lc()` fallback applied only to primitive types:

```
method public Progress.Lang.Object Deserialize(jsonIn as JsonObject, targetObj as Progress.Lang.Object):
  ...
  dynamic-property(targetObj, prop:Name) = dynamic-invoke(jsonIn, getter, prop:Name) no-error.
  if (error-status:error) then
    dynamic-property(targetObj, prop:Name) = dynamic-invoke(jsonIn, getter, lc(prop:Name)) no-error.
  ...
end method.  // Deserialize
```

Nested object deserialization, further down the same method (`:183`), has no fallback at all.

The consequence is visible in the library's own public API: `ServiceDescription` declares `classname` and `singleton` in lowercase, violating the project's own standard —

> *"public/protected properties: PascalCase"* — `coding-standards.md:13`

— purely so the case-sensitive deserializer will match the lowercase JSON keys in `services.json`.

**Why it matters**

An implementation detail of the serializer is dictating the naming of the public configuration contract, and forcing a documented coding standard to be broken. Any consumer extending `ServiceDescription` (which `doc/services-config.md:33` explicitly invites) inherits the constraint.

**Suggested fix**

- Make property matching case-insensitive consistently, for nested objects and collections as well as primitives. Build a name map from `GetProperties()` once per type rather than relying on `no-error` retries.
- Then rename `ServiceDescription` properties to `ClassName` / `Singleton`, keeping the lowercase JSON keys working.
- Document the matching rule in `src/fwebh/serialize/readme.md`.

**Acceptance criteria**
- [ ] `{"classname": "..."}`, `{"ClassName": "..."}` and `{"CLASSNAME": "..."}` all deserialize into the same property.
- [ ] Case-insensitive matching applies to nested objects and lists.
- [ ] `ServiceDescription` complies with `coding-standards.md`.

---

## F-14 No logging abstraction

**Severity:** Medium  **Area:** Agnosticism

**Files**
- `src/fwebh/pas/service/ServiceFactory.cls:91, 100`
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:213-218`
- `src/fwebh/pas/service/system/EchoService.cls:67, 74, 124, 131`
- `src/fwebh/serialize/*` (see **F-03**)

**Problem**

`message` is the logging mechanism throughout. `ResourceWebHandler` writes a fixed banner on every 500:

```
method private IHttpResponse handleErrors(err as Progress.Lang.Error):
  ...
  if errorCode = 500 then do:
    message "******************** start 500 error ********************".
    message err:GetMessage(1).
    message replace(err:CallStack, ",", "~n  ").
    message "******************** end 500 error ********************".
  end.
  ...
end method.  // handleErrors
```

`ServiceFactory` logs `"Loading &1 services"` unconditionally on every construction — once per session in production, once per request under `srvrDebug=1` (see **F-06**).

**Why it matters**

This is an agnosticism failure. Middleware must not monopolise the consumer's log channel or dictate its format. A consumer cannot set a level, filter these entries, route them to a different appender, or turn them off. `OpenEdge.Logging` is already available on the propath via `OpenEdge.Core.pl`.

**Suggested fix**

- Introduce an injectable `ILogWriter` (or use `OpenEdge.Logging.LoggerBuilder` directly), resolved through the existing `Factory` so consumers can substitute their own.
- Replace every `message` in `src/fwebh/**` with a levelled call: `Error` for 500s, `Debug` for definition loading.
- Remove the banner formatting; let the log framework handle presentation.

**Acceptance criteria**
- [ ] `grep -rn "^\s*message " src/fwebh` returns nothing outside example services.
- [ ] Log level and destination are configurable by the consumer without modifying `fwebh`.
- [ ] Definition loading logs at debug level, not unconditionally.

---

## F-15 Temp-tables are not emptied before deserialization

**Severity:** Medium  **Area:** Serialize

**Files**
- `src/fwebh/serialize/SimpleJsonDeserializer.cls:366-393`

**Problem**

`jsonArrayToTempTable(array as JsonArray, bufferHandle as handle)` calls `bufferHandle:buffer-create()` per JSON record with no preceding `empty temp-table`. Deserializing twice into the same target accumulates rows rather than replacing them.

**Why it matters**

Silent data corruption on the second call. Given **F-07**'s ambiguity around instance reuse, a consumer cannot easily reason about whether their target temp-table is fresh.

**Suggested fix**

Empty the target buffer's table before populating, or make the behaviour an explicit, documented parameter (`append` vs `replace`) defaulting to replace.

**Acceptance criteria**
- [ ] Deserializing the same 3-record JSON array twice into one temp-table yields 3 rows, not 6.
- [ ] A unit test covers repeated deserialization.

---

## F-16 `UrlHelper:Decode` is incomplete and unused

**Severity:** Medium  **Area:** Net

**Files**
- `src/fwebh/net/UrlHelper.cls:17-20`
- `src/fwebh/pas/data/RequestDataProcessor.cls:13`

**Problem**

```
method public static character Decode(urlEntry as character):
  urlEntry = replace(urlEntry, "%20", " ").
  return urlEntry.
end method.
```

It handles `%20` and nothing else — no `+`, no other percent-escapes, no UTF-8 multi-byte sequences. It is `using`-imported by `RequestDataProcessor` but never called.

**Why it matters**

Dead code that presents as a supported utility. The first consumer to find it and use it for real URL decoding will get silently wrong results for any input containing `%2F`, `%C3%A9`, `+`, etc.

**Suggested fix**

Delete it and remove the unused `using`. If URL decoding is genuinely needed, implement it fully (percent-decode all octets, then interpret as UTF-8) with tests — or delegate to the OpenEdge `Net` library, which already handles this.

**Acceptance criteria**
- [ ] Either `UrlHelper` is removed along with its unused import, or `Decode` correctly handles `+`, arbitrary `%XX` and multi-byte UTF-8, with unit tests.

---

## F-17 `ProPathHelper` mutates global `propath` unsafely

**Severity:** Medium  **Area:** Core

**Files**
- `src/fwebh/core/ProPathHelper.cls:16-21`

**Problem**

```
method public static void AddFirstEntry(dir as char):
  propath = dir + "," + propath.
end method.

method public static void RemoveFirstEntry():
  propath = substring(propath, index(propath, ",") + 1).
end method.
```

`RemoveFirstEntry` does not verify that it is removing what `AddFirstEntry` added. Any interleaving, exception between the two calls, or unbalanced call permanently corrupts the session propath.

**Why it matters**

Currently used only in tests (`EntityWriterFactory_UT.cls:87-104`, `ServiceFactory_UT.cls`), but it is public API in `fwebh.core` and therefore fair game for consumers. A corrupted propath in a pooled PAS agent affects every subsequent request handled by that agent.

**Suggested fix**

- Have `RemoveFirstEntry` take the expected value and assert it matches before removing, or return a token from `AddFirstEntry` that must be passed back.
- Ensure test usages restore the propath in a `finally` block.
- If it is genuinely test-only, move it out of `fwebh.core` into the test tree (aligning with **F-09**).

**Acceptance criteria**
- [ ] Unbalanced or out-of-order use cannot silently corrupt the propath.
- [ ] All test usages restore state in `finally`.

---

## F-18 Typos in the shared definition include

**Severity:** Medium  **Area:** Core

**Files**
- `src/fwebh/core/ttfactorydef.i`
- `src/fwebh/core/Factory.cls` (throughout)

**Problem**

`ttdefintion` (should be `ttdefinition`) and `indentifier` (should be `identifier`), plus `jsonDefintions` and `defintionObject` in `Factory.cls`.

**Why it matters**

`ttfactorydef.i` is an **include**, so any consumer writing their own `IFactory` implementation against it inherits the misspellings into their code. Misspelled identifiers also defeat grep-based navigation, which `coding-standards.md:157` explicitly calls out as a reason for its `using` conventions.

**Suggested fix**

Rename throughout. This is a mechanical change confined to `Factory.cls`, `Factory_UT.cls` and `ttfactorydef.i`. Worth doing before the library gains external users, since the include is part of the extension surface.

**Acceptance criteria**
- [ ] No occurrences of `defintion` or `indentifier` remain in `src/`.
- [ ] Build and unit tests pass.

---

## F-19 Serializer tests cover only happy paths

**Severity:** Medium  **Area:** Testing

**Files**
- `src/fwebh/serialize/SimpleJsonSerializer_UT.cls`
- `src/fwebh/serialize/SimpleJsonDeserializer_UT.cls`

**Problem**

18 tests across both classes, all asserting successful round-trips against template files. Missing entirely:

- `?` / unknown values, and JSON `null`
- type mismatches (string where decimal expected)
- missing and extra JSON properties
- `logical`, `date`, `datetime`, `datetime-tz`, `decimal` precision, `int64`, `memptr`
- empty arrays and empty temp-tables
- serialize → deserialize → compare round-trip fidelity
- the temp-table-with-object-field path (`test-tt-with-object.p` exists but is a manual procedure, not an ABLUnit test)

**Why it matters**

The gaps line up precisely with the defects in **F-03**, **F-13** and **F-15**. `datetime-tz` in particular is handled inconsistently between the two classes (`SimpleJsonDeserializer.cls:410` checks `"datetime-tz"`; the serializer's type list uses `datetimetz`), and no test would catch it.

**Suggested fix**

Add error-path and type-coverage tests as listed above. Prioritise round-trip tests — they catch asymmetries between the serializer and deserializer cheaply.

**Acceptance criteria**
- [ ] Every ABL datatype in the serializer's supported list has a round-trip test.
- [ ] `?` and JSON `null` have defined, tested behaviour.
- [ ] Type mismatches produce a tested, named error.
- [ ] `test-tt-with-object.p` is converted to an ABLUnit test.

---

## F-20 No consumption / installation documentation

**Severity:** Medium  **Area:** Documentation

**Files**
- `README.md`
- `doc/`

**Problem**

`README.md` links the coding standards and the service docs, but nothing explains how to *install* the library. A consumer receives `fwebh.pl`, `services.json`, `entitywriter.json` and `ROOT.handlers` from the release zip with no guidance on:

- where `fwebh.pl` goes and where it belongs in the propath
- where `services.json` and `entitywriter.json` must live *relative to the consumer's own copies*, given both are resolved by bare `search()` (`JSON.cls:27`, `EntityWriterFactory.cls:55`) — first match in the propath wins
- how `ROOT.handlers` merges with, or replaces, an existing handlers file
- which OpenEdge version is required
- how to override an entity writer or add a new MIME type

**Why it matters**

For a middleware library this is the single most important missing document. The propath-ordering question in particular is a trap: **F-09** and **F-10** both become live problems precisely because resolution order is undocumented.

**Suggested fix**

Add `doc/installation.md` covering the above, linked from `README.md`. Include a minimal worked example: one service class, one `services.json` entry, one `ROOT.handlers` entry, and the resulting URL.

**Acceptance criteria**
- [ ] A developer who has never seen the project can deploy it and serve one endpoint using only the documentation.
- [ ] Propath resolution order for both JSON config files is documented explicitly.

---

## F-21 README security wording and missing non-goals

**Severity:** Medium  **Area:** Documentation

**Files**
- `README.md:6`

**Problem**

> *"Another pro is that since the HTTP stuff is handled by `fwebh` it is easier to implement security measures, because the logic for that is centralized."*

This reads as though `fwebh` provides security functionality. It does not, and — correctly — it should not: authentication and authorization belong in the PAS Spring layer (`oeablSecurity.csv` / `appSecurity-*.xml`), where rogue requests are rejected before an ABL session is involved. JWT and OERealm are handled there.

**Why it matters**

The current wording invites exactly the wrong conclusion, in both directions: an evaluator may assume protection that is not there, or may conclude the library is naive about security when the delegation is in fact a deliberate and correct design decision. Stating the delegation explicitly is a *stronger* claim than the current vague one.

**Suggested fix**

- Rewrite the sentence to state that authentication and authorization are PAS/Spring concerns, configured in `oeablSecurity.csv`, and that `fwebh` deliberately does not duplicate them.
- Add a **Non-goals** section to `README.md` listing what is intentionally out of scope: authentication, authorization, CORS, rate limiting, TLS termination — all PAS / Tomcat / reverse-proxy responsibilities.
- Cross-reference **F-11** (identity is surfaced to services, but never enforced by `fwebh`).

**Acceptance criteria**
- [ ] `README.md` no longer implies `fwebh` implements security measures.
- [ ] A Non-goals section exists and names the PAS-side mechanism.

---

## F-22 `HandleDelete` does not initialise `response` consistently

**Severity:** Minor  **Area:** WebHandler

**Files**
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:141-168`

**Problem**

`HandleGet`, `HandlePost` and `HandlePut` all begin with `response = new WebResponse().` inside the `do on error` block. `HandleDelete` omits it.

Harmless today because the `catch` assigns `response` on every error path, but it is an inconsistency that invites a null-reference bug during future edits.

**Suggested fix**

Resolve as part of **F-23**, or add the missing line.

**Acceptance criteria**
- [ ] All verb handlers follow an identical structure.

---

## F-23 Four near-identical `Handle*` methods

**Severity:** Minor  **Area:** WebHandler

**Files**
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:45-168`

**Problem**

`HandleGet`, `HandlePost`, `HandlePut` and `HandleDelete` are ~30 lines each and differ only in the service interface, the factory getter and the service method invoked. Roughly 100 lines are duplicated four times.

**Why it matters**

Every fix in this area must be applied four times, and **F-22** shows the drift has already begun. Adding PATCH (**F-08**) currently means a fifth copy.

**Suggested fix**

Extract a single private dispatch method taking the verb, resolving the service through one `getFromFactory`-style call, and invoking it. `ServiceFactory:getFromFactory` (`ServiceFactory.cls:65-76`) already demonstrates the pattern — the typed getters are thin wrappers over a string-keyed lookup, so the handler can do the same.

**Acceptance criteria**
- [ ] Adding a new verb requires changing one place.
- [ ] Existing integration tests pass unchanged.

---

## F-24 `getHttpErrorCode` breaks for subclassed exceptions

**Severity:** Minor  **Area:** Error handling

**Files**
- `src/fwebh/pas/webhandlers/ResourceWebHandler.cls:233-266`

**Problem**

The mapping dispatches on exact `TypeName` string equality:

```
method private int getHttpErrorCode(err as Progress.Lang.Error):
  ...
  case err:GetClass():TypeName:
    when "fwebh.lang.error.BadRequestException" then errorCode = 400.
    ...
    otherwise errorCode = 500.
  end case.
  ...
end method.  // getHttpErrorCode
```

A consumer subclassing `fwebh.lang.error.NotFoundException` to add domain context gets 500 instead of 404. The same string-prefix approach in `handleErrors` also determines whether the message is exposed.

**Why it matters**

Subclassing the provided exceptions is a natural extension point for an "agnostic" library, and it silently does the wrong thing. `NotImplementedException` and `InvalidDataException` / `InvalidFormatException` are also defined but absent from the mapping, so they fall through to 500.

**Suggested fix**

Use `err:GetClass():IsA("fwebh.lang.error.NotFoundException")` in a most-specific-first chain, or add an `HttpStatusCode` property to a common `fwebh.lang.error` base class and read it directly — the latter is cleaner and lets consumers define their own mapped exceptions.

**Acceptance criteria**
- [ ] A consumer subclass of `NotFoundException` returns 404.
- [ ] `NotImplementedException` maps to 501 and `InvalidDataException` / `InvalidFormatException` to a deliberate code.
- [ ] Unit tests cover base classes and subclasses.

---

## F-25 Placeholder code in a shipped example

**Severity:** Minor  **Area:** Examples

**Files**
- `src/fwebh/pas/service/system/SystemInfoService.cls`

**Problem**

```
method public IResponseData GetData(request as IRequestData):
  ...
  if (request:Accept = "..." ) then
    response:ContentType = "application/json".
  ...
end method.  // GetData
```

A literal `"..."` placeholder in a service that ships in the release artifact (see **F-09**) and is registered in the default `services.json`.

**Suggested fix**

Remove the dead conditional, or complete it. If `SystemInfoService` is intended as the canonical example for new adopters, it should be exemplary.

**Acceptance criteria**
- [ ] No placeholder literals remain in services that ship.

---

## F-26 Version is hardcoded and tags are not validated

**Severity:** Minor  **Area:** Release

**Files**
- `openedge-project.json:3`
- `.github/workflows/release.yaml`

**Problem**

`openedge-project.json` declares `"version": "1.0"` and is never reconciled with the git tag. The release workflow takes the tag verbatim (`tag=\`echo ${{ github.ref }} | cut -d / -f 3\``) with no semver validation, and `allowUpdates: true` permits an existing release to be overwritten.

**Why it matters**

Consumers cannot determine which version of the library they are running from its contents. `version.git.info` carries the SHA but not the release version.

**Suggested fix**

- Validate the tag against a semver pattern and fail the workflow if it does not match.
- Inject the tag into `version.git.info` and, ideally, into a compiled constant so the running version is introspectable.
- Reconsider `allowUpdates: true` for published releases.

**Acceptance criteria**
- [ ] A non-semver tag fails the release workflow.
- [ ] The released artifact records its own version.

---

## F-27 Devcontainer and CI target different OpenEdge versions

**Severity:** Minor  **Area:** Build

**Files**
- `.devcontainer/.env:3, 6` — PAS and DB images at `12.8.11`
- `.github/workflows/ci.yaml` / `release.yaml` — compiler matrix at `12.8.6`

**Problem**

Local development runs against 12.8.11; CI compiles and tests against 12.8.6.

**Why it matters**

Version-specific behaviour that works locally can fail in CI, or vice versa — and only one of the two is what gets released.

**Suggested fix**

Align the versions, or drive both from a single variable. If deliberately testing across versions, make it an explicit matrix rather than an incidental mismatch.

**Acceptance criteria**
- [ ] Devcontainer and CI use the same OpenEdge version, or the divergence is documented and intentional.

---

## F-28 `.propath` violates the project's own Linux guidance

**Severity:** Minor  **Area:** Build

**Files**
- `.propath:3-5, 9`
- `src/.propath`
- `coding-standards.md` — *Linux* section

**Problem**

Entries use Windows backslashes while declaring `platform="All"`:

```
<propathentry env="all" kind="dir" path="@{WORK}\src" platform="All"/>
<propathentry env="all" kind="lib" path="@{DLC}\tty\ablunit.pl" platform="Windows"/>
```

`ablunit.pl` is additionally restricted to `platform="Windows"` with no Linux equivalent.

The project's own coding standards have a *Linux* section mandating correct path separators and case.

**Why it matters**

Contradicts documented policy, and would break IDE-driven builds on Linux. CI is unaffected because `build.xml` constructs its own propath.

**Suggested fix**

Use forward slashes with `platform="All"`, and add a Linux `ablunit.pl` entry (or make it platform-neutral).

**Acceptance criteria**
- [ ] The project opens and builds in the IDE on Linux.
- [ ] `.propath` complies with the Linux section of `coding-standards.md`.

---

## F-29 No linting or static analysis

**Severity:** Minor  **Area:** CI

**Files**
- `.github/workflows/ci.yaml`
- `coding-standards.md`

**Problem**

There is a detailed 290-line coding standard and nothing in CI enforces any of it. Several findings above are standards violations that a linter would have caught: **F-13** (PascalCase properties), **F-18** (spelling), **F-28** (path separators), and the `view-as alert-box` uses in **F-03**.

**Suggested fix**

Add a lint job to `ci.yaml`. Even a small set of grep-based checks would be valuable as a first step — no `view-as alert-box` in `src/fwebh`, no bare `message`, no `using ... .*` wildcards, `block-level on error undo, throw` present in every `.cls`. Prolint or an ABL formatter can follow.

**Acceptance criteria**
- [ ] CI fails on a newly introduced `view-as alert-box` in `src/fwebh`.
- [ ] CI fails on a `.cls` missing `block-level on error undo, throw`.

---

## F-30 Dead code: `HttpVerbs` and `@DefaultImplementation`

**Severity:** Minor  **Area:** Cleanup

**Files**
- `src/fwebh/net/HttpVerbs.cls`
- `src/fwebh/pas/data/IRequestData.cls`

**Problem**

- `HttpVerbs` is a `flags` enum covering GET/POST/PUT/DELETE/PATCH, referenced nowhere. Verbs are handled as raw strings (`RequestDataProcessor.cls:38`).
- `@DefaultImplementation(class="fwebh.pas.data.RequestData")` on `IRequestData` is read by nothing.

**Why it matters**

Both look like supported extension points. `HttpVerbs` is a particularly good fit for the dispatch refactor in **F-23** and the PATCH work in **F-08** — it should either be used there or removed.

**Suggested fix**

Use `HttpVerbs` in the unified dispatch, or delete it. Either implement `@DefaultImplementation` (e.g. so the factory can resolve an interface to its default implementation) or remove the annotation.

**Acceptance criteria**
- [ ] Every type in `src/fwebh` is either referenced or removed.

---

## Withdrawn findings

### W-01 "No security infrastructure" — **withdrawn**

An earlier draft of this review raised the absence of authentication, authorization, CORS and rate limiting in `fwebh` as a critical finding, on the basis that `README.md:6` claims centralised HTTP handling makes security easier.

**This was incorrect and has been withdrawn.** In PAS for OpenEdge these are configured in the Spring security layer (`oeablSecurity.csv` / `appSecurity-*.xml`), which handles both authentication and authorization — including JWT and OERealm — and rejects rogue requests before the ABL session is ever reached. Implementing an auth layer inside a WebHandler library would duplicate that machinery and, worse, encourage security decisions to be made *after* the request has already entered 4GL.

The delegation is a correct design decision. What survives from that finding is narrower and is tracked separately:

- **F-05** — 500 responses leak internals. Spring cannot scrub a body that `fwebh` constructs; this remains the library's responsibility.
- **F-11** — the authenticated identity Spring establishes is never surfaced to the service. An agnosticism gap, not a security gap.
- **F-21** — the README wording should state the delegation explicitly rather than implying `fwebh` provides security.
- **F-09** — shipping `CiTestService` is distribution hygiene, not a security hole; Spring rules covering the API URI space cover those endpoints too.

Recorded here so the reasoning is not rediscovered and re-argued later.

---

## What the project does right

Worth stating explicitly, because several of these are uncommon in this ecosystem:

- **The `IEntityWriter` + `entitywriter.json` design is genuinely extensible.** A consumer can register a CSV or PDF writer without touching the library. This is the strongest part of the codebase and the clearest expression of the stated agnosticism goal.
- **Resource discipline is above average.** `DataHolder`'s destructor releases memptrs with a correct `get-size` guard before `set-size` (`DataHolder.cls:79-84`); `PdfService` cleans up in a `finally`; `SimpleJsonSerializer.cls:296-298` deletes its query handle in a `finally`.
- **Lazy `Data` instantiation** on `RequestData` and `ResponseData` correctly avoids allocating for bodiless GETs and 204 responses.
- **`block-level on error undo, throw`** is applied consistently across every `.cls`, in line with the coding standard.
- **CI security hygiene is good.** Every GitHub Action is pinned to a full commit SHA, licences are fetched from secrets and decoded at run time, and `src` is `chmod`-ed read-only inside the build container.
- **The unit-test gate is correctly constructed.** `haltOnFailure="false"` in `build.xml:75` is deliberate — it lets `results.xml` be produced — and `unittest.yaml` then gates the build with `fail-on-error: true`. This is the right pattern and was initially misread during review.
- **Integration tests exercise a real PAS container** across all eight mapped error codes and JSON / XML / plain-text over four verbs.
- **Build artefacts are correctly excluded from git.** `.builder/` and `workspace/` exist locally but are untracked; only 145 files are tracked. `.gitignore` is doing its job.
- **The documentation that exists is unusually good.** The PlantUML diagrams under `doc/uml/` and the full PAS context dump in `context-examples.md` are genuinely useful artefacts. The gap is coverage (**F-20**), not quality.
- **Delegating security to PAS Spring** is the correct architectural decision (see **W-01**); it only needs to be stated.

---

## Suggested sequencing

Ordered by impact per unit of effort, not strictly by severity.

**1 — Unblock adoption**
1. **F-01** — content negotiation. The one defect that makes the library unusable from a browser. Extract the parser so it is testable, which also opens up **F-12**.
2. **F-02** — factory state leakage. Small, contained, silent when wrong.
3. **F-04** — one-line fix restoring lost diagnostics.

**2 — Make failures diagnosable**
4. **F-14** — introduce the logger, then **F-03** — remove alert-boxes and decide propagate-vs-log per site.
5. **F-05** — stop leaking internals in 500s; add correlation ids.
6. **F-24** — fix error-code mapping for subclasses and unmapped types.

**3 — Settle the contracts** *(needs maintainer input first)*
7. **F-07** — decide singleton scope, then **F-06** — move definition loading to session-static state. These must be done together; caching without settling scope changes behaviour silently.
8. **F-11** — surface the authenticated identity on `IRequestData`.
9. **F-08** + **F-23** — unify verb dispatch and add PATCH in one change.

**4 — Fix the distribution**
10. **F-09** — stop shipping test and example code; **F-10** — remove or fix `config/services.json`.
11. **F-20** — write the installation guide; **F-21** — fix the README security wording and add non-goals.

**5 — Reduce future risk**
12. **F-12** and **F-19** — test the HTTP boundary and the serializer error paths.
13. **F-13**, **F-15** — serializer correctness.
14. **F-29** — add lint checks so the standards stop drifting.
15. Remaining minor items: **F-16**, **F-17**, **F-18**, **F-22**, **F-25**, **F-26**, **F-27**, **F-28**, **F-30**.

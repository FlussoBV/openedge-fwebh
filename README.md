# `fwebh` - Flusso WebHandler library for OpenEdge

[![CI](https://github.com/FlussoBV/openedge-fwebh/actions/workflows/ci.yaml/badge.svg)](https://github.com/FlussoBV/openedge-fwebh/actions/workflows/ci.yaml) 
[![Release](https://github.com/FlussoBV/openedge-fwebh/actions/workflows/release.yaml/badge.svg)](https://github.com/FlussoBV/openedge-fwebh/actions/workflows/release.yaml)

A databaseless project primarily aimed at providing a standard implementation for webhandlers and all it intricacies. The idea is to create a library which enables a developer to focus on creating business logic and not have to worry about the WebHandlers, which tend to be rather technical. Another pro is that since the HTTP stuff is handled by `fwebh` it is easier to implement security measures, because the logic for that is centralized.

One of the goals was to be as agnostic as possible when it comes to the requirements to the `consumer` (i.e. the application). For now it's just the service you need to implement.

## documentation
[Coding Standards](coding-standards.md)<br/>
[Services configuration](doc/services-config.md)<br/>
[Services development](doc/services-development.md)<br/>

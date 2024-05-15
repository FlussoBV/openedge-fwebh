# Configuring services
[< back to README.md](../README.md)

There's a strong correlation between what REST calls resources and what services are in `fwebh`. A resource is handled by a service.

Services configuration in done in `services.json`. `fwebh` does a simple `search("service.json")` so the first instance in your `propath` is used. As a suggestion, make a separate directory called `config` and put that first in your propath.

[< back to README.md](../README.md)

# Configuring Services
[< back to README.md](../README.md)<br/>
[> developing services](services-development.md)

There's a strong correlation between what REST calls resources and what services are in `fwebh`. A resource is handled by a service.

## location
Services configuration in done in `services.json`. `fwebh` does a simple `search("service.json")` so the first instance in your `propath` is used. As a suggestion, make a separate directory called `config` and put that first in your propath.

## content
`services.json` contains an object of key/object service definitions. One service defintion looks like:
```
{
  "<resource>": { "classname": "<fully qualified class name>", "singleton": false },
  ...
}
```
Although singletons are possible, it is not recommended since this may leave state.

## example
The standard `services.json` used for testing:
```
{
  "echo": {"classname": "fwebh.pas.service.system.EchoService"},
  "pdf": { "classname": "fwebh.pas.service.example.PdfService"},
  "sysinfo": {"classname": "fwebh.pas.service.system.SystemInfoService"},
  "temptable": {"classname": "fwebh.pas.service.example.TempTableService"},
  "test": {"classname": "fwebh.pas.service.system.CiTestService"}
}
```

## implementation
When the `service.json` file is read, for every service description the `SimpleJsonDeserializer` is used to turn the JSON into an `fwebh.pas.service.ServiceDescription`. Whenever a new property is needed for configuration, simply adding this property to the `ServiceDescription` class will suffice. Do this with caution. 

[< back to README.md](../README.md)

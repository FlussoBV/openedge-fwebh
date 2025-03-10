# Factory

A Factory makes it possible to instantiate an object based on a name, rather than the actual FQCN.

## usage

```
factory.json
{
  "httpclient": "OpenEdge.Net.HttpClient"
}
```

```
var Factory factory.
var IHttpClient http.


factory = new Factory().
factory:LoadDefinition("factory.json").

http = cast(factory:GetInstance("httpclient"), IHttpClient).

// OR
http = {getinstance.i httpclient as IHttpClient from factory}.  // avoids the cast
```

## configurability
In its simplest form an entry looks like:
```
"httpclient": "OpenEdge.Net.HttpClient"
```

One aspect of the factory is that can manage lifetime as well, so that an object is instantiated only once for example.
Configuration looks like
```
"single": { "class": "fwebh.core.Factory", "singleton": true }
```
Let's cal this the extended config. In the extended there one more thing, configuration.

Assume there's a Poller class in the factory and the interval can be configured. The `factory.json` extended can contain a `config` element:
```
{
  "core.IPoller": { "class": "core.Poller", "config": { "interval": 60 }}
}
```
Here we define a config object with one `interval` property, set to 60 (whatever the unit).
The config can be injected into the class whenever this class implements the `fwebh.core.IConfigurable` interface: 
```
interface fwebh.core.IConfigurable:
  method public void Configure(config as JsonObject).
end interface.  // IConfigurable
```

Upon instantiation of the `core.IPoller` entry, the entire `config` object is passed to the `Configure` method. It is upto the implementation how this JSON is processed.

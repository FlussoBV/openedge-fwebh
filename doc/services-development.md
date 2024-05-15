# Developing Services
[< back to README.md](../README.md)<br/>
[> configure services](services-config.md)

Services are the glue between WebHandlers and your application. `fwebh` makes it possible to do HTTP CRUD via the `POST`, `GET`, `PUT` and `DELETE` methods.
In order to be able to do so, the service needs to implement one or more interfaces:
```
fwebh.pas.service.IGetDataService
fwebh.pas.service.IPostDataService
fwebh.pas.service.IPutDataService
fwebh.pas.service.IDeleteDataService
```
All above interfaces have one method, with the same parameter and return type, so `IGetDataService` is used as an example:

```
using fwebh.pas.data.IResponseData.
using fwebh.pas.data.IRequestData.

interface fwebh.pas.service.IGetDataService:  
  
  method public IResponseData GetData(request as IRequestData).
  
end interface.
```
So, for a service to be able to handle `GET`'s, it needs to implement `IGetDataService`.

The sequence diagram involved looks pretty overseeable:

![GET sequence](/doc/images/service-get-sequence.png)

[< back to README.md](../README.md)

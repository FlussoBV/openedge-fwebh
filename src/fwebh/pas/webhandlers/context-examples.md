

example output from WebHandlerExt":

```
{
  "args": {
    "openedge": "true"
  },
  "instance": {
    "environment": "<unknown>",
    "id": "default",
    "calls": 4
  },
  "origin": "172.18.0.1",
  "url": "http://localhost:8810/web/api/get",
  "local": {
    "ip": "172.18.0.4"
  },
  "headers": {
    "Port": "8810",
    "Referer": "",
    "Host": "localhost:8810",
    "Accept": "*/*",
    "User-Agent": "curl/8.4.0",
    "Cookie": ""
  },
  "openedge": {
    "context": {
      "SERVLET_DEFAULT_COOKIE_PATH": "",
      "SERVER_PROTOCOL": "HTTP/1.1",
      "REMOTE_HOST": "172.18.0.1",
      "SERVLET_SRVR_DEBUG": "Enabled",
      "BASE_PATH": "/app/pas/as/webapps/ROOT/",
      "REMOTE_ADDR": "172.18.0.1",
      "REQUEST_URI": "/web/api/get",
      "HTTP_PORT": "8810",
      "SERVER_SOFTWARE": "Apache Tomcat/10.1.15",
      "PATH_TRANSLATED": "/app/pas/as/webapps/ROOT/api/get",
      "REMOTE_PORT": "43930",
      "HTTP_REFERER": "",
      "LOCAL_PORT": "8810",
      "HTTPS": "OFF",
      "CONTENT_TYPE": "",
      "CHARACTER_ENCODING": "UTF-8",
      "REQUEST_METHOD": "GET",
      "SCRIPT_NAME": "/web",
      "SERVER_NAME": "localhost",
      "PATH_INFO": "/api/get",
      "AUTH_TYPE": "",
      "LOCAL_NAME": "22dc18c327d2",
      "SERVER_PORT": "8810",
      "GATEWAY_INTERFACE": "CGI/1.1",
      "SERVLET_SERVER_APP_MODE": "development",
      "SERVLET_PATH": "/web",
      "REMOTE_IDENT": "",
      "SERVLET_DEFAULT_COOKIE_DOMAIN": "",
      "CONTEXT_PATH": "",
      "SERVLET_WSROOT": "/static/webspeed",
      "REMOTE_USER": "",
      "HTTP_HOST": "localhost:8810",
      "CONTENT_LENGTH": "-1",
      "SERVLET_APPLICATION_URL": "/web",
      "QUERY_STRING": "openedge=true",
      "HTTP_ACCEPT": "*/*",
      "REQUEST_SCHEME": "http",
      "HTTP_USER_AGENT": "curl/8.4.0",
      "HTTP_COOKIE": "",
      "LOCAL_ADDR": "172.18.0.4",
      "URI_FINAL_MATCH_GROUP": "/get",
      "URI_TEMPLATE": "/api"
    },
    "pathparameters": {
      "FINAL_MATCH_GROUP": "/get",
      "TEMPLATE": "/api"
    },
    "propath": [
      ".",
      "/app/src",
      "/app/lib/logic.pl",
      "/usr/dlc/tty",
      "/usr/dlc/tty/adecomm.apl",
      "/usr/dlc/tty/OpenEdge.ServerAdmin.apl",
      "/usr/dlc/tty/OpenEdge.BusinessLogic.apl",
      "/usr/dlc/tty/dataadmin.apl",
      "/usr/dlc/tty/adeshar.pl",
      "/usr/dlc/tty/adecomp.pl",
      "/usr/dlc/tty/adeedit.pl",
      "/usr/dlc/tty/OpenEdge.Core.pl",
      "/usr/dlc/tty/netlib/OpenEdge.Net.pl",
      "/usr/dlc",
      "/usr/dlc/bin"
    ],
    "version": "12.8 (WebSpeed)",
    "currentRequestInfo": {
      "agentId": 595,
      "clientContextId": "",
      "procedureName": "Progress.Web.InternalWebHandler&HandleRequest",
      "requestId": "ROOT:w:00000004",
      "sessionId": 4,
      "threadId": 7,
      "clientPrincipal": {}
    }
  }
}
```

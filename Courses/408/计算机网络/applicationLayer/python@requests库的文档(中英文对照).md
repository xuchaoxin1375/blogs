[toc]



 [python@response文档@本地离线中英文对照.mhtml](python@response文档@本地离线中英文对照.mhtml) 

## 常用类

### Request Sessions

class requests.Session

### Lower-Level Classes

1. class requests.Request(method=None, url=None, headers=None, files=None, data=None, params=None, auth=None, cookies=None, hooks=None, json=None)
2. class requests.Response

### Lower-Lower-Level Classes

1. class requests.PreparedRequest
2. class requests.adapters.BaseAdapter
3. class requests.adapters.HTTPAdapter(pool_connections=10, pool_maxsize=10, max_retries=0, pool_block=False)



[ Table of Contents 目录](https://requests.readthedocs.io/en/latest/)

Developer Interface 开发者接口

### Main Interface 主接口

- [`request`](https://requests.readthedocs.io/en/latest/api/#requests.request)
- [`head`](https://requests.readthedocs.io/en/latest/api/#requests.head)
- [`get`](https://requests.readthedocs.io/en/latest/api/#requests.get)
- [`post`](https://requests.readthedocs.io/en/latest/api/#requests.post)
- [`put`](https://requests.readthedocs.io/en/latest/api/#requests.put)
- [`patch`](https://requests.readthedocs.io/en/latest/api/#requests.patch)
- [`delete`](https://requests.readthedocs.io/en/latest/api/#requests.delete)

### Exceptions 异常

- [`RequestException`](https://requests.readthedocs.io/en/latest/api/#requests.RequestException)
- [`ConnectionError`](https://requests.readthedocs.io/en/latest/api/#requests.ConnectionError)
- [`HTTPError`](https://requests.readthedocs.io/en/latest/api/#requests.HTTPError)
- [`TooManyRedirects`](https://requests.readthedocs.io/en/latest/api/#requests.TooManyRedirects)
- [`ConnectTimeout`](https://requests.readthedocs.io/en/latest/api/#requests.ConnectTimeout)
- [`ReadTimeout`](https://requests.readthedocs.io/en/latest/api/#requests.ReadTimeout)
- [`Timeout`](https://requests.readthedocs.io/en/latest/api/#requests.Timeout)
- [`JSONDecodeError`](https://requests.readthedocs.io/en/latest/api/#requests.JSONDecodeError)

### Request Sessions 请求会话

- `Session`
  - [`Session.auth`](https://requests.readthedocs.io/en/latest/api/#requests.Session.auth)
  - [`Session.cert`](https://requests.readthedocs.io/en/latest/api/#requests.Session.cert)
  - [`Session.close`](https://requests.readthedocs.io/en/latest/api/#requests.Session.close)
  - [`Session.cookies`](https://requests.readthedocs.io/en/latest/api/#requests.Session.cookies)
  - [`Session.delete`](https://requests.readthedocs.io/en/latest/api/#requests.Session.delete)
  - [`Session.get`](https://requests.readthedocs.io/en/latest/api/#requests.Session.get)
  - [`Session.get_adapter`](https://requests.readthedocs.io/en/latest/api/#requests.Session.get_adapter)
  - [`Session.get_redirect_target`](https://requests.readthedocs.io/en/latest/api/#requests.Session.get_redirect_target)
  - [`Session.head`](https://requests.readthedocs.io/en/latest/api/#requests.Session.head)
  - [`Session.headers`](https://requests.readthedocs.io/en/latest/api/#requests.Session.headers)
  - [`Session.hooks`](https://requests.readthedocs.io/en/latest/api/#requests.Session.hooks)
  - [`Session.max_redirects`](https://requests.readthedocs.io/en/latest/api/#requests.Session.max_redirects)
  - [`Session.merge_environment_settings`](https://requests.readthedocs.io/en/latest/api/#requests.Session.merge_environment_settings)
  - [`Session.mount`](https://requests.readthedocs.io/en/latest/api/#requests.Session.mount)
  - [`Session.options`](https://requests.readthedocs.io/en/latest/api/#requests.Session.options)
  - [`Session.params`](https://requests.readthedocs.io/en/latest/api/#requests.Session.params)
  - [`Session.patch`](https://requests.readthedocs.io/en/latest/api/#requests.Session.patch)
  - [`Session.post`](https://requests.readthedocs.io/en/latest/api/#requests.Session.post)
  - [`Session.prepare_request`](https://requests.readthedocs.io/en/latest/api/#requests.Session.prepare_request)
  - [`Session.proxies`](https://requests.readthedocs.io/en/latest/api/#requests.Session.proxies)
  - [`Session.put`](https://requests.readthedocs.io/en/latest/api/#requests.Session.put)
  - [`Session.rebuild_auth`](https://requests.readthedocs.io/en/latest/api/#requests.Session.rebuild_auth)
  - [`Session.rebuild_method`](https://requests.readthedocs.io/en/latest/api/#requests.Session.rebuild_method)
  - [`Session.rebuild_proxies`](https://requests.readthedocs.io/en/latest/api/#requests.Session.rebuild_proxies)
  - [`Session.request`](https://requests.readthedocs.io/en/latest/api/#requests.Session.request)
  - [`Session.resolve_redirects`](https://requests.readthedocs.io/en/latest/api/#requests.Session.resolve_redirects)
  - [`Session.send`](https://requests.readthedocs.io/en/latest/api/#requests.Session.send)
  - [`Session.should_strip_auth`](https://requests.readthedocs.io/en/latest/api/#requests.Session.should_strip_auth)
  - [`Session.stream`](https://requests.readthedocs.io/en/latest/api/#requests.Session.stream)
  - [`Session.trust_env`](https://requests.readthedocs.io/en/latest/api/#requests.Session.trust_env)
  - [`Session.verify`](https://requests.readthedocs.io/en/latest/api/#requests.Session.verify)

### Lower-Level Classes 低级类

- `Request`
  - [`Request.deregister_hook`](https://requests.readthedocs.io/en/latest/api/#requests.Request.deregister_hook)
  - [`Request.prepare`](https://requests.readthedocs.io/en/latest/api/#requests.Request.prepare)
  - [`Request.register_hook`](https://requests.readthedocs.io/en/latest/api/#requests.Request.register_hook)
- `Response`
  - [`Response.apparent_encoding`](https://requests.readthedocs.io/en/latest/api/#requests.Response.apparent_encoding)
  - [`Response.close`](https://requests.readthedocs.io/en/latest/api/#requests.Response.close)
  - [`Response.content`](https://requests.readthedocs.io/en/latest/api/#requests.Response.content)
  - [`Response.cookies`](https://requests.readthedocs.io/en/latest/api/#requests.Response.cookies)
  - [`Response.elapsed`](https://requests.readthedocs.io/en/latest/api/#requests.Response.elapsed)
  - [`Response.encoding`](https://requests.readthedocs.io/en/latest/api/#requests.Response.encoding)
  - [`Response.headers`](https://requests.readthedocs.io/en/latest/api/#requests.Response.headers)
  - [`Response.history`](https://requests.readthedocs.io/en/latest/api/#requests.Response.history)
  - [`Response.is_permanent_redirect`](https://requests.readthedocs.io/en/latest/api/#requests.Response.is_permanent_redirect)
  - [`Response.is_redirect`](https://requests.readthedocs.io/en/latest/api/#requests.Response.is_redirect)
  - [`Response.iter_content`](https://requests.readthedocs.io/en/latest/api/#requests.Response.iter_content)
  - [`Response.iter_lines`](https://requests.readthedocs.io/en/latest/api/#requests.Response.iter_lines)
  - [`Response.json`](https://requests.readthedocs.io/en/latest/api/#requests.Response.json)
  - [`Response.links`](https://requests.readthedocs.io/en/latest/api/#requests.Response.links)
  - [`Response.next`](https://requests.readthedocs.io/en/latest/api/#requests.Response.next)
  - [`Response.ok`](https://requests.readthedocs.io/en/latest/api/#requests.Response.ok)
  - [`Response.raise_for_status`](https://requests.readthedocs.io/en/latest/api/#requests.Response.raise_for_status)
  - [`Response.raw`](https://requests.readthedocs.io/en/latest/api/#requests.Response.raw)
  - [`Response.reason`](https://requests.readthedocs.io/en/latest/api/#requests.Response.reason)
  - [`Response.request`](https://requests.readthedocs.io/en/latest/api/#requests.Response.request)
  - [`Response.status_code`](https://requests.readthedocs.io/en/latest/api/#requests.Response.status_code)
  - [`Response.text`](https://requests.readthedocs.io/en/latest/api/#requests.Response.text)
  - [`Response.url`](https://requests.readthedocs.io/en/latest/api/#requests.Response.url)

### Lower-Lower-Level Classes低低层类

- `PreparedRequest`
  - [`PreparedRequest.body`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.body)
  - [`PreparedRequest.deregister_hook`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.deregister_hook)
  - [`PreparedRequest.headers`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.headers)
  - [`PreparedRequest.hooks`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.hooks)
  - [`PreparedRequest.method`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.method)
  - [`PreparedRequest.path_url`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.path_url)
  - [`PreparedRequest.prepare`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare)
  - [`PreparedRequest.prepare_auth`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_auth)
  - [`PreparedRequest.prepare_body`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_body)
  - [`PreparedRequest.prepare_content_length`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_content_length)
  - [`PreparedRequest.prepare_cookies`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_cookies)
  - [`PreparedRequest.prepare_headers`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_headers)
  - [`PreparedRequest.prepare_hooks`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_hooks)
  - [`PreparedRequest.prepare_method`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_method)
  - [`PreparedRequest.prepare_url`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.prepare_url)
  - [`PreparedRequest.register_hook`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.register_hook)
  - [`PreparedRequest.url`](https://requests.readthedocs.io/en/latest/api/#requests.PreparedRequest.url)
- `BaseAdapter`
  - [`BaseAdapter.close`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.BaseAdapter.close)
  - [`BaseAdapter.send`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.BaseAdapter.send)
- `HTTPAdapter`
  - [`HTTPAdapter.add_headers`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.add_headers)
  - [`HTTPAdapter.build_connection_pool_key_attributes`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.build_connection_pool_key_attributes)
  - [`HTTPAdapter.build_response`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.build_response)
  - [`HTTPAdapter.cert_verify`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.cert_verify)
  - [`HTTPAdapter.close`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.close)
  - [`HTTPAdapter.get_connection`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.get_connection)
  - [`HTTPAdapter.get_connection_with_tls_context`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.get_connection_with_tls_context)
  - [`HTTPAdapter.init_poolmanager`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.init_poolmanager)
  - [`HTTPAdapter.proxy_headers`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.proxy_headers)
  - [`HTTPAdapter.proxy_manager_for`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.proxy_manager_for)
  - [`HTTPAdapter.request_url`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.request_url)
  - [`HTTPAdapter.send`](https://requests.readthedocs.io/en/latest/api/#requests.adapters.HTTPAdapter.send)

### Authentication 认证

- [`AuthBase`](https://requests.readthedocs.io/en/latest/api/#requests.auth.AuthBase)
- [`HTTPBasicAuth`](https://requests.readthedocs.io/en/latest/api/#requests.auth.HTTPBasicAuth)
- [`HTTPProxyAuth`](https://requests.readthedocs.io/en/latest/api/#requests.auth.HTTPProxyAuth)
- [`HTTPDigestAuth`](https://requests.readthedocs.io/en/latest/api/#requests.auth.HTTPDigestAuth)

### Encodings 编码

- [`get_encodings_from_content`](https://requests.readthedocs.io/en/latest/api/#requests.utils.get_encodings_from_content)
- [`get_encoding_from_headers`](https://requests.readthedocs.io/en/latest/api/#requests.utils.get_encoding_from_headers)
- [`get_unicode_from_response`](https://requests.readthedocs.io/en/latest/api/#requests.utils.get_unicode_from_response)

### Cookies 饼干

- [`dict_from_cookiejar`](https://requests.readthedocs.io/en/latest/api/#requests.utils.dict_from_cookiejar)
- [`add_dict_to_cookiejar`](https://requests.readthedocs.io/en/latest/api/#requests.utils.add_dict_to_cookiejar)
- [`cookiejar_from_dict`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.cookiejar_from_dict)
- `RequestsCookieJar`
  - [`RequestsCookieJar.add_cookie_header`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.add_cookie_header)
  - [`RequestsCookieJar.clear`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.clear)
  - [`RequestsCookieJar.clear_expired_cookies`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.clear_expired_cookies)
  - [`RequestsCookieJar.clear_session_cookies`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.clear_session_cookies)
  - [`RequestsCookieJar.copy`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.copy)
  - [`RequestsCookieJar.extract_cookies`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.extract_cookies)
  - [`RequestsCookieJar.get`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.get)
  - [`RequestsCookieJar.get_dict`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.get_dict)
  - [`RequestsCookieJar.get_policy`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.get_policy)
  - [`RequestsCookieJar.items`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.items)
  - [`RequestsCookieJar.iteritems`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.iteritems)
  - [`RequestsCookieJar.iterkeys`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.iterkeys)
  - [`RequestsCookieJar.itervalues`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.itervalues)
  - [`RequestsCookieJar.keys`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.keys)
  - [`RequestsCookieJar.list_domains`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.list_domains)
  - [`RequestsCookieJar.list_paths`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.list_paths)
  - [`RequestsCookieJar.make_cookies`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.make_cookies)
  - [`RequestsCookieJar.multiple_domains`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.multiple_domains)
  - [`RequestsCookieJar.pop`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.pop)
  - [`RequestsCookieJar.popitem`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.popitem)
  - [`RequestsCookieJar.set`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.set)
  - [`RequestsCookieJar.set_cookie`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.set_cookie)
  - [`RequestsCookieJar.set_cookie_if_ok`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.set_cookie_if_ok)
  - [`RequestsCookieJar.setdefault`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.setdefault)
  - [`RequestsCookieJar.update`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.update)
  - [`RequestsCookieJar.values`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.RequestsCookieJar.values)
- `CookieConflictError`
  - [`CookieConflictError.add_note`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.CookieConflictError.add_note)
  - [`CookieConflictError.with_traceback`](https://requests.readthedocs.io/en/latest/api/#requests.cookies.CookieConflictError.with_traceback)

### 其他

- Status Code Lookup
  状态码查找
  - [`codes`](https://requests.readthedocs.io/en/latest/api/#requests.codes)
- Migrating to 1.x
  迁移到 1.x
  - [API Changes API 更改](https://requests.readthedocs.io/en/latest/api/#api-changes)
  - [Licensing 许可](https://requests.readthedocs.io/en/latest/api/#licensing)
- Migrating to 2.x
  迁移到 2.x
  - [API Changes API 变更](https://requests.readthedocs.io/en/latest/api/#id1)
  - [Behavioural Changes 行为变更](https://requests.readthedocs.io/en/latest/api/#behavioural-changes)
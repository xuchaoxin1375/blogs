[toc]



| 情况                            | 默认连接协议                                    | 说明                                 |
| ------------------------------- | ----------------------------------------------- | ------------------------------------ |
| `mysql -u root -p`（未加 `-h`） | `UNIX socket`（Linux）/ `named pipe`（Windows） | 默认连接 `localhost`，走本地方式     |
| `mysql -h 127.0.0.1`            | `TCP`                                           | 明确指定 IP，强制走网络连接          |
| `mysql -h localhost`            | `UNIX socket`（或 named pipe）                  | 即使看起来是网络，其实还是走本地方式 |
| `mysql -h <远程IP>`             | `TCP`                                           | 这是远程连接的标准方式               |
| `mysql ... --protocol=tcp`      | 强制 `TCP`                                      | 可绕过所有默认行为歧义，确保使用 TCP |
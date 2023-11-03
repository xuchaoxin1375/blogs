[toc]

# token&session

## references

### wikipedia:计算机中的token

- Token, an object (in software or in hardware) which represents the right to perform some operation:
  - [Session token](https://en.wikipedia.org/wiki/Session_token), a unique identifier of an interaction session
  - [Security token](https://en.wikipedia.org/wiki/Security_token) or **hardware token**, authentication token or cryptographic token, a physical device for computer authentication
  - [Access token](https://en.wikipedia.org/wiki/Access_token), a system object (representing (the **subject** (of access control operations)))
  - [Tokenization (data security)](https://en.wikipedia.org/wiki/Tokenization_(data_security)), the process of substituting a sensitive data element
  - Invitation token, in an [invitation system](https://en.wikipedia.org/wiki/Invitation_system)
  - [Token Ring](https://en.wikipedia.org/wiki/Token_Ring), a network technology in which a token circles in a logical ring
  - Token, an object used in [Petri net](https://en.wikipedia.org/wiki/Petri_net) theory
- [Lexical token](https://en.wikipedia.org/wiki/Lexical_token), a word or other atomic parse element

### geeksforgeeks

- [Session vs Token Based Authentication - GeeksforGeeks](https://www.geeksforgeeks.org/session-vs-token-based-authentication/)



- [Session vs Token Based Authentication | by Sherry Hsu | Medium](https://sherryhsu.medium.com/session-vs-token-based-authentication-11a6c5ac45e4)

## 无状态的Http协议

- HTTP is stateless. All the requests are stateless. 
- However, there are situations where we would like our states to be remembered. 
- For example, in a on-line shop, after we put bananas in a shopping cart, we don’t want our bananas to disappear when we go to another page to buy apples. ie. we want our purchase state to be remembered while we navigate through the on-line shop!
- To overcome the stateless nature of HTTP requests, we could use either a session or a token.



## session&token 应用场景

- The Session and Token-based Authentication methods are used to make a server trust any request sent by an authenticated user over the internet.
- In this way, a user can interact with their account **without continually specifying their credentials**. 
- These methods are usually used for different purposes. 

> - *For example*, sessions are commonly used in **websites applications** while
> -  tokens are preferred in **server-to-server** connections. 



### Session Authentication

#### session file

- A [session](https://www.geeksforgeeks.org/session-cookies-in-node-js/) is a small file, most likely in JSON format, that stores information about the user, such as a unique ID, time of login and expirations, and so on. 
- It is generated and stored on the server so that the server can keep track of the user requests. 
- **The user receives some of these details, especially the ID, as cookies that will be sent with every new request,** so that the server can recognize the ID and authorize the user’s requests.



### Working

1. The user sends a login request to the server.
2. The server **authenticates** the login **request**, 
   1. **<u>sends a session to the database</u>**, and 
   2. **returns a cookie containing the session ID to the user.**

3. The server checks in the database for **the ID found in the cookie**, if the ID is found it **sends the requested pages to the user.**
4. Now, the user sends new requests (with a cookie).

![Session Authentication](https://media.geeksforgeeks.org/wp-content/uploads/20211206163821/Group2copy-660x330.jpg)

Session Authentication

- In the session based authentication, the **server** will **create a session** for the user **after the user logs in**. 
- The **session id** is then **stored on a cookie** on the **user’s browser**. 
- While the user stays logged in, the cookie would be **sent along with every subsequent request.** 
- The **server** can then **compare the session id stored on the cookie** against **the session information stored in the memory** to **verify user’s identity** and **sends response with the corresponding state**!

![img](https://miro.medium.com/max/1400/1*Hg1gUTXN5E3Nrku0jWCRow.png)



### Pros/Cons: 优缺点

> good points and bad points

#### good

- Since sessions are stored on the server, its administrators are in power over them. 
- *For example*,  if a security team suspects an account is **compromised**(bring into disrepute or danger by indiscreet, foolish, or reckless behaviour.), **they can immediately invalidate the session ID,**
-  so that the user is immediately logged out. 

> 简而言之,可以强迫下线可能处于被盗号的账号!

#### bad

-  On the other hand, since a session is stored on the server, the server is **in charge of** looking up the session ID that the user sends. 
  - This can **cause scalability problems([skeɪlə'bɪlɪtɪ]扩展性问题)**.


- Cookies may be exposed to **cross-site request forgery attacks(csrf)**
  - (forgery:the action of forging a copy or imitation of a document, signature, banknote, or work of art). 
- The attacker may **mislead** the user to **a hostile website**, where some **JS scripts may exploit cookies to send malicious requests to the server**. 
- Another vulnerability regards the chances of **a man-in-the-middle attack**, where an attacker can **intercept** the session ID and **perform harmful requests to the server**.
  - intercept: obstruct /stop (someone or something) so as to prevent them from continuing to a destination.

## Token-Based Authentication

> 关键词
>
> - 密钥
> - 签名

- Many web applications use **JSON Web Token (JWT)** instead of sessions for authentication. 
- In the token based application, **the server creates JWT** with a secret and **sends the JWT to the client**. 
- The **client** stores the JWT (usually in local storage) and <u>includes JWT in the **header** with every **request**</u>(send to the server). 
- The server would then **validate the JWT** with every request from the client and sends response.

![img](https://miro.medium.com/max/1400/1*PDry-Wb8JRquwnikIbJOJQ.png)

Token Based Authentication flow

- The biggest difference here is that the user’s state is not stored on the server, as **the state is stored inside the token on the client side instead.** 
- **Most of the modern web applications** use JWT for authentication for reasons including **scalability and mobile device authentication.**

### Node Modules for JWT

- `jsonwebtoken` library can be used to created the JWT token on the server. 
- Once the user is logged in, the client passes the JWT token back on the header.authorization.bearer attribute.

```
{
  method: "GET",
  headers:{
    "Authorization": "Bearer ${JWT_TOKEN}"
  }
}
```

- Middleware, `express-jwt,` can be used to validate the JWT token by comparing the secret.

### Scalability

- **Session based authentication:** Because the sessions are stored in the server’s memory, scaling becomes an issue when there is a huge number of users using the system at once.

- **Token based authentication:** There is no issue with scaling because token is stored on the client side.

### Multiple Device

- **Session based authentication:** Cookies normally work on a single domain or subdomains and they are [normally disabled by browser](https://medium.com/building-contently/tracking-people-across-multiple-domains-when-cookies-just-arent-enough-b270cc95beb1) if they work cross-domain (3rd party cookies). 
  - It poses issues when APIs are served from a different domain to mobile and web devices.

- **Token based authentication:** There is no issue with cookies as the JWT is included in the request header.
  - Token Based Authentication using JWT is the **more recommended method in modern web apps.**
  -  One drawback with JWT is that **the size of JWT is much bigger** comparing with the session id stored in cookie because JWT contains **more user information**.
  -  Care must be taken to ensure only the necessary information is included in JWT and **sensitive information should be omitted to prevent XSS security attacks.**

### 比较session & token

-  token 和 session 的验证机制最大的区别是用“签名验证机制”代替了“白名单验证机制”

> - session 必须在服务器维护一个 session_id 的白名单来验证 session_id 的合法性。
> - token 的改进之处就在这里，token 通过**签名机制**，只要前端传来的 **token 能通过签名认证就是合法的**，不需要服务器维护任何东西，所有的需要东西都放在在 token 里面。

- A [token](https://www.geeksforgeeks.org/what-is-authentication-tokens-in-network-security/) is **an authorization file** that cannot be **tampered** with. 
  - **tamper** :<u>interfere</u> with (something) in order to cause damage or make unauthorized alterations.
- **It is generated by the server** using **a secret key**, <u>sent to and stored by the user</u> in their local storage. 
- Like in the case of **cookies**, the user sends this token to the server **with every new request**, so that the server can **verify its signature** and **authorize the requests.** 

### Working

1. The user sends a login request to the server.
2. The server authorizes the login and **sends a token to the user**.
3. The server checks the token is valid or not, if the token is valid it sends the requested pages to the user.
4. Now, the user **sends a new request(with a token**).

![ Token Authentication](https://media.geeksforgeeks.org/wp-content/uploads/20211206163844/Group2-660x330.jpg)

 Token Authentication

- Note- Those are **not** **authentication files,** they are **authorization ones**. 
- *While receiving a token, the server does **not** look up who the user is, it simply authorizes the user’s requests <u>relying on the validity of the token.</u>*

### Pros/Cons

#### Pros

- Tokens can be useful when the user wants to **reduce the number of times they must send their credential.**
-  In the case of server-to-server connections, using **credentials** becomes **difficult**, and **tokens overcome this problem**.
-  Moreover, servers that use tokens can **improve their performances,** because they **do not need to continuously look through all the session details** to authorize the user’s requests. 

#### Cons

- However, **the authentication details are stored on the client**, so **the server cannot perform certain security operations as in the session method**.
-  As written above, the server does **not authenticate the user,** so **linking a token to its user can be more difficult.** 
- If a **hypothetical** attacker manages to get **a valid token**, they may have **unlimited access to the server databases**. If the server generates keys using **older algorithms,** these keys can be **breached**(make a gap in and break through).

## 多方面对比session&token

### Differences Between Session and Token-Based Authentication Methods

|      | Criteria                                                     | **Session authentication method**                            | **Token-based authentication method**                       |
| :--- | :----------------------------------------------------------- | :----------------------------------------------------------- | :---------------------------------------------------------- |
| 1    | Which side of the connection stores the authentication details | Server                                                       | User                                                        |
| 2    | What the user sends to the server to have their requests authorized | A cookie                                                     | The token itself                                            |
| 3    | What the server does to authorize users’ requests            | Looking up in its **databases** to f**ind the right session** thanks to(because) the ID the user sends with a cookie | **Decrypting** the user’s token and verifying its signature |
| 4    | Can the server admins perform securities operations like **logging users out**, **changing their details,** etc | Yes, because the session is stored on the server             | **No**, because the token is stored on the user’s machine   |
| 5    | From what kind of attacks the method may suffer              | Man-in-the-middle, Cross-site request forgery                | Man-in-the-middle, Token steal, breaches of the secret key  |
| 6    | Preferred method application                                 | User-to-server connections                                   | Server-to-server connections                                |

### Conclusion

- 两者都有可能受到中间人工攻击



- Session and token-based are two authentication methods that allow a server to trust all the requests it receives from a user. 
  - The main difference is session-based authentication of the connection stores the authentication details. 
  - The session method makes the server store most of the details, while in the case of the token-based one the client stores them.
- The session authentication method is based on the concept of the ID being shared with the **client** through a **cookie** file, while <u>the rest of the details are on the session file, stored on the **server**.</u>
- The token-based authentication method is based on the concept that possessing a token is the only thing that a user needs to have their requests authorized by the server, **which must only verify a signature**. 
  - The token is secure to use because it cannot be tampered with.
- Both methods have **inherent vulnerabilities** that can be most easily resolved with different workarounds.
-  In the end, developers must decide which method suits better to their needs and applications.






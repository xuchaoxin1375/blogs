- @[toc]

# http_认证机制&https加密&TLS&SSL&密钥对(公钥&私钥)

- [HTTP | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTTP)

  

## 何为认证

- 计算机本身无法判断坐在显示器前的使用者的身份。
  - 进一步说，也无法确认网络的那头究竟有谁。
- 可见，为了弄清究竟是谁在访问服务器，就得**让对方的客户端自报家门**。
  - 可是，就算正在访问服务器的对方声称自己是 user1，身份是否属实这点却也无从谈起。
- 为确认 user1本人是否真的具有访问系统的权限，就需要核对“登录者本人**才知道**的信息”、“登录者本人**才会有**的信息”。

核对的**信息**通常是指以下这些。

- 密码：只有本人才会知道的字符串信息。
- 动态令牌：仅限本人持有的设备内显示的一次性密码。
- 数字证书：仅限本人（终端）持有的信息。
- 生物认证：指纹和虹膜等本人的生理信息。
- IC 卡等：仅限本人持有的信息。

## HTTP 使用的认证方式

HTTP/1.1 使用的认证方式:

- BASIC 认证（基本认证）

- DIGEST 认证（摘要认证）
- SSL 客户端认证(证书认证)

- FormBase 认证（基于表单认证）

## BASIC认证(不常用)

- BASIC 认证（基本认证）是从 HTTP/1.0 就定义的认证方式。
- ![image-20220528144808783](https://img-blog.csdnimg.cn/img_convert/a63a07c68c7191bf998c3e3c0849caad.png)
- 即便是现在仍有一部分的网站会使
- 用这种认证方式。是 Web 服务器与通信客户端之间进行的认证方式。

### BASIC认证的问题

- BASIC 认证虽然采用 Base64 编码方式，但这不是加密处理。
- 不需要任何附加信息即可对其解码。
- 换言之，由于明文解码后就是用户 ID和密码，在 HTTP 等非加密通信的线路上进行 BASIC 认证的过程中如果被人窃听，被盗的可能性极高。 
- 另外，除此之外想再进行一次 BASIC 认证时，一般的浏览器却无法实现认证注销操作，这也是问题之一。 
- BASIC 认证使用上不够便捷灵活，且达不到多数 Web 网站期望的安全性等级，因此**它并不常用**。

## DIGEST 认证(不常用)

- 为弥补 BASIC 认证存在的弱点，从 **HTTP/1.1 起就有了 DIGEST 认证**。
- DIGEST 认证**同样**使用**质询 / 响应的方式**（challenge/response），但不会像 BASIC 认证那样直接发送明文密码。 
- 所谓**质询响应方式**是指，一开始一方会先发送认证要求给另一方，接着使用从另一方那接收到的**质询码**计算生成响应码。最后将响应码返回给对方进行认证的方式。
- ![image-20220528145115467](https://img-blog.csdnimg.cn/img_convert/683d9d6025b31870b62625f758f5fc65.png)
- ![image-20220528145129032](https://img-blog.csdnimg.cn/img_convert/e170dd18ae5f3f1d9ec4c4006bc2c452.png)

### DIGEST的问题

- DIGEST 认证提供了高于 BASIC 认证的安全等级，但是和HTTPS 的客户端认证相比**仍旧很弱**。
- DIGEST 认证提供**防止密码被窃听**的保护机制，但并**不存在防止用户伪装**的保护机制。 
- DIGEST 认证和 BASIC 认证一样，**使用上不那么便捷灵活**，且仍达不到多数 Web 网站对高度**安全等级**的追求标准。
- 因此它的适用范围也有所受限。



## HTTP 的缺点

  - 通信使用**明文（不加密），内容可能会被窃听**

  - **不验证通信方的身份**，因此有可能**遭遇伪装**
  - 无法证明报文的**完整性**，所以有**可能已遭篡改**

  

  > 这些问题不仅在 HTTP 上出现，**其他未加密的协议中也会存在这类问题**。 

## http加密

  

### 内容的加密

  - 还有一种将参与通信的**内容本身加密**的方式。
  - 由于 HTTP 协议中没有加密机制，那么**就对 HTTP 协议传输的内容本身加密**。
    - 即把 HTTP 报文里**所含的内容**进行加密处理。
    -  在这种情况下，客户端需要对 HTTP 报文进行**加密处理后再发送请求**。
  - 为了做到有效的内容加密，前提是要求客户端和服务器**同时具备加密和解密机制**。
    - 主要应用在 Web 服务中。
    - 有一点必须引起注意，由于该方式不同于 SSL 或 TLS 将整个通信线路加密处理，所以**内容仍有被篡改的风险**

### 伪装

  - 不验证**通信方的身份**就可能遭遇伪装
    HTTP 协议中的请求和响应不会对通信方进行确认。
  - 也就是说存在“服务器是否就是发送请求中 URI 真正指定的主机，
  - 返回的响应是**否真的返回到实际提出请求的客户端**”等类似问题
  - 无法判定请求是**来自何方、出自谁手**(服务器和客户端都有可能是伪造的)。
    - 即使是无意义的请求也会照单全收。无法阻止海量请求下的 **DoS攻击**（Denial of Service，**拒绝服务攻击**）。
    - 无法确定请求发送至**目标的 Web 服务器**<u>是否是</u>按真实意图返回响应的<u>那台服务器</u>。有可能是**已伪装的 Web 服务器**。
  - 无法确定响应**返回到的客户端**是否是按真实意图接收响应的那个客户端。有可能是**已伪装的客户端**。
  - 无法确定正在通信的对方是否具**备访问权限**。因为某些 Web 服务器上保存着重要的信息，只想发给特定用户通信的权限。

  

## 密钥&公钥&私钥

  - [什么是公钥和私钥？ (aliyun.com)](https://help.aliyun.com/document_detail/42216.html)

  > - 公钥（Public Key）与私钥（Private Key）是通过**加密算法**得到的一个**密钥对**（即<u>一个公钥和一个私钥</u>，也就是非对称加密方式）。
  > - 公钥可**对会话进行加密**、**验证数字签名**，只有<u>使用对应的**私钥**才能**解密会话数据**</u>，从而**保证数据传输的安全性**。

  - **公钥**是***密钥***对外**公开的部分**，

  - **私钥**则是***密钥***的非公开的部分，由**用户自行保管**。

  > - 通过加密算法得到的**密钥对**可以**保证在世界范围内是唯一**的。
  > - 使用**密钥对**的时候，如果用**<u>其中一个密钥(公钥或者私钥)</u>加密一段数据**，只能**使用密钥对中的另一个密钥**才能解密数据。
  >   - 例如：用<u>公钥加密的数据必须用对应的私钥才能解密</u>；
  >   - 如果用私钥进行加密<u>也必须使用对应的公钥</u>才能解密，否则将无法成功解密。

### 共享密钥加密vs 公共密钥加密(对称加密vs非对称加密)

  > 区分共享密钥和公共密钥

  - 加密和解密同用一个密钥的方式称为**共享**密钥加密（Common key crypto system），也被叫做**对称密钥加密**。
  - 对称加密不如公开密钥(非对称加密)安全,但是也不是一无是处,两者组合使用,可以节约开销

#### HTTPS 采用混合加密机制

  > 知道了共享密钥和公共密钥的基本概念,再看它们的组合应用来节约开销

  ![image-20220528175507159](https://img-blog.csdnimg.cn/img_convert/0f805489eb43a972039af2e608947759.png)

  - HTTPS 采用共享密钥加密和公开密钥加密两者并用的**混合加密机制**。
  - 若密钥能够实现安全交换，那么有可能会考虑仅使用公开密钥加密来通信。
    - 但是公开密钥加密与共享密钥加密相比，其处理速度要慢。 
  - 所以应**充分利用两者各自的优势**，将多种方法组合起来用于通信。
    - 在**交换密钥环节使用公开密钥加密方式**，**之后的建立通信交换报文阶段则使用共享密钥加密方式**。

### 公开密钥(public key)本身的真实性问题

  - 遗憾的是，公开密钥加密方式还是存在一些问题的。

  - 那就是无法证明公开密钥**本身就是货真价实的公开密钥**。

    - 比如，正准备和某台服务器建立公开密钥加密方式下的通信时，如何证明收到的公开密钥就是原本预想的那台服务器发行的公开密钥。
    - 或许**在公开密钥传输途**中，真正的公开密钥**已经被攻击者替换掉**了。 

  - 为了解决上述问题，可以**使用**由数字证书认证机构（CA，Certificate Authority）和其相关机关颁发的**公开密钥证书**。

    -  数字证书认证机构**处于客户端与服务器双方都可信赖**的**第三方机构**的立场上。

      

#### 数字证书认证机构的业务流程。

![image-20220528184724114](https://s2.loli.net/2022/05/28/BpKZNj1MqxH8cTu.png)

  > 关键:
  >
  > - 机构对要公开的密钥做数字签名
  > - 客户端要用机构公开的public key(可以是事先植入浏览器的key)验证机构签名

  - 首先，**服务器**的运营人员向**数字证书认证机构提出公开密钥的申请**。
  - 数字证书认证机构(CA)**在判明提出申请者的身份之后，会**
    - **对已申请的公开密钥做数字签名**，然后**分配这个已签名的公开密钥**，
    - 并将**该公开密钥放入公钥证书**后<u>绑定在一起</u>。
  - 服务器会**将这份由数字证书认证机构颁发的*<u>公钥证书</u>*发送给<u>客户端</u>**，以进行**公开密钥加密方式通信**。
    - **公钥证书**也可叫**做数字证书**或直接称为**证书**。 
  - 接到证书的客户端**可使用数字证书认证机构的公开密钥**，**对那张证书上的数字签名进行验证**
    - 一旦验证通过，客户端便可**明确**两件事：
      - 一，(明确认证机构):认证**服务器的公开密钥**的是**真实有效的数字证书<u>认证机构</u>**。(数字证书不是被调包的,否则就不会通过前面的签名验证)
      - 二，服务器的公开密钥是**值得信赖**的。此处认证机关的公开密钥**必须安全地转交给客户端**。
  - 使用通信方式时，**如何安全转交是一件很困难的事**，因此，<u>多数浏览器开发商发布版本时，会事先在内部植入常用认证机关的**公开密钥**。</u>

#### SSL证书的原理

  - SSL证书采用**公钥体制**，即利用**一对互相匹配的密钥对**进行**数据加密和解密**。

  - 每个用户自己设定一把**特定的、仅为本人所知的私有密钥（私钥）**，并用它进行**解密和签名**；
  - 同时**设定一把公共密钥（公钥）并由本人公开**，为**一组用户所共享**，用于**加密和<u>验证签名</u>**。

  由于密钥仅为本人所有，<u>可以产生其他人无法生成的**加密文件**</u>，也就是形成了**数字签名**。

  

#### 使用两把密钥的公开密钥加密

  公开密钥加密方式很好地解决了共享密钥加密的困难。 

  - 公开密钥加密使用**一对非对称的密钥**。
  - 一把叫做私有密钥（private key），另一把叫做公开密钥（public key）。
  - 顾名思义，私有密钥不能让其他任何人知道，而公开密钥则可以随意发布，任何人都可以获得。
  -  使用公开密钥加密方式，发送密文的一方使用对方的公开密钥进行加密处理，对方收到被加密的信息后，再使用自己的私有密钥进行解密。
  - 利用这种方式，不需要发送用来解密的私有密钥，也不必担心密钥被攻击者窃听而盗走。
    -  要想根据密文和公开密钥，恢复到信息原文是异常困难的，因为解密过程就是在对离散对数进行求值，这并非轻而易举就能办到。
    - 退一步讲，如果能对一个非常大的整数做到快速地因式分解，那么密码破解还是存在希望的。但就目前的技术来看是不太现实的。

  ![image-20220528173822610](https://img-blog.csdnimg.cn/img_convert/944dbef4082e1545f1fed34e9895c810.png)

### SSL证书

  > 虽然使用 HTTP 协议无法确定通信方，但如果使用 SSL 则可以。
  >
  > 

  - SSL 不仅提供**加密处理**，而且还使用了一种**被称为证书的手段**，可用于确定对方。

    - 证书由**值得信任的第三方机构颁发**，用以**证明服务器和客户端是实际存在的**。
    - 另外，伪造证书从技术角度来说是异常困难的一件事。

  - 所以只要能够**确认通信方（服务器或客户端）持有的证书**，即可**判断通信方的真实意图**。

  - ![image-20220528152513141](https://img-blog.csdnimg.cn/img_convert/0aee2bb7f417451687a6202b171c1100.png)

    

    > In [cryptography](https://en.wikipedia.org/wiki/Cryptography): [krɪpˈtɑɡrəfi], a **public key certificate**, also known as a **digital certificate** or **identity certificate**, is an [electronic document](https://en.wikipedia.org/wiki/Electronic_document) used to prove the validity of a [public key](https://en.wikipedia.org/wiki/Key_authentication).[[1\]](https://en.wikipedia.org/wiki/Public_key_certificate#cite_note-:0-1) 

    - The **certificate** includes information about the **key**, information about the identity of **its owner** (called the subject身份主体), and the [digital signature](https://en.wikipedia.org/wiki/Digital_signature) of <u>an entity that has verified the certificate's contents</u> (called the issuer发行机构). 

      - If the signature is **valid**, and the **software** examining the certificate **trusts** the **issuer**, then it can use that key to communicate securely with **the certificate's subject**.
      -  In [email encryption](https://en.wikipedia.org/wiki/Email_encryption), [code signing](https://en.wikipedia.org/wiki/Code_signing), and [e-signature](https://en.wikipedia.org/wiki/Electronic_signature) systems, **a certificate's subject is typically a person or organization.** 

      - However, in [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (TLS) a certificate's subject is typically **a computer or other device**, though TLS certificates may identify organizations or individuals in addition to their core role in identifying devices. 
      - TLS, sometimes called by its older name [Secure Sockets Layer](https://en.wikipedia.org/wiki/Secure_Sockets_Layer) (SSL), is notable for being a part of [HTTPS](https://en.wikipedia.org/wiki/HTTPS), a [protocol](https://en.wikipedia.org/wiki/Communications_protocol) for securely browsing the [web](https://en.wikipedia.org/wiki/World_Wide_Web).(TLS有时候仍被称呼为SSL)

    


#### PKI vs Web of trust

  - In a typical [public-key infrastructure](https://en.wikipedia.org/wiki/Public-key_infrastructure) (PKI) scheme, the **certificate issuer** is a [certificate authority](https://en.wikipedia.org/wiki/Certificate_authority) (CA),[[2\]](https://en.wikipedia.org/wiki/Public_key_certificate#cite_note-2) usually a company that charges customers to issue certificates for them. 

  - By contrast, in a [web of trust](https://en.wikipedia.org/wiki/Web_of_trust) scheme, individuals **sign each other's keys directly**, in a format that performs a **similar function to a public key certificate**.

    - In [cryptography](https://en.wikipedia.org/wiki/Cryptography), a **web of trust** is a concept used in [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy), [GnuPG](https://en.wikipedia.org/wiki/GNU_Privacy_Guard), and other [OpenPGP](https://en.wikipedia.org/wiki/OpenPGP)-compatible systems to establish the [authenticity](https://en.wikipedia.org/wiki/Authentication) of the binding between a [public key](https://en.wikipedia.org/wiki/Public_key) and its owner. Its decentralized [trust model](https://en.wikipedia.org/wiki/Trust_metric#Formal_metrics) is an alternative to the centralized trust model of a [public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) (PKI), which relies exclusively on a [certificate authority](https://en.wikipedia.org/wiki/Certificate_authority) (or a hierarchy of such). As with computer networks, there are many independent webs of trust, and any user (through their [public key certificate](https://en.wikipedia.org/wiki/Public_key_certificate)) can be a part of, and a link between, multiple webs.

      The web of trust concept was first put forth by PGP creator [Phil Zimmermann](https://en.wikipedia.org/wiki/Phil_Zimmermann) in 1992 in the manual for PGP version 2.0:

      > As time goes on, you will accumulate keys from other people that you may want to designate as trusted introducers. Everyone else will each choose their own trusted introducers. And everyone will gradually accumulate and distribute with their key a collection of certifying signatures from other people, with the expectation that anyone receiving it will trust at least one or two of the signatures. This will cause the emergence of a decentralized fault-tolerant web of confidence for all public keys.

  - The most common format for public key certificates is defined by [X.509](https://en.wikipedia.org/wiki/X.509).[[3\]](https://en.wikipedia.org/wiki/Public_key_certificate#cite_note-3) 

    - Because X.509 is very general, the format is further constrained by profiles defined for certain use cases, such as [Public Key Infrastructure (X.509)](https://en.wikipedia.org/wiki/PKIX) as defined in [RFC](https://en.wikipedia.org/wiki/RFC_(identifier)) [5280](https://datatracker.ietf.org/doc/html/rfc5280)

  #### SSL证书特点

  - 是一个经**证书授权中心（CA）**<u>数字签名的、包含**公开密钥**以及**公开密钥拥有者信息**的</u>文件。
  - 最简单的证书包含一个**公开密钥、名称以及证书授权中心的数字签名**。
  - 数字证书还有一个重要的特征就是**只在特定的时间段内有效**。

###  其他SSL证书

####  EV SSL 证书

可证明组织真实性的EV SSL证书

- 证书的一个作用是用来证明作为通信一方的服务器是否规范，另外一个作用是可确认对方服务器背后运营的企业是否真实存在。拥有该特性的证书就是 EV SSL 证书（Extended Validation SSL Certificate）。 
- EV SSL 证书是基于国际标准的认证指导方针颁发的证书。
- 其严格规定了对运营组织是否真实的确认方针，因此，通过认证的 Web 网站能够获得更高的认可度。 
- 持有 EV SSL 证书的 Web 网站的浏览器地址栏处的背景色是绿色的，从视觉上就能一眼辨别出。
- 而且在地址栏的左侧显示了 SSL 证书中记录的组织名称以及颁发证书的认证机构的名称。

#### 用以确认客户端的客户端证书

- HTTPS 中还可以使用客户端证书。以客户端证书进行客户端认证，证明服务器正在通信的对方始终是预料之内的客户端，其作用跟服务器证书如出一辙。
- 但客户端证书仍存在几处问题点。
  - 其中的一个问题点是证书的获取及发布。
    - 想获取证书时，用户得自行安装客户端证书。
    - 但由于客户端证书是要付费购买的，且每张证书对应到每位用户也就意味着需支付和用户数对等的费用。
    - 另外，要让知识层次不同的用户们自行安装证书，这件事本身也充满了各种挑战。
- 现状是，安全性极高的认证机构可颁发客户端证书但仅用于特殊用途的业务。比如那些可支撑客户端证书支出费用的业务。
  - 例如，银行的网上银行就采用了客户端证书。在登录网银时不仅要求用户确认输入 ID 和密码，还会要求用户的客户端证书，以确认用户是否从特定的终端访问网银。

#### 自签名证书

- 独立构建的认证机构叫做自认证机构，由自认证机构颁发的“无用”证书也被称为自签名证书。 


### TLS&SSL协议

> SSL协议现已废弃:(SSL->TLS)
>
> - **Transport Layer Security** (**TLS**), the successor of the now-deprecated **Secure Sockets Layer** (**SSL**), is a [cryptographic protocol](https://en.wikipedia.org/wiki/Cryptographic_protocols) designed to provide communications security over a computer network. 
>
> - HTTPS was used with the [SSL](https://en.wikipedia.org/wiki/Secure_Sockets_Layer) protocol. As SSL evolved into [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (TLS),

- **传输层安全性协议**（英语：**T**ransport **L**ayer **S**ecurity，缩写：**TLS**）及其前身**安全套接层**（英语：**S**ecure **S**ockets **L**ayer，缩写：**SSL**）是一种[安全协议](https://zh.wikipedia.org/wiki/安全协议)，目的是为[互联网](https://zh.wikipedia.org/wiki/網際網路)通信提供安全及数据[完整性](https://zh.wikipedia.org/wiki/完整性)保障。

- [网景](https://zh.wikipedia.org/wiki/網景)公司（Netscape）在1994年推出首版[网页浏览器](https://zh.wikipedia.org/wiki/網頁瀏覽器)－[网景导航者](https://zh.wikipedia.org/wiki/網景領航員)时，推出[HTTPS](https://zh.wikipedia.org/wiki/HTTPS)协议，以SSL进行加密，这是SSL的起源。
  - [IETF](https://zh.wikipedia.org/wiki/IETF)将SSL进行标准化，1999年公布TLS 1.0标准文件（[RFC 2246](https://tools.ietf.org/html/rfc2246)）。
  - 随后又公布TLS 1.1（[RFC 4346](https://tools.ietf.org/html/rfc4346)，2006年）、TLS 1.2（[RFC 5246](https://tools.ietf.org/html/rfc5246)，2008年）和TLS 1.3（[RFC 8446](https://tools.ietf.org/html/rfc8446)，2018年）。
  - 在[浏览器](https://zh.wikipedia.org/wiki/瀏覽器)、[电子邮件](https://zh.wikipedia.org/wiki/電子郵件)、[即时通信](https://zh.wikipedia.org/wiki/即時通訊)、[VoIP](https://zh.wikipedia.org/wiki/VoIP)、[网络传真](https://zh.wikipedia.org/wiki/網絡傳真)等应用程序中，广泛使用这个协议。
  - 许多网站，如[Google](https://zh.wikipedia.org/wiki/Google)、[Facebook](https://zh.wikipedia.org/wiki/Facebook)、[Wikipedia](https://zh.wikipedia.org/wiki/Wikipedia)等也以这个协议来创建安全连线，发送资料。
  - 目前已成为[互联网](https://zh.wikipedia.org/wiki/互联网)上保密通信的**工业标准。**

- SSL包含记录层（Record Layer）和[传输层](https://zh.wikipedia.org/wiki/传输层)，记录层协议确定传输层数据的封装格式。
- 传输层安全协议使用[X.509](https://zh.wikipedia.org/wiki/X.509)认证，之后
  - 利用非对称加密演算**来对通信方做身份认证**，之后**交换对称密钥**作为**会谈密钥**（[Session key](https://zh.wikipedia.org/wiki/Session_key)）。
  - 这个**会谈密钥**是用来**将通信两方交换的资料做加密**，保证两个应用间通信的保密性和可靠性，使客户与服务器应用之间的通信不被攻击者窃听。

### SSL技术的通用性

- 在采用 SSL 后，HTTP 就拥有了 HTTPS 的加密、证书和完整性保护这些功能。
-  SSL 是独立于 HTTP 的协议，所以不光是 HTTP 协议，其他运行在应用层的 SMTP 和 Telnet 等协议均可配合 SSL 协议使用。
- 可以说 SSL是当今世界上应用最为广泛的网络安全技术。



### SSL 客户端认证

- 从使用用户 ID 和密码的认证方式方面来讲，**只要二者的内容正确，即可认证是本人的行为**。
  - 但如果**用户 ID 和密码被盗**，就很有可能被第三者**冒充**。
- 利用 SSL 客户端认证则可以**避免该情况的发生**。
  -  **SSL 客户端认证**是**借由 HTTPS 的客户端证书**完成认证的方式。
  -  凭借客户端证书认证，服务器可**确认访问是否来自已登录的客户端**。



#### SSL 客户端认证的认证步骤

> 为达到 SSL 客户端认证的目的，需要事先将客户端证书**分发给客户端**。 
>
> 

步骤 1： 

服务器接收到需要认证资源的请求，会**发送 Certificate Request 报文**，**要求客户端提供客户端证书**。
步骤 2： 

用户选择要发送的**客户端证书**后，客户端会把**客户端证书信息**以 **Client Certificate 报文**方式**发送给服务器**。

步骤 3： 

**服务器验证客户端证书**验证通过后方可领取**证书内客户端的公开密钥**，然后**开始 HTTPS 加密通信**。



### 更多https&ssl



- [HTTPS双向认证（Mutual TLS authentication) (aliyun.com)](https://help.aliyun.com/document_detail/160093.html)
- 双向认证，顾名思义，**客户端和服务器端都需要验证对方的身份**，在建立HTTPS连接的过程中，**握手的流程比单向认证多了几步**。
- 单向认证的过程，**客户端从服务器端下载服务器端公钥证书进行验证**，然后**建立安全通信通道**。
- 双向通信流程，客户端除了需要从服务器端下载服务器的公钥证书进行验证外，**还需要把客户端的公钥证书上传到服务器端给服务器端进行验证**，<u>等双方都认证通过了，才开始建立安全通信通道进行数据传输</u>。

## https

###  HTTPS通信

![image-20220528174538708](https://img-blog.csdnimg.cn/img_convert/bd1845954069af5964639fdb97fd5b50.png)

> - 如果在 HTTP 协议通信过程中使用**未经加密的明文**
> - 另外，对于 HTTP 来说，服务器也好，客户端也好，都是**没有办法确认通信方**的。
> - **很有可能并不是和原本预想的通信方在实际通信**。
> - 并且还需要考虑到接收到的报文**在通信途中已经遭到篡改这一可能性**。



- 为了统一解决上述这些问题，需要在 HTTP 上再加入**加密处理**和**认证**等机制。

- 我们把添加了加密及认证机制的 HTTP 称为 HTTPS（HTTP Secure）

- HTTP 协议中没有加密机制，但可以**通过和 SSL（Secure Socket Layer，安全套接层）或 TLS（Transport Layer Security，安全层传输协议）的组合使用**，加密 HTTP 的**通信内容**。
-  用 SSL 建立**安全通信线路**之后，就可以在这条线路上**进行 HTTP通信了**。

**与 SSL 组合使用的 HTTP 被称为 HTTPS**（**HTTP Secure，超文本传输安全协议**）或 **HTTP over TLS (早期:HTTP over SSL)**。



### https的改进目标



HTTPS 协议是由 HTTP 加上 [TLS](https://baike.baidu.com/item/TLS/2979545)/SSL 协议构建的可进行加密传输、身份认证的网络协议，主要通过[数字证书](https://baike.baidu.com/item/数字证书/326874)、[加密算法](https://baike.baidu.com/item/加密算法/2816213)、非对称密钥等技术完成互联网数据传输加密，实现互联网传输安全保护。

设计目标主要有三个。

（1）数据**保密性**：保证数据内容在传输的过程中不会被第三方查看。就像快递员传递包裹一样，都进行了封装，别人无法获知里面装了什么 。

（2）数据**完整性**：及时发现被第三方篡改的传输内容。就像快递员虽然不知道包裹里装了什么东西，但他有**可能中途调包**，数据完整性就是指如果被掉包，我们能轻松发现并拒收 

接收到的内容可能有误:

- 由于 HTTP 协议无法证明通信的报文完整性，因此，在请求或响应送出之后直到对方接收之前的这段时间内，即使请求或响应的内容遭到篡改，也没有办法获悉。
- 换句话说，没有任何办法确认，发出的请求 / 响应和接收到的请求 / 响应是前后相同的。
- 从某个 Web 网站上下载内容，是无法确定客户端下载的文件和服务器上存放的文件是否前后一致的。文件内容在传输途中可能已经被篡改为其他的内容。即使内容真的已改变，作为接收方的客户端也是觉察不到的。 
  像这样，请求或响应在传输途中，遭攻击者拦截并篡改内容的攻击称为**中间人攻击**（Man-in-the-Middle attack，MITM）。

（3）身份校验安全性：保证数据到达用户**期望的目的地**。就像我们邮寄包裹时，虽然是一个封装好的未掉包的包裹，但必须**确定这个包裹不会送错地方**，**通过身份校验来确保送对了地方**  。

### https的通信步骤

![image-20220528190426382](https://s2.loli.net/2022/05/28/JGucyBRKbA5wsVf.png)

- 步骤 1： 客户端通过发送 Client Hello 报文开始**SSL通信**。
  - 报文中包含客户端支持的 SSL 的指定版本、加密组件（Cipher Suite）列表（所使用的加密算法及密钥长度等）。 
- 步骤 2： 服务器可进行 SSL 通信时，会**以 Server Hello 报文作为应答**。
  - 和客户端一样，在报文中包含 SSL 版本以及加密组件。<u>服务器的加密组件内容是从接收到的客户端加密组件内筛选出来的</u>。 
- 步骤 3： 之后**服务器发送 Certificate 报文**。报文中**包含公开密钥证书**。 
- 步骤 4： 最后服务器<u>发送 Server Hello Done 报文通知客户端</u>，最**初阶段的 SSL 握手协商部分结束**。
- 步骤 5： SSL **第一次握手结束之后**，**客户端以 Client Key Exchange报文作为回应**。
  - 报文中包含通信加密中使用的一种被称为**Pre-master secret 的随机密码串**。
  - 该报文已用**步骤 3 中的公开密钥进行加密**。 
- 步骤 6： 接着**客户端继续发送 Change Cipher Spec 报文**。
  - 该报文会提示服务器，在此报文**之后的通信会采用 Pre-master secret密钥加密**。 
- 步骤 7： 客户端发送 Finished 报文。
  - 该报文包含连接至今**全部报文的整体校验值**。
  - 这次握手协商是否能够成功，要以服务器**是否能够正确解密该报文作为判定标准**。
- 步骤 8： 服务器同样发送 **Change Cipher Spec 报文**。

- 步骤 9： 服务器同样**发送 Finished 报文**。 
- 步骤 10： 服务器和客户端的 **Finished 报文交换完毕之后，SSL 连接就算建立完成**。
  - 当然，通信会受到 SSL 的保护。
  - 从此处**开始进行应用层协议的通信，即发送 <u>HTTP 请求</u>**。
- 步骤 11： 应用层协议通信，即发送 **HTTP 响应**。
- 步骤 12： 最后由**客户端断开连接**。
  - 断开连接时，发送 close_notify

### http和https对比

- HTTPS 并非是应用层的一种新协议。
- 只是 HTTP 通信接口部分用SSL（Secure Socket Layer）和 TLS（Transport Layer Security）协议代替而已。 
- 通常，HTTP 直接和 TCP 通信。当使用 SSL 时，则演变成先和SSL 通信，再由 SSL 和 TCP 通信了。
- 简言之，所谓 HTTPS，其实就是身披 SSL 协议这层外壳的 HTTP。

![image-20220528174728534](https://img-blog.csdnimg.cn/img_convert/8a27047c7852d093cf6f83a47d7832c8.png)

> - **Hypertext Transfer Protocol Secure** (**HTTPS**) is an extension of the [Hypertext Transfer Protocol](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol) (HTTP). 
> - It is used for [secure communication](https://en.wikipedia.org/wiki/Secure_communications) over a [computer network](https://en.wikipedia.org/wiki/Computer_network), and is widely used on the Internet.[[1\]](https://en.wikipedia.org/wiki/HTTPS#cite_note-1)[[2\]](https://en.wikipedia.org/wiki/HTTPS#cite_note-2) 
> - In HTTPS, the [communication protocol](https://en.wikipedia.org/wiki/Communication_protocol) is encrypted using [Transport Layer Security](https://en.wikipedia.org/wiki/Transport_Layer_Security) (TLS) or, **formerly**, Secure Sockets Layer (SSL). 
> - The protocol is therefore also referred to as **<u>HTTP over TLS</u>**,[[3\]](https://en.wikipedia.org/wiki/HTTPS#cite_note-3) or **HTTP over SSL**.

> - The principal **motivations** for HTTPS are
>   -  [authentication](https://en.wikipedia.org/wiki/Authentication) of the accessed [website](https://en.wikipedia.org/wiki/Website), and
>   -  protection of the [privacy](https://en.wikipedia.org/wiki/Information_privacy) and [integrity](https://en.wikipedia.org/wiki/Data_integrity) of the exchanged data while in transit. 
>   - It protects against [man-in-the-middle attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack), and the bidirectional [encryption](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation) of communications between a client and server protects the communications against [eavesdropping](https://en.wikipedia.org/wiki/Eavesdropping) and [tampering](https://en.wikipedia.org/wiki/Tamper-evident#Tampering).[[4\]](https://en.wikipedia.org/wiki/HTTPS#cite_note-httpse-4)[[5\]](https://en.wikipedia.org/wiki/HTTPS#cite_note-5) 
>   - The authentication aspect of HTTPS requires **<u>a trusted third party to sign server-side [digital certificates](https://en.wikipedia.org/wiki/Public_key_certificate).</u>** 
>     - This was historically an **expensive operation**, which meant <u>fully authenticated HTTPS connections were usually found only on secured payment transaction services and other secured corporate information systems</u> on the [World Wide Web](https://en.wikipedia.org/wiki/World_Wide_Web).
>     -  In 2016, a campaign by the [Electronic Frontier Foundation](https://en.wikipedia.org/wiki/Electronic_Frontier_Foundation) with the support of [web browser](https://en.wikipedia.org/wiki/Web_browser) developers led to the protocol becoming more prevalent.[[6\]](https://en.wikipedia.org/wiki/HTTPS#cite_note-6) (流行)
>     - HTTPS is now used more often by web users than the original non-secure HTTP, primarily to protect page authenticity on **all types of websites**; 
>       - secure accounts; 
>       - and to keep user communications, identity, and web browsing private.










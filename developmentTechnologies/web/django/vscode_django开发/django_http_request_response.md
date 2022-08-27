# http



![image-20220507180336240](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220507180336240.png)

![image-20220507185118756](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220507185118756.png)

## 1.1.请求与响应

内容协商: drf在django原有的基础上，新增了一个request对象继承到了APIVlew视图类，并在django原有的
HttpResponse响应类的基础上实现了一个子类rest_framework.response.Response响应类。这两个类，都是基于内容协商来完成数据的格式转换的。
request->parser类->识别客户端请求头中的Content-Type来完成数据转换成->类字典(QueryDict，字典的子类)
response-renderer->识别客户端请求头的"Accept"来提取客户单期望的返回数据格式，-→转换成客户端的期望格式数据

### 1.1.1 Request

REST framework传入视图的request对象不再是Django默认的HttpRequest对象，而是REST framework提供的扩展了HttpRequest类的Request类的对象。
REST framework 提供了Parser解析器，在接收到请求后会自动根据Content-Type指明的请求数据类型(如JSON、表单等）将请求数据进行parse解析，解析为类字典[QueryDict]对象保存到Request对象中。
Request对象的数据是自动根据前端发送数据的格式进行解析之后的结果。
I
无论前端发送的哪种格式的数据，我们都可以以统一的方式读取数据。

#### ViewSet&APIView

![image-20220507185816712](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220507185816712.png)

#### mixins

![image-20220507185702080](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220507185702080.png)

#### GenericAPIV

![image-20220507185724822](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220507185724822.png)

![image-20220508115157976](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/image-20220508115157976.png)


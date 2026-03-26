#  mermaid简单流程图
- `mermaid`是一种画流图的方便的工具,使用简单的语法,就可以渲染出相关的流图,对于小型图很友好
- 在markdown中也有所应用

## 使用入门

- 不同图型的语法不同/效果不同
  - 在同一段mermaid代码在图型(A)中是有效且正确的,
  - 但是在图型(B)中可能就是另一种意思,甚至直接导致渲染失败



```c
flowchart LR
    id1((This is the text in the circle))
```

```mermaid
flowchart LR
    id1((This is the text in the circle))
```



```py
flowchart TB
    y<--P-->x[x]
    y(y)<--Q-->z[z]
    z<--R-->x
```



```mermaid
flowchart TB
    y<--P-->x[x]
    y(y)<--Q-->z[z]
    z<--R-->x

```
### 圆柱体

- ```mermaid
  flowchart LR
  	H1[H1]<--->st1[(switch1)]<-->st2[(switch2)]<-->H2[H2]
  	st1<-->st3[(stiwtch3)]<-->st2
  ```

  

- ```
  flowchart LR
  	H1[H1]<--->st1[(switch1)]<-->st2[(switch2)]<-->H2[H2]
  	st1<-->st3[(stiwtch3)]<-->st2
  ```

  

##  不稳定性

### 引擎版本
 由于引擎版本不同,同样的代码效果可能不同

```csharp
flowchart LR
	a---b & d 
	b---c & e
	c---b 
	c---d
    c---e
```

```mermaid
flowchart LR
	a---b & d 
	b---c & e
	c---b 
	c---d
    c---e
```
###  绘制方向(TB/LR)

```csharp
flowchart TB
	a---b & d 
	b---c & e
	c---b 
	c---d
    c---e
```

```mermaid
flowchart TB
	a---b & d 
	b---c & e
	c---b 
	c---d
    c----e
```
###  端点调换

```csharp
flowchart LR
	a---b & d 
	b---c & e
	c---b 
	c---d
	e---c
```

```mermaid
flowchart LR
	a---b & d 
	b---c & e
	c---b 
	c---d
	e---c
 


```

##  改善线条
- 拉长边/上下行调换

```csharp
flowchart LR
	a---b & d 
	c----d & e
	b---c & e
```

```mermaid
flowchart LR
	a---b & d 
	c----d & e
	b---c & e

```

```csharp
flowchart LR
	a---b & d 
	c---d & e
	b---c & e
```

```mermaid
flowchart LR
	a---b & d 
	c---d & e
	b---c & e
```

## 子图👺

### 例子1

- ```m
  flowchart LR
  subgraph  
      M[主机]
  end
      M<==>IO[I/O接口]<==>dc
  subgraph  IO设备 
      dc[设备控制器]-->机,电,磁,光部件
  end
  ```

  



- ```mermaid
  flowchart LR
  subgraph  
      M[主机]
  end
      M<==>IO[I/O接口]<==>dc
  subgraph  IO设备 
      dc[设备控制器]-->机,电,磁,光部件
  end
  ```

### 例字2

- ```mermaid
    flowchart TD
        A[Start] --> B{Is it?}
        B -->|Yes| C[OK]
        C --> D[Rethink]
        D --> B
        B ---->|No| E[End]
        %%flowchart TB   
        c1-->a2
        
        subgraph one
        a1-->a2
        end
        subgraph two
        b1-->b2
        end
        subgraph three
        c1-->c2
        end
       
    ```
    
    - ```m
      flowchart TD
          A[Start] --> B{Is it?}
          B -->|Yes| C[OK]
          C --> D[Rethink]
          D --> B
          B ---->|No| E[End]
          %%flowchart TB   
          c1-->a2
          
          subgraph one
              a1-->a2
          end
      
          subgraph two
              b1-->b2
          end
              subgraph three
              c1-->c2
          end
         
      ```
    
      

### 例子3

- ```mermaid
    flowchart LR
        c1-->a2
        subgraph one
        a1--->a2
        end
        subgraph two
        b1-->b2
        end
        subgraph three
        c1--->c2
        end
        one---> two
        three--> two
        two--> c2
    
    ```

    - ```m
        flowchart LR
            c1-->a2
            %%子图1
            subgraph one
                a1--->a2
            end
        	%%子图2
            subgraph two
                b1-->b2
            end
        	%%子图3
            subgraph three
                c1--->c2
            end
        	%%组织
        	one---> two
            three--> two
            two--> c2
        
        ```

        


### VLAN

```mermaid
flowchart TB
	subgraph ss
	s1[s1]<-->s2[s2]
	end
	subgraph vlan10.
	s1<--->A
	s1<--->B
	s1<--->A1
	s1<--->B1
	end
	subgraph vlan20.
    s1<--->C
	s1<-->D
	end
	subgraph vlan10. 
	s2<-->E
	s2<-->E1
	end
	subgraph vlan20
	s2<-->F
	s2<-->F1
	end
```

- ```tex
  flowchart TB
  	subgraph ss
  	s1[s1]<-->s2[s2]
  	end
  	subgraph vlan10.
  	s1<--->A
  	s1<--->B
  	s1<--->A1
  	s1<--->B1
  	end
  	subgraph vlan20.
      s1<--->C
  	s1<-->D
  	end
  	subgraph vlan10. 
  	s2<-->E
  	s2<-->E1
  	end
  	subgraph vlan20
  	s2<-->F
  	s2<-->F1
  	end
  ```

  

#### 路由网络

- 双路由器三网络

- 

  ```mermaid
  flowchart LR
  	subgraph net1
  	 H1 & H2
  	end
  	
  	%%subgraph R1.
  	%%R1
  	%%end
  	
  	subgraph net2
  	 H3
  	end
  	
  	subgraph net3
  	 H4
  	end
  	net1<-->R1[(R1)]<-->net2<-->R2[(R2)]<--->net3
  	
  ```

  - ```tex
    flowchart LR;
    	subgraph net1
    	 H1 & H2
    	end
    	
    	%%subgraph R1.
    	%%R1
    	%%end
    	
    	subgraph net2
    	 H3
    	end
    	
    	subgraph net3
    	 H4
    	end
    	net1<-->R1[(R1)]<-->net2<-->R2[(R2)]<--->net3
    	
    ```

    

- 

  ```mermaid
  flowchart LR
  	subgraph net1
  	Net1<-->H1 & H2
  	end
  	
  	%%subgraph R1.
  	%%R1
  	%%end
  	
  	subgraph net2
  	Net2<-->H3
  	end
  	
  	subgraph net3
  	Net3<-->H4
  	end
  	net1<-->R1[(R1)]<-->net2<-->R2<--->net3
  	
  ```

  - ```tex
    flowchart LR
    	subgraph net1
    	Net1<-->H1 & H2
    	end
    	
    	%%subgraph R1.
    	%%R1
    	%%end
    	
    	subgraph net2
    	Net2<-->H3
    	end
    	
    	subgraph net3
    	Net3<-->H4
    	end
    	net1<-->R1[(R1)]<-->net2<-->R2<--->net3
    	
    ```


### 集线器@交换机@路由器@网络混合系统(color demo)

```mermaid
flowchart LR
	S[[switch]]<-->H(hub) & H1[H1:192.168.2.2] & H2[H2:192.168.3.3]
	style H fill:#f9f,stroke:#93,stroke-width:1px
    style S fill:#fd926e,stroke:#93,stroke-width:1px
	H<-.->H3[H3:192.168.3.251] & H4[H4:192.168.3.252]
    R2[(R2)]<-->S & R1[(R1)]
    R1<--> InternetS([InternetS])
    style R2 fill:#fdf26e,stroke:#93,stroke-width:1px
    R2<-->Net([Net:201.1.1.0/24])<-->DNS(DNS server:201.1.1.1)
	
```

## 计算图

- ```mermaid
  flowchart LR
  	a_num --->|2|x1
  	apple --->|100|x1((x)) 
  	x1 -->|200| +1((+))
  	pear --->|150|x2((x))
      p_num --->|3|x2
  	x2 -->|450| +1((+))
  	+1-->|650|x3((x))
  	tax----->|1.1|x3
  	x3-->|715|price
  	
  	
  ```

  

- ```mermaid
  flowchart LR
  	a_num --->|2|x1
  	apple --->|100|x1((x)) 
  	x1 -->|200| +1((+))
  	pear --->|150|x2((x))
      p_num --->|3|x2
  	x2 -->|450| +1((+))
  	+1-->|650|x3((x))
  	tax----->|1.1|x3
  	x3-->|715|price
  	
  	price-..->|1|x3
  	x3-..->|650|tax
  	x3-..->|1.1|+1
  	+1-..->|1.1|x1
  	+1-..->|1.1|x2
  	x1-..->|110|a_num
  	x1-..->|2.2|apple
  	x2-..->|3.3|pear
  	x2-..->|165|p_num
  ```


## 案例

```mermaid
graph LR
    A(SDT) --查找-->B([DCT])
    B --"设备状态(status)"--- C{busy?}
    D(挂到PCB任务队列)
    E[计算本次分配安全性]
    C -->|yes|D 
    C -->|no|E
    F(执行分配)
    G{save?}
    E-->G
    G-->|yes|F
    G-->|No|D
```



# 🎈ref of mermaid

- [mermaid - Markdownish syntax for generating flowcharts, sequence diagrams, class diagrams, gantt charts and git graphs. (mermaid-js.github.io)](https://mermaid-js.github.io/mermaid/#/)
  支持一下类型的图型,各有个的语法

  * [Flowchart](https://mermaid-js.github.io/mermaid/#/flowchart "Flowchart")

  * [Sequence diagram](https://mermaid-js.github.io/mermaid/#/sequenceDiagram "Sequence diagram")

  * [Class Diagram](https://mermaid-js.github.io/mermaid/#/classDiagram "Class Diagram")

  * [State Diagram](https://mermaid-js.github.io/mermaid/#/stateDiagram "State Diagram")

  * [Entity Relationship Diagram](https://mermaid-js.github.io/mermaid/#/entityRelationshipDiagram "Entity Relationship Diagram")

  * [User Journey](https://mermaid-js.github.io/mermaid/#/user-journey "User Journey")

  * [Gantt](https://mermaid-js.github.io/mermaid/#/gantt "Gantt")

  * [Pie Chart](https://mermaid-js.github.io/mermaid/#/pie "Pie Chart")

  * [Requirement Diagram](https://mermaid-js.github.io/mermaid/#/requirementDiagram "Requirement Diagram")

  * [Gitgraph (Git) Diagram 🔥](https://mermaid-js.github.io/mermaid/#/gitgraph "Gitgraph (Git) Diagram 🔥")

  * [Other Examples](https://mermaid-js.github.io/mermaid/#/examples "Other Examples")
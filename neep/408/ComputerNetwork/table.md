## Layer architecture\[[edit](https://en.wikipedia.org/w/index.php?title=OSI_model&action=edit&section=4)\]

The recommendation X.200 describes seven layers, labelled 1 to 7. Layer 1 is the lowest layer in this model.

| Layer | [Protocol data unit](https://en.wikipedia.org/wiki/Protocol_data_unit) (PDU) | Function[\[23\]](https://en.wikipedia.org/wiki/OSI_model#cite_note-23) |
| --- | --- | --- |
| Host  
layers | 7 | [Application](https://en.wikipedia.org/wiki/Application_layer) | [Data](https://en.wikipedia.org/wiki/Data_(computing)) | High-level [APIs](https://en.wikipedia.org/wiki/API), including resource sharing, remote file access |
| 6 | [Presentation](https://en.wikipedia.org/wiki/Presentation_layer) | Translation of data between a networking service and an application; including [character encoding](https://en.wikipedia.org/wiki/Character_encoding), [data compression](https://en.wikipedia.org/wiki/Data_compression) and [encryption/decryption](https://en.wikipedia.org/wiki/Encryption) |
| 5 | [Session](https://en.wikipedia.org/wiki/Session_layer) | Managing communication [sessions](https://en.wikipedia.org/wiki/Session_(computer_science)), i.e., continuous exchange of information in the form of multiple back-and-forth transmissions between two nodes |
| 4 | [Transport](https://en.wikipedia.org/wiki/Transport_layer) | [Segment](https://en.wikipedia.org/wiki/Packet_segmentation), [Datagram](https://en.wikipedia.org/wiki/Datagram) | Reliable transmission of data segments between points on a network, including [segmentation](https://en.wikipedia.org/wiki/Packet_segmentation), [acknowledgement](https://en.wikipedia.org/wiki/Acknowledgement_(data_networks)) and [multiplexing](https://en.wikipedia.org/wiki/Multiplexing) |
| Media  
layers | 3 | [Network](https://en.wikipedia.org/wiki/Network_layer) | [Packet](https://en.wikipedia.org/wiki/Network_packet) | Structuring and managing a multi-node network, including [addressing](https://en.wikipedia.org/wiki/Address_space), [routing](https://en.wikipedia.org/wiki/Routing) and [traffic control](https://en.wikipedia.org/wiki/Network_traffic_control) |
| 2 | [Data link](https://en.wikipedia.org/wiki/Data_link_layer) | [Frame](https://en.wikipedia.org/wiki/Frame_(networking)) | Transmission of data frames between two nodes connected by a physical layer |
| 1 | [Physical](https://en.wikipedia.org/wiki/Physical_layer) | [Bit](https://en.wikipedia.org/wiki/Bit), [Symbol](https://en.wikipedia.org/wiki/Symbol_rate#Symbols) | Transmission and reception of raw bit streams over a physical medium |
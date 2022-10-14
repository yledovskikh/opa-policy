package suppliers

default allow := false                              # unless otherwise defined, allow is false

allow := true {                                     # allow is true if...
    input.client_id == data.client[i].id
    data.client[i].balance == 0
    input.operation == "PUT"
}

allow := true {                                     # allow is true if...
    input.client_id == data.client[i].id
    data.client[i].balance == 0
    input.operation == "PUT"
}


#violation[supplier.id] {                              # a server is in the violation set if...
#    some supplier
#    data.clients[i].id == input.client_id
#    data.clients[i].balance>0
#}
#
#violation[server.id] {                              # a server is in the violation set if...
#    server := input.servers[_]                      # it exists in the input.servers collection and...
#    server.protocols[_] == "telnet"                 # it contains the "telnet" protocol.
#}
#
#public_server[server] {                             # a server exists in the public_server set if...
#    some i, j
#    server := input.servers[_]                      # it exists in the input.servers collection and...
#    server.ports[_] == input.ports[i].id            # it references a port in the input.ports collection and...
#    input.ports[i].network == input.networks[j].id  # the port references a network in the input.networks collection and...
#    input.networks[j].public                        # the network is public.
#}

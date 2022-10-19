package provider

default allow = false                              # unless otherwise defined, allow is false
default is_enabled_provider = false
# default is_client_operation = false

allow {
    count(is_client_operation)
#    is_enabled_provider
}

#int1[tt]{
#tt := input.client_id
#}
is_client_operation[id] {
	some i

	id := client_id
#	input.client_id == 100
#	input.client_id == 100
	100 == data.clients[i].id
#	input.client_id == data.clients[i].id
#    data.clients[i].balance == 0
#    input.operation == "PUT"
}

is_enabled_provider {
	input.provider_id == data.providers[i].id
    data.providers[i].status == "enabled"
}

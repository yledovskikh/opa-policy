package provider

default allow  := false                              # unless otherwise defined, allow is false
default is_enabled_provider := false

allow{
    is_client_operation
    is_enabled_provider
}

allow{
    "aa" == "aa"
}

is_client_operation {
	some i
	client_id:=input.client_id
	client_id == data.clients[i].id
    data.clients[i].balance == 0
    input.operation != "PUT"
}

is_enabled_provider {
	input.provider_id == data.providers[i].id
    data.providers[i].status == "enabled"
}

package Cx

types := {"init_container", "container"}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true

	object.get(containers[y].resources.requests, "memory", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].resources.requests.memory is set", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].resources.requests.memory is undefined", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true

	object.get(containers.resources.requests, "memory", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.resources.requests", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.resources.requests.memory is set", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.resources.requests.memory is undefined", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true
	object.get(containers[y], "resources", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].resources is set", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].resources is undefined", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true
	object.get(containers, "resources", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.resources is set", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.resources is undefined", [resourceType, name, types[x]]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_array(containers) == true

	object.get(containers[y].resources, "requests", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s[%d].resources.requests is set", [resourceType, name, types[x], y]),
		"keyActualValue": sprintf("%s[%s].spec.%s[%d].resources.requests is undefined", [resourceType, name, types[x], y]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	spec := resource[name].spec
	containers := spec[types[x]]

	is_object(containers) == true

	object.get(containers.resources, "requests", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].spec.%s.resources", [resourceType, name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[%s].spec.%s.resources.requests is set", [resourceType, name, types[x]]),
		"keyActualValue": sprintf("%s[%s].spec.%s.resources.requests is undefined", [resourceType, name, types[x]]),
	}
}
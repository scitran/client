def constrain_element(element, constraints):
    result = {
        element:constraints
    }
    return result

def constant_score(query_body):
    return {'constant_score':{'query':query_body}}

def bool(*relations):
    result = {'bool':{}}
    for relation in relations:
        result['bool'].update(relation)
    return result

def must(*relations):
    result = {'must':list(relations)}
    return result

def should(*relations):
    result = {'should':list(relations)}
    return result

def must_not(*relations):
    result = {'must_not':list(relations)}
    return result

def match(field_name, field_value):
    return {'match':{field_name:field_value}}

def multi_match(field_names, field_value):
    result = {
        'multi_match': {
            'query': field_value,
            'fields': field_names
        }
    }
    return result


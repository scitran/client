from collections import namedtuple

'''
When trying to use filters that this query builder doesn't support, you can directly
use FieldQuery to generate appropriate queries that can be passed to `query(...).filter()`.

For example, to find projects that start with "psy" that belong to a group, you might do
client.search(query(Projects).filter(
    FieldQuery('projects', {
        "prefix": {
            "label": "psy"
        }
    }),
    Groups.name.match('myGroup'),
))
'''
FieldQuery = namedtuple('FieldQuery', ['document_name', 'query'])


class FieldQueryBuilder(object):
    def __init__(self, document, name):
        self.document = document
        self.name = name

    def _match(self, item):
        return {'query': {'match': {self.name: item}}}

    def match(self, item):
        return FieldQuery(self.document._name, self._match(item))

    def in_(self, items):
        return FieldQuery(self.document._name, {
            'or': [
                self._match(item)
                for item in items
            ]
        })


class DocumentQueryBuilder(object):
    def __init__(self, name):
        self._name = name

    def __getattr__(self, name):
        return FieldQueryBuilder(self, name)


class Query(object):
    def __init__(self, path):
        if isinstance(path, DocumentQueryBuilder):
            self.path = path._name
        else:
            self.path = path

    def filter(self, *filters):
        result = dict(path=self.path)

        # group filters by document name
        filters_by_document = {}
        for f in filters:
            filters_by_document.setdefault(
                f.document_name, []).append(f)

        for document_name, document_filters in filters_by_document.iteritems():
            result[document_name] = {
                'filtered': {
                    'filter': {
                        'and': [
                            f.query
                            for f in document_filters
                        ]
                    }
                }
            }

        return result


def query(path):
    return Query(path)

Files = DocumentQueryBuilder('files')
Collections = DocumentQueryBuilder('collections')
Sessions = DocumentQueryBuilder('sessions')
Projects = DocumentQueryBuilder('projects')
Acquisitions = DocumentQueryBuilder('acquisitions')
Groups = DocumentQueryBuilder('groups')

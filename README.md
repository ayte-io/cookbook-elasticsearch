# ayte-elasticsearch

Cookbook with extensions not present in official ElasticSearch cookbook

## Resources

### Common properties

All resources share same set of common properties:

| property      | description                                                  |
|:--------------|:-------------------------------------------------------------|
| cluster       | Cluster name, doesn't affect anything besides resource names |
| host          | Target host                                                  |
| port          | Target host port                                             |
| tls           | Whether to use HTTPS instead of HTTP                         |
| user          | Basic authorization user                                     |
| password      | Basic authorization password                                 |
| authorization | Alternative `Authorization:` header                          |
| timeout       | Timeout for HTTP requests (in seconds)                       |

If `authorization` is set, it will override basic auth user and 
password. Also authorization accepts objects that respond to `:apply`
method, passing request into such method.

### elasticsearch_request

Performs request to elasticsearch, expecting non-4xx/5xx response.
Basic block for building other custom resources.

actions: :execute

| property       | description                                |
|:---------------|:-------------------------------------------|
| type           | HTTP method                                |
| path           | URI path                                   |
| body           | Request payload                            |
| parameters     | Query parameters, `key => value / value[]` |
| headers        | Headers hash                               | 
| ignore_missing | Whether to consider 404 as success         |

Body may be either nil, string, object responding to :read or arbitrary
object that will be automatically serialized to JSON.

### elasticsearch_status_wait

Waits until elasticsearch comes into target state.

actions :execute

| property | description                                |
|:---------|:-------------------------------------------|
| status   | Cluster status to wait for (name property) |

### elasticsearch_alias

Manages single alias

actions: :create, :include, :exclude, :remove

| property | description                |
|:---------|:---------------------------|
| name     | Alias name (name property) |
| index    | Index or indices to manage |

:create and :remove actions fully control alias and either delete all 
non-specified indices or alias itself. :include and :exclude actions 
only ensure that specified indices are present or absent in alias.

Index property may contain array of strings/symbols or be a 
comma-separated string.

### elasticsearch_index

Creates, manages or destroys single index.

actions: :create, :remove

| property      | description                                           |
|:--------------|:------------------------------------------------------|
| name          | Index name (name property)                            |
| settings      | Index settings, as string or hash, optional           |
| mapping       | Mapping, as string or hash, optional                  |
| mapping_type  | Document type to apply mapping to, defaults to `_doc` |
| active_shards | Number of shards to approve changes                   |

Settings and mapping are optional and will be applied only if present.
See corresponding sections for explanations.

### elasticsearch_index_settings

Applies provided settings to index.

actions: :execute

| property | description                |
|:---------|:---------------------------|
| index    | Index name (name property) |
| content  | Settings as string or hash |

### elasticsearch_index_mapping

Applies provided mapping.
                        
actions: :execute

| property | description                                   |
|:---------|:----------------------------------------------|
| index    | Index name (name property)                    |
| type     | Type to apply mapping for, defaults to `_doc` |
| content  | Mapping as hash or JSON string                |

### elasticsearch_index_merge

Enforces index merge.
                    
actions: :execute

| property               | description                                           |
|:-----------------------|:------------------------------------------------------|
| index                  | Index name (name property)                                            |
| max_num_segments       | Maximum allowed number of segments                    |
| flush                  | Whether to perform flush (defaults to true)           |
| only_expunge_deletions | Whether to process deletions only (defaults to false) |

### elasticsearch_document

Manages single elasticsearch document.

actions: :create, :remove

| property | description                                    |
|:---------|:-----------------------------------------------|
| id       | Document id (mandatory, name property)         |
| index    | Index name                                     |
| type     | Document type name                             |
| source   | Document source, either as hash or JSON string |
| refresh  | Whether to refresh index                       |

### elasticsearch_bulk

Performs bulk request.

actions: :execute

| property | description                                             |
|:---------|:--------------------------------------------------------|
| index    | Default index name                                      |
| type     | Default document type name                              |
| content  | Bulk request as string / hash / :read-responding object |

### elasticsearch_bulk_file

Performs bulk request using file source.

actions: :execute

| property | description                  |
|:---------|:-----------------------------|
| path     | Path to file (name property) |
| index    | Default index name           |
| type     | Default document type name   |

File resolution is lazy, so it is safe to specify paths created during 
converge.

### elasticsearch_bulk_directory

Performs bulk requests using all matching files in specified directory

actions: :execute

| property | description                                                                  |
|:---------|:-----------------------------------------------------------------------------|
| path     | Path to directory (name property)                                            |
| pattern  | Glob pattern used to match directory contents, defaults to `**.{json,jsons}` |
| index    | Default index name                                                           |
| type     | Default document type name                                                   |

Resolution is done in lazy way, so it is safe to specify paths created 
during converge.

### elasticsearch_bulk_cookbook_file

Performs bulk request using cookbook file as request source.

actions: :execute

| property | description                                 |
|:---------|:--------------------------------------------|
| path     | Relative cookbook path (name property)      |
| cookbook | Cookbook name, defaults to current cookbook |
| index    | Default index name                          |
| type     | Default document type name                  |

### elasticsearch_bulk_cookbook_directory

Performs bulk requests using files from cookbook directory.

actions: :execute

| property | description                                                                  |
|:---------|:-----------------------------------------------------------------------------|
| path     | Relative cookbook path (name property)                                       |
| cookbook | Cookbook name, defaults to current cookbook                                  |
| pattern  | Glob pattern used to match directory contents, defaults to `**.{json,jsons}` |
| index    | Default index name                                                           |
| type     | Default document type name                                                   |

This may not work well if specified directory exists directly under 
files directory, it may be necessary to put it inside `default` 
directory. 

## Recipes

### setup

This is the only recipe exported by this cookbook, it installs required
chef gem and it's build dependencies.

## Licensing

Ayte Labs, 2019 / MIT License / Do what comes natural. 

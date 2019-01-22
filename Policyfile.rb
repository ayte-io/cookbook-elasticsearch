name 'ayte-elasticsearch'

default_source :supermarket

cookbook 'ayte-elasticsearch', path: '.'

run_list 'ayte-elasticsearch::default'



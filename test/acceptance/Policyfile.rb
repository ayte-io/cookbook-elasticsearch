name 'ayte-elasticsearch-acceptance'

default_source :supermarket

cookbook 'ayte-elasticsearch-acceptance', path: '.'
cookbook 'ayte-elasticsearch', path: '../..'

run_list 'ayte-elasticsearch-acceptance::default'



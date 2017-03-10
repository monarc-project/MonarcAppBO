<?php
/**
 * Global Configuration Override
 *
 * You can use this file for overriding configuration values from modules, etc.
 * You would place values in here that are agnostic to the environment and not
 * sensitive to security.
 *
 * @NOTE: In practice, this file will typically be INCLUDED in your source
 * control, so do not include passwords or other sensitive information in this
 * file.
 */
return array(
    // DOCTRINE CONF
    'service_manager' => array(
        'factories' => array(
            'doctrine.cache.mycache' => 'MonarcCore\Service\DoctrineCacheServiceFactory',
            'doctrine.monarc_logger' => 'MonarcCore\Service\DoctrineLoggerFactory',
        ),
    ),
    'doctrine' => array(
        'connection' => array(
            'orm_default' => array(
                'driverClass' => 'Doctrine\DBAL\Driver\PDOMySql\Driver',
                'params' => array(
                    'host' => '127.0.0.1',
                    'port' => 3306,
                    'user' => 'root',
                    'password' => '',
                    'dbname' => 'monarc_common',
                    'charset' => 'utf8',
                    'driverOptions' => array(
                        PDO::ATTR_STRINGIFY_FETCHES => false,
                        PDO::ATTR_EMULATE_PREPARES => false,
                        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8',
                    ),
                ),
            ),
            'orm_cli' => array(
                'driverClass' => 'Doctrine\DBAL\Driver\PDOMySql\Driver',
                'params' => array(
                    'host' => '127.0.0.1',
                    'port' => 3306,
                    'user' => 'root',
                    'password' => '',
                    'dbname' => 'monarc_cli',
                    'charset' => 'utf8',
                    'driverOptions' => array(
                        PDO::ATTR_STRINGIFY_FETCHES => false,
                        PDO::ATTR_EMULATE_PREPARES => false,
                        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8',
                    ),
                ),
            ),
        ),
        /*'migrations_configuration' => array(
            'orm_default' => array(
                'name' => 'Monarc Migrations',
                'directory' => __DIR__."/../../migrations",
                'namespace' => 'Monarc\Migrations',
                'table' => 'migrations',
                'column' => 'version',
            ),
            'orm_cli' => array(
                'name' => 'Monarc Common Migrations',
                'directory' => __DIR__."/../../migrations",
                'namespace' => 'MonarcCli\Migrations',
                'table' => 'migrations',
                'column' => 'version',
            ),
        ),*/
        'entitymanager' => array(
            'orm_default' => array(
                'connection'    => 'orm_default',
                'configuration' => 'orm_default'
            ),
            'orm_cli' => array(
                'connection'    => 'orm_cli',
                'configuration' => 'orm_cli',
            ),
        ),
        'configuration' => array(
            'orm_default' => array(
                'metadata_cache'        => 'mycache',
                'query_cache'           => 'mycache',
                'result_cache'          => 'mycache',
                'driver'                => 'orm_default', // This driver will be defined later
                'generate_proxies'      => true,
                'proxy_dir'             => 'data/DoctrineORMModule/Proxy',
                'proxy_namespace'       => 'DoctrineORMModule\Proxy',
                'filters'               => array(),
                'datetime_functions'    => array(),
                'string_functions'      => array(),
                'numeric_functions'     => array(),
                'second_level_cache'    => array(),
                'sql_logger'            => 'doctrine.monarc_logger',
            ),
            'orm_cli' => array(
                'metadata_cache'        => 'mycache',
                'query_cache'           => 'mycache',
                'result_cache'          => 'mycache',
                'driver'                => 'orm_cli', // This driver will be defined later
                'generate_proxies'      => true,
                'proxy_dir'             => 'data/DoctrineORMModule/Proxy',
                'proxy_namespace'       => 'DoctrineORMModule\Proxy',
                'filters'               => array(),
                'datetime_functions'    => array(),
                'string_functions'      => array(),
                'numeric_functions'     => array(),
                'second_level_cache'    => array(),
                'sql_logger'            => 'doctrine.monarc_logger',
            ),
        ),
    ),

    'spool_path_create' => getcwd() .'/data/json/create/',//default location path where the json file enabling the creation of the environment of the client should be generated
    'spool_path_delete' => getcwd() .'/data/json/delete/', //default location path where the json file enabling the deletion of the environment of the client should be generated

    // END DOCTRINE CONF
);

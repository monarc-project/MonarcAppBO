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
            'doctrine.cache.mycache' => function(\Zend\ServiceManager\ServiceManager $sm){
                $arrayCache = new \Doctrine\Common\Cache\ArrayCache();

                if(getenv('APPLICATION_ENV') == 'production'){
                    if(extension_loaded('apc')){
                        $apcCache = new \Doctrine\Common\Cache\ApcCache();
                        $chainCache = new \Doctrine\Common\Cache\ChainCache([$apcCache,$arrayCache]);
                        return $chainCache;
                    }elseif(extension_loaded('apcu')){
                        $apcuCache = new \Doctrine\Common\Cache\ApcuCache();
                        $chainCache = new \Doctrine\Common\Cache\ChainCache([$apcuCache,$arrayCache]);
                        return $chainCache;
                    }
                    // TODO: untested / add param for memchache(d) host & port
                    /*elseif(extension_loaded('memcache')){
                        $memcache = new \Memcache();
                        if($memcache->connect('localhost', 11211)){
                            $cache = new \Doctrine\Common\Cache\MemcacheCache();
                            $cache->setMemcache($mem);
                            $chainCache = new \Doctrine\Common\Cache\ChainCache([$cache,$arrayCache]);
                            return $chainCache;
                        }
                    }elseif(extension_loaded('memcached')){
                        $memcache = new \Memcached();
                        if($memcache->connect('localhost', 11211)){
                            $cache = new \Doctrine\Common\Cache\MemcachedCache();
                            $cache->setMemcached($mem);
                            $chainCache = new \Doctrine\Common\Cache\ChainCache([$cache,$arrayCache]);
                            return $chainCache;
                        }
                    }*/
                }
                return $arrayCache;
            },
        ),
    ),
    'doctrine' => array(
        'connection' => array(
            'orm_default' => array(
                'driverClass' => 'Doctrine\DBAL\Driver\PDOMySql\Driver',
                'params' => array(
                    'host' => 'localhost',
                    'port' => 3306,
                    'user' => 'user',
                    'password' => 'password',
                    'dbname' => 'monarc_common',
                    'charset' => 'utf8',
                    'driverOptions' => array(
                        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8',
                    ),
                ),
            ),
            'orm_cli' => array(
                'driverClass' => 'Doctrine\DBAL\Driver\PDOMySql\Driver',
                'params' => array(
                    'host' => 'localhost',
                    'port' => 3306,
                    'user' => 'root',
                    'password' => 'password',
                    'dbname' => 'monarc_cli',
                    'charset' => 'utf8',
                    'driverOptions' => array(
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
            ),
        ),
    ),
    // END DOCTRINE CONF
);

<?php
return array (
    'backend' => [
        'frontName' => 'admin_frmwrk',
    ],
    'crypt' => [
        'key' => 'ec3545d314cc97c31e3eaaaf6a6d1890',
    ],
    'session' => [
        'save' => 'files',
    ],
    'db' => [
        'table_prefix' => '',
        'connection' => [
            'default' => [
                'host' => 'localhost',
                'dbname' => 'PROJECT_NAME',
                'username' => 'root',
                'password' => 'root',
                'model' => 'mysql4',
                'engine' => 'innodb',
                'initStatements' => 'SET NAMES utf8;',
                'active' => '1', 
            ]
        ] 
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default',
        ]
        ],
    'x-frame-options' => 'SAMEORIGIN',
    'MAGE_MODE' => 'developer',
    'cache_types' => [
            'compiled_config' => 1,
            'config' => 1,
            'layout' => 1,
            'block_html' => 1,
            'collections' => 1,
            'reflection' => 1,
            'db_ddl' => 1,
            'eav' => 1,
            'customer_notification' => 1,
            'config_integration' => 1,
            'config_integration_api' => 1,
            'full_page' => 1,
            'config_webservice' => 1,
            'translate' => 1,
            'vertex' => 1,
            'amasty_shopby' => 1,
            'ec_cache' => 1
    ],
    'install' => [
        'date' => 'Tue, 16 May 2021 09:13:48 +0000',
    ],
    'system' => [
        'default' => [
            'web' => [
                'unsecure' => [
                    'base_url' => 'https://PROJECT_NAME.test/',
                    'base_link_url' => '{{unsecure_base_url}}',
                    'base_static_url' => '{{unsecure_base_url}}static/',
                    'base_media_url' => '{{unsecure_base_url}}media/'
                ],
                'secure' => [
                    'base_url' => 'https://PROJECT_NAME.test/',
                    'base_link_url' => '{{secure_base_url}}',
                    'base_static_url' => '{{secure_base_url}}static/',
                    'base_media_url' => '{{secure_base_url}}media/'
                ],
                'default' => [
                    'front' => 'cms'
                ],
                'cookie' => [
                    'cookie_path' => null,
                    'cookie_domain' => null
                ]
            ],
            'dev' => [
                'restrict' => [
                    'allow_ips' => null
                ],
                'js' => [
                    'session_storage_key' => 'collected_errors'
                ],
                'static' => [
                    'sign' => '0'
                ]
            ],
        ],
    ],
    'modules' => [
        'Frmwrk_VarnishReconnect' => 0
    ],
    'downloadable_domains' => [
        'PROJECT_NAME.test'
    ]
);
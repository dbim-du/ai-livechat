<?php
namespace app\seller\model;

use think\Db;
use think\Model;

// 1. 配置数据库连接（可以在config/database.php 中全局配置）
// 数据库连接
// define('config',[
//             'type'        => 'pgsql',
//             'hostname'    => '127.0.0.1',
//             'database'    => 'dify',
//             'username'    => 'postgres',
//             'password'    => 'p2DXFwYyAAHjBhDL',//'p2DXFwYyAAHjBhDL',//'difyai123456',
//             'hostport'    => '5433',
//             'charset'     => 'utf8',
//             'schema'      => 'public',         // PostgreSQL 模式名
//         ]);
define('config',ENVCONST['dify_db_config']);
class DifyData extends Model
{

    // 生成 uuid 
    function createSimpleUUID() {
        return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }

    // 插入 商家基本信息
    public function insertDifyData($name,$email)
    {
        if (count($this->selDifyUser($email))>0) {
            // echo "用户已存在";
            return false;
        }
        // echo "不 已存在";

        // 生成 tenant_id  tenant_account_joins_id account_id
        // 主号 的 工作工作空间 ID
        //$tenant_id = '6ba8bf32-42d1-4ebc-b1ff-25a530baa1bb';//$this->createSimpleUUID();
        $tenant_id = ENVCONST['tenant_id'];//$this->createSimpleUUID();
        $tenant_account_joins_id = $this->createSimpleUUID();
        $account_id = $this->createSimpleUUID();

        // 1、插入工作空间表(tenants)
        //if(!$this->insertTenants($tenant_id,$name)) return false;
        // 2、插入 商家账户信息表(accounts)
        if(!$this->insertAccounts($account_id,$name,$email)) return false;
        // 3、插入租户表(tenant_account_joins)
        if(!$this->insertTenantAccountJoins($tenant_account_joins_id,$account_id,$tenant_id)) return false;

        return true;
    }


    // 2、插入 商家账户信息表(accounts)
    private function insertAccounts($account_id,$name,$email)
    {
        // 1. 配置数据库连接（可以在config/database.php 中全局配置）

        // 2. 连接PostgreSQL（动态连接方式）
        try {
            //echo "正在连接数据库...<br/>";
            $pg = Db::connect(config);
            //echo "连接成功<br/>";
            $datetime = date('Y-m-d H:i:s');
            
            // 3. 准备插入数据
            $data = [
                'id' => $account_id,
                'name' => $name,
                'email' => $email,
                'password' => 'NzE2ZTkyMTIzZGM1N2RhODNlN2FjMmQ5NjliNDhhNmY0NzM5YmM4NDcwZGMxZjI3ZDZlNzg3OGEwNGIyMWQ1NA==',
                'password_salt' => 'DZN4ImBTPSxspePHZbSVOQ==',
                //'avatar' => '123123',
                'interface_language' => 'en-US',
                'interface_theme' => 'light',
                'timezone' => 'America/New_York',
                'last_login_at' => $datetime,
                'last_login_ip' => '127.0.0.1',
                'status' => 'active',
                'initialized_at' => $datetime,
                'created_at' => $datetime,
                'updated_at' => $datetime,
                'last_active_at' => $datetime,
            ];
            
            // 4. 执行插入操作 

            // 使用参数绑定的SQL 
            $sql = "INSERT INTO accounts 
            (id, name, email, password, password_salt, interface_language, interface_theme, timezone, last_login_at, last_login_ip, status, initialized_at, created_at, updated_at, last_active_at) 
            VALUES 
            (:id, :name, :email, :password, :password_salt, :interface_language, :interface_theme, :timezone, :last_login_at, :last_login_ip, :status, :initialized_at, :created_at, :updated_at, :last_active_at)";

            // 执行带参数绑定的SQL 
            $result = $pg->execute($sql, $data);
            if ($result) {
                //echo "数据库连接正常并可执行查询";
                return true;
            } else {
                //echo "数据库连接正常但查询失败";
                return false;
            }
        } catch (\Exception $e) {
            //echo "数据库连接失败<br/>:".$e->getMessage();
            return false;
            
        }
    }


    // 3、插入租户表(tenant_account_joins)
    private function insertTenantAccountJoins($tenant_account_joins_id,$account_id,$tenan_id)
    {
        // 1. 配置数据库连接（可以在config/database.php 中全局配置）

        // 2. 连接PostgreSQL（动态连接方式）
        try {
            $pg = Db::connect(config);
            $datetime = date('Y-m-d H:i:s');
            
            // 3. 准备插入数据
            $data = [
                'id' => $tenant_account_joins_id,
                'tenant_id' => $tenan_id,
                'account_id' => $account_id,
                'role' => 'editor',
                'created_at' => $datetime,
                'updated_at' => $datetime,
                'current' => true
            ];
            
            // 4. 执行插入操作 

            // 使用参数绑定的SQL 
            $sql = "INSERT INTO tenant_account_joins 
            (id, tenant_id, account_id, role, created_at, updated_at, current) 
            VALUES 
            (:id, :tenant_id, :account_id, :role, :created_at, :updated_at, :current)";

            // 执行带参数绑定的SQL 
            $result = $pg->execute($sql, $data);
            if ($result) {
                //echo "数据库连接正常并可执行查询";
                return true;
            } else {
                //echo "数据库连接正常但查询失败";
                return false;
            }
        } catch (\Exception $e) {
            //echo "数据库连接失败<br/>:".$e->getMessage();
            return false;
            
        }
    }


    // 1、插入工作空间表(tenants)
    private function insertTenants($tenant_id,$name)
    {
        // 1. 配置数据库连接（可以在config/database.php 中全局配置）

        // 2. 连接PostgreSQL（动态连接方式）
        try {
            $pg = Db::connect(config);
            $datetime = date('Y-m-d H:i:s');
            
            // 3. 准备插入数据
            $data = [
                'id' => $tenant_id,
                'name' => $name.' Workspace',
                'encrypt_public_key' => 
                '-----BEGIN PUBLIC KEY-----
                MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzS7WIPMrIW8ijWMmYVfb
                kLxO3UDVUI+a3w/SqRqYeMm4W16u/Bit/nKgufmnF1pXrBj2c+zyp3NuVthdn5Zk
                9mhDLdlcM4DPsr/iv1QrFiGxEG+vyf9hj8BwJTX6oRdBiEXPGSMSYO+/YGV4zORk
                V87T23CRpQDQSOB3Byd46iPdq/84Cz/mbSOL/4AC2I41KMru4467obf5k1vonHJQ
                7VdZxuLgaFzkpL+98k2ijtKeVKm6aM0pO4L5gYI3Mrukt/02B5xGbzE6DBzHm+2a
                uQeO24VeEp33D9C90JAXTzHqhYWQj8AKanel+34u5RSaEa//FI3BIYDrqKry0bEY
                LQIDAQAB
                -----END PUBLIC KEY-----',
                'plan' => 'basic',
                'status' => 'normal',
                'created_at' => $datetime,
                'updated_at' => $datetime
            ];
            
            // 4. 执行插入操作 

            // 使用参数绑定的SQL 
            $sql = "INSERT INTO tenants 
            (id, name, encrypt_public_key, plan, status, created_at, updated_at) 
            VALUES 
            (:id, :name, :encrypt_public_key, :plan, :status, :created_at, :updated_at)";

            // 执行带参数绑定的SQL 
            $result = $pg->execute($sql, $data);
            if ($result) {
                //echo "数据库连接正常并可执行查询";
                return true;
            } else {
                //echo "数据库连接正常但查询失败";
                return false;
            }
        } catch (\Exception $e) {
            //echo "数据库连接失败<br/>:".$e->getMessage();
            return false;
            
        }
    }

    
    // 根据 邮箱 查询 Dify 用户是否存在
    public function selDifyUser($email)
    {
        // 1. 配置数据库连接（可以在config/database.php 中全局配置）

        // 2. 创建PostgreSQL对象（动态连接方式）
        try {
            // 3. 创建SQL语句

            $pg = Db::connect(config);
            $data = [
                'email' => $email
            ];
            // 执行带参数绑定的SQL 
            $sql = "SELECT * FROM accounts WHERE email = :email";
            $result = $pg->query($sql, $data,false,false); // false 是否在主服务器读操作、false 是否返回PDO对象
            //echo json_encode($result);
            return $result;

            // 4. 执行SQL语句
        }catch (\Exception $e) {
            //echo "数据库执行失败<br/>:".$e->getMessage();
            return null;
        }
    }


    /**
     * 根据 app_code 查询 dify 应用、工作空间、用户信息
     */ 
    public function selDifyAppTenantUser($app_code)
    {
        $pg = Db::connect(config);
        
        // 1、查询 sites Dify 应用信息
        $data_sites = [
            'code' => $app_code
        ];
        // 执行带参数绑定的SQL 
        $sql_sites = "SELECT * FROM sites WHERE code = :code";
        $result_sites = $pg->query($sql_sites, $data_sites,false,false);
        
        if (count($result_sites)<1) {
            return null;
        }
        // var_dump('<p />app_id:'.$result_sites[0]['app_id']);


        //2、查询 workflows 信息
        $app_id = $result_sites[0]['app_id'];
        $data_workflows = [
            'app_id' => $app_id,
        ];
        // 执行带参数绑定的SQL 
        $sql_workflows = "SELECT * FROM workflows WHERE app_id = :app_id LIMIT 1";
        $result_workflows = $pg->query($sql_workflows, $data_workflows,false,false);
        if (count($result_workflows)<1) {
            return null;
        }
        // var_dump('<p />workflows:'.json_encode($result_workflows));


        //3、查询 tenant_account_joins 信息
        $tenant_id = $result_workflows[0]['tenant_id'];
        $data_tenant_account_joins = [
            'tenant_id' => $tenant_id,
        ];
        // 执行带参数绑定的SQL 
        $sql_tenant_account_joins = "SELECT * FROM tenant_account_joins WHERE tenant_id = :tenant_id LIMIT 1";
        $result_tenant_account_joins= $pg->query($sql_tenant_account_joins, $data_tenant_account_joins,false,false);
        if (count($result_tenant_account_joins)<1) {
            return null;
        }
        // var_dump('<p />tenant_account_joins:'.json_encode($result_tenant_account_joins));


        //4、查询 accounts 信息
        $account_id = $result_tenant_account_joins[0]['account_id'];
        $data_accounts = [
            'id' => $account_id,
        ];
        // 执行带参数绑定的SQL 
        $sql_accounts = "SELECT * FROM accounts WHERE id = :id LIMIT 1";
        $result_accounts= $pg->query($sql_accounts, $data_accounts,false,false);
        if (count($result_accounts)<1) {
            return null;
        }
        // var_dump('<p />accounts:'.json_encode($result_accounts));



        $data = [
            'site_id' => $result_sites[0]['id'],
            'site_code' => $result_sites[0]['code'],
            'app_id' => $result_sites[0]['app_id'],
            'tenant_id' => $result_workflows[0]['tenant_id'],
            'account_id' => $result_tenant_account_joins[0]['account_id'],
            'account_name' => $result_accounts[0]['name'],
            'email' => $result_accounts[0]['email'],
        ];


        return $data;

        // return '1234567890';
    }

    /**
     * 查询 客服关联 app_id 
     */
    public function selDifyApp($app_code)
    {
        $pg = Db::connect(config);
        
        // 1、查询 sites Dify 应用信息
        $data_sites = [
            'code' => $app_code
        ];
        // 执行带参数绑定的SQL 
        $sql_sites = "SELECT * FROM sites WHERE code = :code";
        $result_sites = $pg->query($sql_sites, $data_sites,false,false);
        
        if (count($result_sites)<1) {
            return null;
        }
        $data = [
            'site_id' => $result_sites[0]['id'],
            'site_code' => $result_sites[0]['code'],
            'app_id' => $result_sites[0]['app_id'],
        ];

        return $data;
    }


}
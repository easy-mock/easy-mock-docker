### docker-compose 文件内容
```
version: '3'

services:
  mongodb:
    image: mongo:3.4.1
    volumes:
      # ./data/db 数据库文件存放地址，根据需要修改为本地地址
      - './data/db:/data/db'
    networks:
      - easy-mock
    restart: always

  redis:
    image: redis:4.0.6
    command: redis-server --appendonly yes
    volumes:
      # ./data/redis redis 数据文件存放地址，根据需要修改为本地地址
      - './data/redis:/data'
    networks:
      - easy-mock
    restart: always

  web:
    image: easymock/easymock:1.6.0
    command: /bin/bash -c "npm start"
    ports:
      - 7300:7300
    volumes:
      # 日志地址，根据需要修改为本地地址
      - './logs:/home/easy-mock/easy-mock/logs'
      # 配置地址，请使用本地配置地址替换
      # - './production.json:/home/easy-mock/easy-mock/config/production.json'
    networks:
      - easy-mock
    restart: always

networks:
  easy-mock:

```

### 使用方式
1. 安装 docker-compose
2. 新建文件 `docker-compose.yml` 并将上面 docker-compose 文件内容复制进入 `docker-compose.yml`，然后将内容中注释位置替换为自己需要的本地地址即可。主要有三个需要替换的地方，数据库文件存储位置，日志文件存储位置，自定义配置文件本地地址。
3. 启动：`docker-compose up -d`

自定义配置参考 [easymock readme](https://github.com/easy-mock/easy-mock) 中的配置小节。

**注意**
* **使用容器方式运行不需要指定 `db` 和 `redis` 参数**
* **production.json 配置中注意以下问题**

```
{
  "port": 7300,
  "host": "0.0.0.0",
  "pageSize": 30,
  "proxy": false,
  "db": "mongodb://mongodb/easy-mock" # host 请务必替换为mongodb, 而非 localhost
  "unsplashClientId": "",
  "redis": {
    "keyPrefix": "[Easy Mock]",
    "port": 6379,
    "host": "redis", // 请勿使用 localhost，换 "redis"
    "password": "",
    "db": 0
  },
  ......
  ......
}
```
* **如果遇到 easymock docker 实例报文件权限错误**
```
Error: EACCES: permission denied....
```
**可在项目根目录执行以下命令**
```
chmod 777 /yourfile/logs
```